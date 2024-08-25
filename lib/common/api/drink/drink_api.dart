import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import '../../manager/data_storage_manager.dart';
import '../../manager/request_manager.dart';
import '../../utils/response_utils.dart';

class DrinkApi {
  DrinkApi._privateConstructor() {
    // 读取token
    String? userInfoDataStr = _storage.getString("drink798UsrApiToken");
    if (userInfoDataStr != null) {
      Map<String, dynamic> map = jsonDecode(userInfoDataStr);
      map.forEach((key, value) {
        _token[key] = value;
      });
    } else {
      _storage.setString("drink798UsrApiToken", jsonEncode(_token));
    }
  }

  static final DrinkApi _instance =
  DrinkApi._privateConstructor();

  factory DrinkApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();
  // 储存管理
  final _storage = DataStorageManager();
  // 用户凭证数据
  final Map<String, dynamic> _token = {
    "uid": "",
    "eid": "",
    "token": "",
  };

  /// 获取慧生活798登录验证码
  /// [doubleRandom] 随机浮点数
  /// [timestamp] 时间戳
  /// return 验证码图片
  Future<Uint8List> userCaptcha(
      {required String doubleRandom, required String timestamp}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.responseType = ResponseType.bytes;
    String url = "https://i.ilife798.com/api/v1/captcha/";
    Map<String, dynamic> params = {
      "s": doubleRandom,
      "r": timestamp,
    };
    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      final result = value.data;
      return result;
    });
  }

  /// 获取短信验证码
  /// [doubleRandom] 随机浮点数
  /// [photoCode] 图片验证码
  /// [phone] 图片验证码
  /// return 是否成功
  Future<bool> userMessageCode(
      {required String doubleRandom,
        required String photoCode,
        required String phone}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/acc/login/code";
    Map<String, dynamic> data = {
      "s": doubleRandom,
      "authCode": photoCode,
      "un": phone,
    };
    return await _request.post(url, data: data, options: options).then((value) {
      final result = value.data;
      return result["code"] == 0;
    });
  }

  /// 开始登录
  /// [messageCode] 短信验证码
  /// [phone] 手机号
  /// return 是否成功
  Future<bool> userLogin(
      {required String phone, required String messageCode}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/acc/login";
    Map<String, dynamic> data = {
      "openCode": "",
      "authCode": messageCode,
      "un": phone,
      "cid": "sbsbsbsbsbsbsbsbsbsbsb",
    };
    return await _request.post(url, data: data, options: options).then((value) {
      final result = ResponseUtils.transformObj(value);
      _token["uid"] = result["data"]["al"]["uid"];
      _token["eid"] = result["data"]["al"]["eid"];
      _token["token"] = result["data"]["al"]["token"];
      _storage.setString("drink798UsrApiToken", jsonEncode(_token));
      return result["code"] == 0;
    });
  }

  /// 获取设备列表
  /// 返回设备列表
  Future<List<Map>> deviceList() async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/ui/app/master";
    options.headers = {
      "Authorization": _token["token"],
    };

    return await _request.get(url, options: options).then((value) {
      final result = ResponseUtils.transformObj(value);
      if (result["data"]["account"] == null) {
        return [
          {
            "id": "404",
            "name": "Account failure",
          }
        ];
      }

      // 如果没有喜爱列表
      if (result["data"]["favos"] == null) {
        return [];
      }

      final List favos = result["data"]["favos"];
      return favos
          .map((e) {
        return {
          "id": e["id"],
          "name": e["name"],
        };
      })
          .toList()
          .reversed
          .toList();
    });
  }

  /// 收藏或取消收藏设备
  /// return 返回是否收藏成功
  Future<bool> favoDevice({required String id, required bool isUnFavo}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/dev/favo";
    options.headers = {
      "Authorization": _token["token"],
    };

    Map<String, dynamic> params = {
      "did": id,
      "remove": isUnFavo,
    };

    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      final result = ResponseUtils.transformObj(value);
      return result["code"] == 0;
    });
  }

  /// 开始喝水
  /// [id] 设备id
  /// return 开启设备是否成功
  Future<bool> startDrink({required String id}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/dev/start";
    options.headers = {
      "Authorization": _token["token"],
    };

    Map<String, dynamic> params = {
      "did": id,
      "upgrade": true,
      "rcp": false,
      "stype": 5,
    };

    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      final result = ResponseUtils.transformObj(value);
      return result["code"] == 0;
    });
  }

  /// 结束喝水
  /// [id] 设备id
  /// return 开启设备是否成功
  Future<bool> endDrink({required String id}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/dev/end";
    options.headers = {
      "Authorization": _token["token"],
    };

    Map<String, dynamic> params = {
      "did": id,
    };

    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      final result = ResponseUtils.transformObj(value);
      return result["code"] == 0;
    });
  }

  /// 检测设备状态
  /// [id] 设备id
  /// return 设备是否可用
  Future<bool> isAvailableDevice({required String id}) async {
    Options options =
    _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    String url = "https://i.ilife798.com/api/v1/ui/app/dev/status";
    options.headers = {
      "Authorization": _token["token"],
    };

    Map<String, dynamic> params = {
      "did": id,
      "more": true,
      "promo": false,
    };

    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      final result = ResponseUtils.transformObj(value);
      return result["data"]["device"]["gene"]["status"] == 99;
    });
  }

  /// 获取Token
  /// return Token
  Future<String> getToken() async {
    return _token["token"];
  }

  /// 设置Token
  /// [token] Token
  Future<void> setToken({required String token}) async {
    _token["token"] = token;
    _storage.setString("drink798UsrApiToken", jsonEncode(_token));
  }
}
