import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../manager/request_manager.dart';

enum ScheduleUserStatus { loginTimeOut, success, fail }

class ScheduleUserApi {
  ScheduleUserApi._privateConstructor();

  static final ScheduleUserApi _instance =
      ScheduleUserApi._privateConstructor();

  factory ScheduleUserApi() {
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
  Future<ScheduleUserStatus> autoLoginEducationalSystem({
    required String userAccount,
    required String userPassword,
  }) async {
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
        .post("/jsxsd/xk/LoginToXk", params: params, options: options)
        .then((value) {
      bool status = value.data == "";
      switch (status) {
        case true:
          return ScheduleUserStatus.success;
        case false:
          return ScheduleUserStatus.fail;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      return ScheduleUserStatus.loginTimeOut;
    });
  }

  /// 登录api
  Future<ScheduleUserStatus> loginEducationalSystem(
      {required String userAccount, required String userPassword}) async {

    Response res = await _request.get(
      "/",
      options: _request.cacheOptions
          .copyWith(policy: CachePolicy.noCache)
          .toOptions(),
    );

    res = await _request.post(
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
      "userAccount": userAccount,
      "userPassword": "",
      "encoded": encoded,
      "loginMethod": "logon",
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

    bool status = res.data == "";
    switch (status) {
      case true:
        String url = res.headers.value("location")!;
        url = url.split("/jsxsd")[1];
        url = "/jsxsd$url";
        res = await _request.get(url, options: options);
        url = res.headers.value("location")!;
        url = url.split("/jsxsd")[1];
        url = "/jsxsd$url";
        res = await _request.get(url, options: options);
        return ScheduleUserStatus.success;
      case false:
        return ScheduleUserStatus.fail;
    }
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
