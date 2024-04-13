import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:schedule/api/learnThrough/LearnSignApi.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ResponseUtils.dart';

import '../../../common/manager/RequestManager.dart';

class LearnSignApiImpl extends LearnSignApi {
  LearnSignApiImpl._privateConstructor();

  static final LearnSignApiImpl _instance =
      LearnSignApiImpl._privateConstructor();

  factory LearnSignApiImpl() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  // 储存管理器
  final _storage = DataStorageManager();

  /// 储存签到成功的id
  Future<void> _saveSignId(String id) async {
    String? signIdsStr = _storage.getString("learnSignApiImplSignIds");
    List<dynamic> signIdList = [];
    if (signIdsStr != null) {
      signIdList = jsonDecode(signIdsStr);
    }

    if (signIdList.length > 100) {
      signIdList.clear();
    }

    signIdList.add(id);
    await _storage.setString("learnSignApiImplSignIds", jsonEncode(signIdList));
  }

  /// 检查是否签到过
  Future<bool> _checkSignId(String id) async {
    String? signIdsStr = _storage.getString("learnSignApiImplSignIds");
    List<dynamic> signIdList = [];
    if (signIdsStr != null) {
      signIdList = jsonDecode(signIdsStr);
    }
    return signIdList.contains(id);
  }

  /// 获取cookie中的值
  Future<String> _getCookieItem(String url, String key) async {
    return await _request
        .getCookieJar()
        .loadForRequest(Uri.parse(url))
        .then((value) {
      for (var element in value) {
        if (element.name == key) {
          return element.value;
        }
      }
      return "";
    });
  }

  /// 普通签到
  /// return: 签到结果
  @override
  Future<String> generalSign({
    required String name,
    required String activeId,
  }) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/pptSign/stuSignajax";
    String uid = await _getCookieItem(url, "_uid");
    String fid = await _getCookieItem(url, "fid");

    Map<String, dynamic> params = {
      "activeId": activeId,
      "uid": uid,
      "clientip": "",
      "latitude": "-1",
      "longitude": "-1",
      "appType": "15",
      "fid": fid,
      "name": name,
    };

    return await _request
        .get(url, options: options, params: params)
        .then((value) {
      final result = "${value.data}";
      if (result == "success") {
        _saveSignId(activeId);
      }
      return result;
    });
  }

  /// 手势签到
  /// return: 签到结果
  @override
  Future<String> gestureSign({
    required String name,
    required String activeId,
    required String signCode,
  }) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/pptSign/stuSignajax";
    String uid = await _getCookieItem(url, "_uid");
    String fid = await _getCookieItem(url, "fid");

    Map<String, dynamic> params = {
      "activeId": activeId,
      "uid": uid,
      "clientip": "",
      "latitude": "-1",
      "longitude": "-1",
      "appType": "15",
      "fid": fid,
      "name": name,
      "signCode": signCode,
    };

    return await _request
        .get(url, options: options, params: params)
        .then((value) {
      final result = "${value.data}";
      if (result == "success") {
        _saveSignId(activeId);
      }
      return result;
    });
  }

  /// 拍照签到
  /// return: 签到结果
  @override
  Future<String> photoSign({
    required String name,
    required String activeId,
    required String objectId,
  }) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/pptSign/stuSignajax";
    String uid = await _getCookieItem(url, "_uid");
    String fid = await _getCookieItem(url, "fid");

    Map<String, dynamic> params = {
      "activeId": activeId,
      "uid": uid,
      "clientip": "",
      "useragent": "",
      "latitude": "-1",
      "longitude": "-1",
      "appType": "15",
      "fid": fid,
      "objectId": objectId,
      "name": name,
    };

    return await _request
        .get(url, options: options, params: params)
        .then((value) {
      final result = "${value.data}";
      if (result == "success") {
        _saveSignId(activeId);
      }
      return result;
    });
  }

  /// 位置签到
  /// return: 签到结果
  @override
  Future<String> locationSign({
    required String name,
    required String address,
    required String activeId,
    required String lat,
    required String lon,
  }) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/pptSign/stuSignajax";
    String uid = await _getCookieItem(url, "_uid");
    String fid = await _getCookieItem(url, "fid");

    Map<String, dynamic> params = {
      "name": name,
      "address": address,
      "activeId": activeId,
      "uid": uid,
      "clientip": "",
      "latitude": lat,
      "longitude": lon,
      "fid": fid,
      "appType": "15",
      "ifTiJiao": "1",
    };

    return await _request
        .get(url, options: options, params: params)
        .then((value) {
      final result = "${value.data}";
      if (result == "success") {
        _saveSignId(activeId);
      }
      return result;
    });
  }

  /// 二维码签到
  /// return: 签到结果
  @override
  Future<String> qrCodeSign({
    required String enc,
    required String name,
    required String activeId,
    required String address,
    required String lat,
    required String lon,
    required String altitude,
  }) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/pptSign/stuSignajax";
    String uid = await _getCookieItem(url, "_uid");
    String fid = await _getCookieItem(url, "fid");

    Map<String, dynamic> params = {
      "enc": enc,
      "name": name,
      "activeId": activeId,
      "uid": uid,
      "clientip": "",
      "location": jsonEncode({
        "result": "1",
        "address": address,
        "latitude": lat,
        "longitude": lon,
        "altitude": altitude,
      }),
      "latitude": "-1",
      "longitude": "-1",
      "fid": fid,
      "appType": "15",
    };

    return await _request
        .get(url, options: options, params: params)
        .then((value) {
      final result = "${value.data}";
      if (result == "success") {
        _saveSignId(activeId);
      }
      return result;
    });
  }

  /// 查询签到信息
  /// return: 签到信息对象
  /// [courses] 课程列表 [{"courseId": "000", "classId": "000"}, ...]
  @override
  Future<Map> traverseCourseActivity({required List courses}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();
    String url =
        "https://mobilelearn.chaoxing.com/v2/apis/active/student/activelist";

    // 并发队列
    List<Future<Map>> task = [];
    for (Map<String, dynamic> course in courses) {
      Map<String, dynamic> params = {
        "fid": "0",
        "courseId": course["courseId"],
        "classId": course["classId"],
        "_": DateTime.now().millisecondsSinceEpoch,
      };

      final request = _request
          .get(url, params: params, options: options)
          .then((value) async {
        Map res = ResponseUtils.transformObj(value);
        if (res["data"] != null) {
          if (res["data"]["activeList"].length != 0 &&
              res["data"]["activeList"][0]["otherId"] != null) {
            final otherId = int.parse(res["data"]["activeList"][0]["otherId"]);
            // 判断是否有效签到活动
            if (otherId >= 0 &&
                otherId <= 5 &&
                res["data"]["activeList"][0]["status"] == 1) {
              // logger.i(DateTime.now().millisecondsSinceEpoch);
              // logger.i(res);
              // 判断是否签到过
              if (await _checkSignId(
                  res["data"]["activeList"][0]["id"].toString())) {
                return {};
              }

              // 活动开始超过2个小时则忽略
              if ((DateTime.now().millisecondsSinceEpoch -
                      res["data"]["activeList"][0]["startTime"]) <
                  7200000) {
                return {
                  "activeId": res["data"]["activeList"][0]["id"],
                  "name": res["data"]["activeList"][0]["nameOne"],
                  "courseId": course["courseId"],
                  "classId": course["classId"],
                  "otherId": otherId,
                };
              }
            }
          }
        }
        return {};
      });

      task.add(request);
    }

    // 等待并发结束
    List result = await Future.wait(task);
    for (var element in result) {
      if (element.isNotEmpty) {
        // logger.i(element.runtimeType);
        return element;
      }
    }

    return {};
  }

  /// 根据activeId获取签到信息
  /// [activeId] 活动id
  /// return: 签到信息对象
  @override
  Future<Map> getPPTActiveInfo({required String activeId}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();
    String url =
        "https://mobilelearn.chaoxing.com/v2/apis/active/getPPTActiveInfo";
    Map<String, dynamic> params = {
      "activeId": activeId,
    };
    return await _request
        .get(url, params: params, options: options)
        .then((value) {
      return ResponseUtils.transformObj(value)["data"];
    });
  }

  /// 预签到处理
  /// [activeId] 活动id
  /// [courseId] 课程id
  /// [classId] 班级id
  /// return: 签到结果
  @override
  Future<String> preSign(
      {required String activeId,
      required String courseId,
      required String classId}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://mobilelearn.chaoxing.com/newsign/preSign";
    String uid = await _request
        .getCookieJar()
        .loadForRequest(Uri.parse(url))
        .then((value) {
      for (var element in value) {
        if (element.name == "_uid") {
          return element.value;
        }
      }
      return "";
    });

    Map<String, dynamic> params = {
      "courseId": courseId,
      "classId": classId,
      "activePrimaryId": activeId,
      "general": "1",
      "sys": "1",
      "ls": "1",
      "appType": "15",
      "tid": "",
      "uid": uid,
      "ut": "s",
    };

    await _request.get(url, options: options, params: params);

    // 第一步分析
    String url1 = "https://mobilelearn.chaoxing.com/pptSign/analysis";
    params = {
      "vs": "1",
      "DB_STRATEGY": "RANDOM",
      "aid": activeId,
    };
    final analysisResult = await _request
        .get(url1, options: options, params: params)
        .then((value) {
      return value.data;
    });

    String code = analysisResult;
    final codeStart = code.indexOf("code='+'") + 8;
    code = code.substring(codeStart, code.length);
    final codeEnd = code.indexOf("'");
    code = code.substring(0, codeEnd);

    // 第二步分析
    String url2 = "https://mobilelearn.chaoxing.com/pptSign/analysis2";
    params = {
      "DB_STRATEGY": "RANDOM",
      "code": code,
    };
    final result = await _request
        .get(url2, options: options, params: params)
        .then((value) {
      return value.data;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    return "$result";
  }
}
