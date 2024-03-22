import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/manager/RequestManager.dart';

class UserApi {
  UserApi._privateConstructor();

  static final UserApi _instance = UserApi._privateConstructor();

  factory UserApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  /// 获取验证码数据
  Future<Uint8List> getCaptcha() async {
    Random random = Random();
    double t = random.nextDouble();

    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.responseType = ResponseType.stream;
    return await _request
        .get("/verifycode.servlet?t=$t", options: options)
        .then((value) async {
      final stream = await (value.data as ResponseBody).stream.toList();
      final result = BytesBuilder();
      for (Uint8List subList in stream) {
        result.add(subList);
      }

      return result.takeBytes();
    });
  }

  /// 登录api
  Future<bool> loginEducationalSystem(
      {required String userAccount,
      required String userPassword,
      required String captcha}) async {
    Response res = await _request.post(
      "/Logon.do?method=logon&flag=sess",
      options: _request.cacheOptions
          .copyWith(policy: CachePolicy.noCache)
          .toOptions(),
    );
    String dataStr = res.data;
    var scode = dataStr.split("#")[0];
    var sxh = dataStr.split("#")[1];
    var code = "$userAccount%%%$userPassword";
    var encoded = "";
    for (var i = 0; i < code.length; i++) {
      if (i < 20) {
        encoded = encoded +
            code.substring(i, i + 1) +
            scode.substring(0, int.parse(sxh.substring(i, i + 1)));
        scode =
            scode.substring(int.parse(sxh.substring(i, i + 1)), scode.length);
      } else {
        encoded = encoded + code.substring(i, code.length);
        i = code.length;
      }
    }

    Map<String, dynamic> params = {
      "userAccount": "",
      "userPassword": "",
      "RANDOMCODE": captcha,
      "encoded": encoded,
    };

    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.validateStatus = (status) {
      return status! < 500;
    };
    options.followRedirects = false;
    options.contentType = "application/x-www-form-urlencoded";

    res = await _request.post("/Logon.do?method=logon",
        params: params, options: options);
    if (res.data == "") {
      String url = res.headers.value("location")!;
      url = url.split("/jsxsd")[1];
      url = "/jsxsd$url";
      res = await _request.get(url, options: options);
      url = res.headers.value("location")!;
      url = url.split("/jsxsd")[1];
      url = "/jsxsd$url";
      res = await _request.get(url, options: options);
      return true;
    } else {
      return false;
    }
  }

  /// 自动登录api
  Future<bool> autoLoginEducationalSystem(
      {required String userAccount, required String userPassword}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.followRedirects = false;
    options.validateStatus = (status) {
      return status! < 500;
    };

    Map<String, dynamic> params = {
      "userAccount": "",
      "userPassword": "",
    };

    // base64加密
    String userAccountBase64 = base64Encode(utf8.encode(userAccount));
    String userPasswordBase64 = base64Encode(utf8.encode(userPassword));
    String encoded = "$userAccountBase64%%%$userPasswordBase64";
    params["encoded"] = encoded;

    return await _request
        .post("/jsxsd/xk/LoginToXk",
            params: params, options: options)
        .then((value) {
      return value.data == "";
    });
  }

  /// 获取个人信息
  Future<Map<String, dynamic>> userInfo({CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    return await _request
        .get("/jsxsd/framework/xsMain_new.jsp?t1=1", options: options)
        .then((value) async {
      Document document = parse(value.data);
      Element? userinfo =
          document.getElementsByClassName("middletopttxlr").firstOrNull;
      if (userinfo != null) {
        List<Element> infoList =
            userinfo.getElementsByClassName("middletopdwxxcont");

        infoList.removeAt(0);
        String name = infoList[0].text;
        String studentId = infoList[1].text;
        String academyName = infoList[2].text;
        String professionalName = infoList[3].text;
        String className = infoList[4].text;

        return {
          "name": name,
          "studentId": studentId,
          "academyName": academyName,
          "professionalName": professionalName,
          "className": className,
        };
      } else {
        return {};
      }
    });
  }
}
