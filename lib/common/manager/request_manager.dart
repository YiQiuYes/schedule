import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class RequestManager {
  RequestManager._privateConstructor();
  static final RequestManager _instance = RequestManager._privateConstructor();
  factory RequestManager() {
    return _instance;
  }

  Dio? _dio;

  late PersistCookieJar _persistCookieJar;

  final cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  /// 获取dio
  Dio getDio() {
    if (_dio == null) {
      _dio ??= Dio(BaseOptions(
        baseUrl: "http://jwxt.hut.edu.cn",
      ));
      _dio?.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    }
    return _dio!;
  }

  /// 获取cookie管理器
  PersistCookieJar getCookieJar() {
    return _persistCookieJar;
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

  /// get请求
  Future<Response> get(String url,
      {Map<String, dynamic>? params, Options? options, Object? data}) async {
    if (options == null) {
      options = cacheOptions.toOptions(); // 为空则创建
      options.method = "GET";
      options.responseType = ResponseType.json;
    }

    Response res = await getDio()
        .get(url, queryParameters: params, options: options, data: data);
    return res;
  }

  /// post请求
  Future<Response> post(String url,
      {Map<String, dynamic>? params, Object? data, Options? options}) async {
    if (options == null) {
      options = cacheOptions.toOptions(); // 为空则创建
      options.method = "POST";
      options.responseType = ResponseType.json;
    }

    Response response = await getDio()
        .post(url, queryParameters: params, options: options, data: data);
    return response;
  }
}
