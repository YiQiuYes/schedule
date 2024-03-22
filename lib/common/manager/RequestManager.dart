import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class RequestManager {
  RequestManager._privateConstructor();
  static final RequestManager _instance = RequestManager._privateConstructor();
  factory RequestManager() {
    return _instance;
  }

  Dio? _dio;

  late PersistCookieJar _persistCookieJar;
  // 数据存储器
  final _storage = DataStorageManager();
  final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(minutes: 30),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  /// 获取dio
  Dio getDio() {
    if (_dio == null) {
      _dio ??= Dio(BaseOptions(
        baseUrl: "https://jwxt.hut.edu.cn",
      ));
      _dio?.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    }
    return _dio!;
  }

  /// 清除Cookie
  Future<void> clearCookie() async {
    await _persistCookieJar.deleteAll();
  }

  /// 初始化cookie管理器,main函数中调用
  Future<void> persistCookieJarInit() async {
    Directory tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    _persistCookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(tempPath),
    );
    // 添加拦截器
    getDio().interceptors.add(CookieManager(_persistCookieJar));
  }

  /// 判断是否登录失效
  Future<void> isLoginInvalid(Response response, String url) async {
    const urlIgnore = [
      "/Logon.do?method=logon",
      "/jsxsd/xk/LoginToXk"
    ];

    var data = response.data;
    if (data != null &&
        data is String &&
        !urlIgnore.any((element) => url.contains(element)) &&
        url != "/") {
      // 正则表达式检测是否包含 <title>登录</title>
      if (RegExp(r"<title>登录</title>").hasMatch(data)) {
        logger.i("登录失效");
        logger.i(url);
        await _storage.modifyMap("settings", "isLogin", false);
        GoRouter.of(GoRouteConfig.context).go(GoRouteConfig.login);
      }
    }
  }

  /// get请求
  Future<Response> get(String url,
      {Map<String, dynamic>? params, Options? options}) async {
    if (options == null) {
      options = cacheOptions.toOptions(); // 为空则创建
      options.method = "GET";
      options.responseType = ResponseType.json;
    }

    Response res =
        await getDio().get(url, queryParameters: params, options: options);
    await isLoginInvalid(res, url);
    return res;
  }

  /// post请求
  Future<Response> post(String url,
      {Map<String, dynamic>? params, Options? options}) async {
    if (options == null) {
      options = cacheOptions.toOptions(); // 为空则创建
      options.method = "POST";
      options.responseType = ResponseType.json;
    }

    Response response =
        await getDio().post(url, queryParameters: params, options: options);
    await isLoginInvalid(response, url);
    return response;
  }
}
