import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:encrypt/encrypt.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/response_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:pointycastle/asymmetric/api.dart';

import '../../manager/data_storage_manager.dart';
import '../../manager/request_manager.dart';

class HutUserApi {
  HutUserApi._privateConstructor() {
    // 读取token
    String? userInfoDataStr = _storage.getString("hutUsrApiToken");
    if (userInfoDataStr != null) {
      Map<String, dynamic> map = jsonDecode(userInfoDataStr);
      map.forEach((key, value) {
        _token[key] = value;
      });
    } else {
      _storage.setString("hutUsrApiToken", jsonEncode(_token));
    }
  }

  static final HutUserApi _instance = HutUserApi._privateConstructor();

  factory HutUserApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();
  // 储存管理
  final _storage = DataStorageManager();
  // 用户凭证数据
  final Map<String, dynamic> _token = {
    "idToken": "",
  };

  /// 获取指纹
  /// return 指纹
  Future<String> getFingerprint() async {
    var uuid = const Uuid();
    return uuid.v4().replaceAll("-", "");
  }

  /// 开始登录
  /// [username] 用户名
  /// [password] 密码
  /// return 是否成功
  Future<bool> userLogin(
      {required String username, required String password}) async {
    String url = "https://mycas.hut.edu.cn/cas";
    Map<String, dynamic> params = {
      "service":
          "https://portal.hut.edu.cn/?path=https://portal.hut.edu.cn/main.html#/Tourist",
    };
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String? execution = await _request
        .get(url, params: params, options: options)
        .then((value) async {
      // logger.i(value.data);
      Document doc = parse(value.data);
      Element? execution = doc.querySelector("[name=execution]");
      // logger.i(execution?.attributes["value"]);
      return execution?.attributes["value"];
    });

    String publicKeyStr = await _request
        .get("https://mycas.hut.edu.cn/cas/jwt/publicKey", options: options)
        .then((value) {
      return value.data;
    });

    // password RSA加密
    final publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
    final encrypt = Encrypter(RSA(publicKey: publicKey));
    final encrypted = encrypt.encrypt(password);

    Map<String, dynamic> data = {
      "username": username,
      "password": "__RSA__${encrypted.base64}",
      "cid": "",
      "captcha": "",
      "mfaState": "",
      "currentMenu": 1,
      "failN": 0,
      "execution": execution,
      "_eventId": "submit",
      "geolocation": "",
      "fpVisitorId": await getFingerprint(),
      "submit": "Login1",
    };

    // logger.i(data);

    url =
        "https://mycas.hut.edu.cn/cas/login?service=https://portal.hut.edu.cn/?path=https://portal.hut.edu.cn/main.html#/Tourist";
    options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.validateStatus = (status) {
      return status! < 500;
    };
    options.followRedirects = false;
    options.contentType = "application/x-www-form-urlencoded";
    return await _request
        .post(url, data: data, options: options)
        .then((value) async {
      bool isLogin = value.data == "";
      // logger.i(isLogin);
      if (isLogin) {
        String redirectUrl = value.headers.value("location")!;
        int ticketIndex = redirectUrl.indexOf("ticket=");
        int pathIndex = redirectUrl.indexOf("path=") + 5;
        int pathEndIndex = !redirectUrl.contains("&redirect=true")
            ? ticketIndex - 1
            : redirectUrl.indexOf("&redirect=true");
        String path = redirectUrl.substring(pathIndex, pathEndIndex);
        String jumpUrl = Uri.decodeFull(path);
        if (jumpUrl.contains("/AccessDenied")) {
          jumpUrl = "https://portal.hut.edu.cn/main.html#/Tourist";
        }
        int routerIndex = redirectUrl.contains("#/")
            ? redirectUrl.indexOf("#/")
            : redirectUrl.length;
        if (ticketIndex != -1) {
          String ticket = redirectUrl.substring(ticketIndex + 7, routerIndex);
          var decode = jsonDecode(utf8.decode(base64
              .decode(Uri.decodeFull(Uri.decodeFull(ticket).split(".")[1]))));
          String idToken = decode["idToken"];
          // logger.i(idToken);
          // 设置Token
          await setToken(token: idToken);
        }
      }
      return isLogin;
    });
  }

  /// 获取Token
  /// return Token
  String getToken() {
    return _token["idToken"];
  }

  /// 设置Token
  /// [token] Token
  Future<void> setToken({required String token}) async {
    _token["idToken"] = token;
    await _storage.setString("hutUsrApiToken", jsonEncode(_token));
  }

  /// 获取openid
  /// return openid
  Future<String> getOpenid() async {
    String url = "https://v8mobile.hut.edu.cn/zdRedirect/toSingleMenu";
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.validateStatus = (status) {
      return status! < 500;
    };
    options.followRedirects = false;
    options.headers = {
      "X-Id-Token": getToken(),
    };
    Map<String, dynamic> params = {
      "code": "openWater",
      "token": getToken(),
    };
    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      if (value.data != "") {
        return "";
      }
      String url = value.headers.value("location")!;
      // logger.i(url.split("openid=")[1]);
      return url.split("openid=")[1];
    });
  }

  /// 获取洗澡设备
  /// return 设备列表
  Future<Map<String, dynamic>> getHotWaterDevice() async {
    String url = "https://v8mobile.hut.edu.cn/bathroom/getOftenUsetermList";
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String openid = await getOpenid();
    options.headers = {
      "openid": openid,
    };
    Map<String, dynamic> params = {
      "openid": openid,
    };

    try {
      return await _request
          .post(url, params: params, options: options)
          .then((value) {
        if (value.data == "") {
          return {
            "code": 500,
          };
        }

        var data = ResponseUtils.transformObj(value);
        // logger.i(data);
        return {
          "code": 200,
          "data": data["resultData"]["data"].reversed.toList(),
        };
      });
    } catch (e) {
      return {
        "code": 500,
      };
    }
  }

  /// 检测未关闭的设备
  /// return 未关闭的设备
  Future<List> checkHotWaterDevice() async {
    String url = "https://v8mobile.hut.edu.cn/bathroom/selectCloseDeviceValve";
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String openid = await getOpenid();
    options.headers = {
      "openid": openid,
    };
    Map<String, dynamic> params = {
      "openid": openid,
    };
    Map<String, dynamic> data = {
      "openid": openid,
    };

    return await _request
        .post(url, params: params, data: data, options: options)
        .then((value) {
      var data = ResponseUtils.transformObj(value);
      bool isHave = data["result"] == "000000";
      if (isHave) {
        // logger.i(data["data"].first["poscode"]);
        String poscode = data["data"].first["poscode"];
        return [poscode];
      } else {
        return [];
      }
    });
  }

  /// 开始洗澡
  /// [device] 设备
  /// return 是否成功
  Future<bool> startHotWater({required String device}) async {
    String url = "https://v8mobile.hut.edu.cn/boiling/termcodeOpenValve";
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String openid = await getOpenid();
    options.headers = {
      "openid": openid,
    };
    Map<String, dynamic> params = {
      "openid": openid,
    };
    Map<String, dynamic> data = {
      "openid": openid,
      "poscode": device,
    };
    return await _request
        .post(url, params: params, data: data, options: options)
        .then((value) {
      // logger.i(value);
      var data = ResponseUtils.transformObj(value);
      // logger.i(data["resultData"]["result"] == "000000");
      return data["success"];
    });
  }

  /// 结束洗澡
  /// [device] 设备
  /// return 是否成功
  Future<bool> stopHotWater({required String device}) async {
    String url = "https://v8mobile.hut.edu.cn/boiling/endUse";
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String openid = await getOpenid();
    options.headers = {
      "openid": openid,
    };
    Map<String, dynamic> params = {
      "openid": openid,
    };
    Map<String, dynamic> data = {
      "openid": openid,
      "poscode": device,
      "openappid": "",
    };
    return await _request
        .post(url, params: params, data: data, options: options)
        .then((value) {
      // logger.i(value);
      var data = ResponseUtils.transformObj(value);
      // logger.i(data["resultData"]["result"] == "000000");
      return data["resultData"]["result"] == "000000";
    });
  }
}
