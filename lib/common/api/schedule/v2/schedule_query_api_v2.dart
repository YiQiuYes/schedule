import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/utils/logger_utils.dart';

import '../../../manager/request_manager.dart';
import '../../../utils/response_utils.dart';

class ScheduleQueryApiV2 {
  ScheduleQueryApiV2._privateConstructor();

  static final ScheduleQueryApiV2 _instance =
      ScheduleQueryApiV2._privateConstructor();

  factory ScheduleQueryApiV2() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  /// 查询个人成绩
  /// - [semester] : 学期
  /// - [retake] : 是否显示补重成绩
  /// - [cachePolicy] : 缓存策略
  Future<List<Map<String, dynamic>>> queryPersonScore(
      {required String semester,
      bool retake = false,
      CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "kksj": semester,
      "pageNum": 1,
      "pageSize": 20,
      "kcxz": '',
      "kcsx": '',
      "kcmc": '',
      "xsfs": 'all',
      "sfxsbcxq": 1,
    };

    // 处理返回数据
    return await _request
        .get("/jsxsd/kscj/cjcx_list", params: params, options: options)
        .then((value) {
      // logger.i(value.data);
      var data = jsonDecode(value.data);
      List<Map<String, dynamic>> result = [];
      if (data["data"].isNotEmpty) {
        for (Map<String, dynamic> item in data["data"]) {
          result.add({
            "className": item["kc_mc"],
            "classCredit": item["xf"],
            "classScore": item["zcjstr"],
            "classGPA": "",
            "classType": item["kcsx"],
          });
        }
      }

      return result;
    });
  }

  /// 查询个人社会成绩
  /// - [cachePolicy] : 缓存策略
  Future<List<Map<String, dynamic>>> queryPersonSocialExams(
      {CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "type": "listData",
      "pageNum": 1,
      "pageSize": 20,
    };

    // 处理返回数据
    return await _request
        .get("/jsxsd/kscj/djkscj_list", params: params, options: options)
        .then((value) {
      var data = jsonDecode(value.data);
      List<Map<String, dynamic>> result = [];
      if (data["data"].isNotEmpty) {
        for (Map<String, dynamic> item in data["data"]) {
          result.add({
            "examName": item["skdjmc"],
            "examScore": item["fslcj"].toString(),
            "examTime": item["kssj"],
          });
        }
      }

      return result;
    });
  }

  /// 查询个人课程
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  Future<ResponseData<List>> queryPersonCourse(
      {required String week,
      required String semester,
      CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "viweType": 0,
      "showallprint": 0,
      "showkchprint": 0,
      "showkink": 0,
      "showfzmprint": 0,
      "baseUrl": "/jsxsd",
      "xsflMapListJsonStr": "讲课学时,上机学时,课程实践学时,实验学时,",
      "xnxq01id": semester,
      "zc": week,
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
    };

    // 处理返回数据
    return await _request
        .post("/jsxsd/xskb/xskb_list.do", params: params, options: options)
        .then((value) {
      if (RegExp(r"<title>登录</title>").hasMatch(value.data)) {
        return ResponseData(
          code: ResponseCode.noLogin,
          message: "login failed",
        );
      }

      Document doc = parse(value.data);
      List<Element> tables =
          doc.getElementsByClassName("qz-weeklyTable-td  qz-hasCourse ");

      List result = [];
      if (tables.isNotEmpty) {
        const time = [
          "8:00-9:40",
          "10:00-11:40",
          "14:00-15:40",
          "16:00-17:40",
          "19:00-20:40",
        ];

        for (int i = 0; i < tables.length; i++) {
          List<Element> list = tables[i].getElementsByClassName("qz-tooltip");
          if (list.isNotEmpty) {
            for (int j = 0; j < list.length; j++) {
              Element item = list[j];
              List<Element> classTileList = item
                  .getElementsByClassName("qz-tooltipContent-title qz-ellipse");
              String className = classTileList[j].text;

              List<Element> classInfoList =
                  item.getElementsByClassName("qz-tooltipContent-detailitem");

              // 获取课程时间
              int index = i ~/ 7;
              String classTime = time[index];

              // 课程地址
              String classAddress = "";

              RegExp regExp = RegExp(r'\(([^)]+)\)');
              Match? match =
                  regExp.firstMatch(classInfoList[7 + j * 10].text.trim());
              if (match != null) {
                classAddress = match.group(1)!;
              }

              // 课程教师
              String classTeacher =
                  classInfoList[4].text.trim().replaceAll("老师：", "");

              // 获取课程周数
              String classWeek;
              classWeek = week;

              if (classTileList.length == 1) {
                result.add({
                  "className": className,
                  "classTime": classTime,
                  "classAddress": classAddress,
                  "classTeacher": classTeacher,
                  "classWeek": classWeek,
                });
              } else {
                if (result.length != i + 1) {
                  result.add([]);
                }

                result[i].add({
                  "className": className,
                  "classTime": classTime,
                  "classAddress": classAddress,
                  "classTeacher": classTeacher,
                  "classWeek": classWeek,
                });
              }
            }
          } else {
            result.add({});
          }
        }
      }

      return ResponseData(code: ResponseCode.success, data: result);
    });
  }

  /// 查询个人实验课程
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  /// ToDo
  Future<ResponseData<List<Map>>> queryPersonExperimentCourse(
      {required String week,
      required String semester,
      CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "xnxq01id": semester,
      "zc": week,
    };

    List<Map> result = [];
    // 处理返回数据
    return await _request
        .get("/jsxsd/syjx/toXskb.do", params: params, options: options)
        .then((value) {
      if (RegExp(r"<title>登录</title>").hasMatch(value.data)) {
        return ResponseData(
          code: ResponseCode.noLogin,
          message: "login failed",
        );
      }

      Document doc = parse(value.data);
      Element? table = doc.getElementById("tblHead");
      if (table != null) {
        List<Element> trs = table.getElementsByTagName("tr");
        trs.removeAt(0);

        const time = [
          "8:00-9:40",
          "10:00-11:40",
          "14:00-15:40",
          "16:00-17:40",
          "19:00-20:40",
        ];
        for (int i = 0; i < 5; i++) {
          Element tr = trs[i];
          tr.querySelector("[rowspan]")?.remove();
          List<Element> tds = tr.getElementsByTagName("td");

          tds.removeAt(0);
          for (int j = 0; j < tds.length; j++) {
            // 获取课程时间
            String classTime = time[i];

            List<String> split = tds[j].innerHtml.split("<br>");
            if (split.length != 1) {
              // 获取课程名称
              String className = split[0];
              // 获取课程地点
              String classAddress = split[2].split("   ")[1];

              result.add({
                "className": className,
                "classTime": classTime,
                "classAddress": classAddress,
                "classTeacher": "",
                "classWeek": week,
              });
            } else {
              result.add({});
            }
          }
        }
      }

      if (result.isEmpty) {
        result = List.generate(35, (int index) => {});
      }
      return ResponseData(code: ResponseCode.success, data: result);
    });
  }

  /// 获取学院信息
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryCollegeInfo({
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    return await _request
        .get("/jsxsd/kbcx/kbxx_xzb", options: options)
        .then((value) {
      Document doc = parse(value.data);
      Element? collegeElement = doc.getElementById("skyx");
      List<Map> result = [];

      if (collegeElement != null) {
        List<Element> collegeList =
            collegeElement.getElementsByTagName("option");
        collegeList.removeAt(0);
        for (Element college in collegeList) {
          String collegeName = college.text;
          String collegeId = college.attributes["value"] ?? "";
          result.add({
            "collegeName": collegeName.split("]")[1],
            "collegeId": collegeId,
          });
        }
      }
      return result;
    });
  }

  /// 获取专业信息
  /// - [collegeId] : 学院id
  /// - [cachePolicy] : 缓存策略
  Future<List<Map<String, dynamic>>> queryMajorInfo({
    required String collegeId,
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    List majorList = [];

    List<Map<String, dynamic>> result = [];
    DateTime now = DateTime.now();
    int currentYear = now.year;

    for (int i = 0; i < 4; i++) {
      Map<String, dynamic> params = {
        "xx0301id": collegeId,
        "ksnd": currentYear - i
      };
      await _request
          .get("/jsxsd/comm/getZy", params: params, options: options)
          .then((value) {
        var data = jsonDecode(value.data);
        // logger.i(data["data"]);
        majorList = data["data"];
      });

      for (Map<String, dynamic> major in majorList) {
        params = {"jx01id": major["jx01id"], "rxnf": currentYear - i};
        await _request
            .get("/jsxsd/comm/getBj", params: params, options: options)
            .then((value) {
          var data = jsonDecode(value.data);
          // logger.i(data["data"]);
          for (Map<String, dynamic> item in data["data"]) {
            result.add({
              "majorName": item["bj"],
              "majorId": major["jx01id"],
              "classId": item["xx04id"],
              "grade": currentYear - i,
              "collegeId": collegeId,
            });
          }
        });
      }
    }

    return result;
  }

  /// 获取班级课表
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [collegeId] : 学院id
  /// - [majorId] : 专业id
  /// - [classId] : 班级id
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryMajorCourse(
      {required String week,
      required String semester,
      required String grade,
      required String collegeId,
      required String majorId,
      required String classId,
      CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "pageNum": "1",
      "pageSize": 10000,
      "xnxq01id": semester,
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
      "skyx": collegeId,
      "ksnd": grade,
      "skzy": majorId,
      "skbj": classId,
      "zc1": week,
      "zc2": week,
      "skxq1": "",
      "skxq2": "",
      "jc1": "",
      "jc2": "",
    };

    return await _request
        .get("/jsxsd/kbcx/kbxx_xzb_ifr", params: params, options: options)
        .then((value) {
      var data = jsonDecode(value.data);
      // logger.i(data);
      List<Map> result = List.generate(35, (int index) => {});

      const time = [
        "8:00-9:40",
        "10:00-11:40",
        "14:00-15:40",
        "16:00-17:40",
        "19:00-20:40",
      ];

      const weekTile = [
        "星期一",
        "星期二",
        "星期三",
        "星期四",
        "星期五",
        "星期六",
        "星期日",
      ];

      for (Map<String, dynamic> item in data["data"]) {
        int section = (int.parse(item["jc"].split("-")[1]) / 2).ceil();
        int indexOf = weekTile.indexOf(item["zzdweek"]) + 1;
        int index = (section - 1) * 7 + indexOf - 1;
        // logger.i("item ${item} \n ${section} \n ${indexOf} \n ${index}");
        result[index] = {
          "className": item["kcmc"],
          "classTime": time[section - 1],
          "classAddress": item["jsmc"],
          "classTeacher": item["jsxm"].split("[")[0],
          "classWeek": week,
        };
      }
      return result;
    });
  }

  /// 获取校区和楼栋信息
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryBuildingInfo({
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    return await _request
        .get("/jsxsd/kbcx/kbxx_classroom", options: options)
        .then((value) async {
      Document doc = parse(value.data);
      Element? campusElement = doc.getElementById("xqid");
      List<Map> result = [];
      if (campusElement != null) {
        List<Element> campusList = campusElement.getElementsByTagName("option");
        campusList.removeAt(0);
        for (Element campus in campusList) {
          String campusName = campus.text;
          String campusId = campus.attributes["value"] ?? "";

          // 获取楼栋信息
          List<Map> buildingList = [];
          String url = "/jsxsd/comm/getJxl";
          Map<String, dynamic> params = {
            "xqid": campusId,
          };
          buildingList = await _request
              .get(url, params: params, options: options)
              .then((value) {
            final List json = ResponseUtils.transformObj(value)["data"];
            // logger.i(json);

            return json.map((e) {
              return {
                "buildingName": e["jzwmc"],
                "buildingId": e["jzwid"],
              };
            }).toList();
          });

          result.add({
            "campusName": campusName,
            "campusId": campusId,
            "buildingList": buildingList,
          });
        }
      }
      return result;
    });
  }

  /// 获取空教室
  /// - [semester] : 学期
  /// - [buildingId] : 教学楼ID
  /// - [campusId] : 校区ID
  /// - [week] : 星期几
  /// - [lesson] : 第几节课
  /// - [weekly] : 周次
  /// - [cachePolicy] : 缓存策略
  Future<List> queryEmptyClassroom({
    required String semester,
    required String buildingId,
    required String campusId,
    required int week,
    required int lesson,
    required String weekly,
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "pageNum": 1,
      "pageSize": 10000,
      "xnxq01id": semester,
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
      "skyx": "",
      "xqid": campusId,
      "jzwid": buildingId,
      "jsmc": "",
      "zc1": "",
      "zc2": "",
      "skxq1": "",
      "skxq2": "",
      "jc1": "",
      "jc2": "",
    };

    const weekTile = [
      "星期一",
      "星期二",
      "星期三",
      "星期四",
      "星期五",
      "星期六",
      "星期日",
    ];

    return await _request
        .get("/jsxsd/kbcx/kbxx_classroom_ifr", params: params, options: options)
        .then((value) {
      final List list = ResponseUtils.transformObj(value)["data"];
      List result = [];

      for (Map<String, dynamic> item in list) {
        bool isMatchWeek = false;
        bool isMatchLesson = false;
        bool isMatchWeekly = false;

        if (item["zzdweek"] != weekTile[week - 1]) {
          isMatchWeek = true;
        }

        if (item["jc"] != "${lesson * 2 - 1}-${lesson * 2}") {
          isMatchLesson = true;
        }

        String classWeek = item["kkzc"];
        if (classWeek.contains(",")) {
          List<String> split = classWeek.split(",");
          for (String item in split) {
            List<String> interval = item.split("-");
            if (interval.length == 2) {
              int start = int.parse(interval[0]);
              int end = int.parse(interval[1]);
              if (start <= int.parse(weekly) && int.parse(weekly) <= end) {
                isMatchWeekly = true;
                break;
              }
            }
          }
        } else {
          List<String> interval = classWeek.split("-");
          if (interval.length == 2) {
            int start = int.parse(interval[0]);
            int end = int.parse(interval[1]);
            if (start <= int.parse(weekly) && int.parse(weekly) <= end) {
              isMatchWeekly = true;
            }
          }
        }

        if (isMatchWeek &&
            isMatchLesson &&
            isMatchWeekly &&
            !result.contains(item["jsmc"])) {
          result.add(item["jsmc"]);
        }
      }
      return result;
    });
  }

  /// 获取教师课表
  /// - [teacherName] : 教师姓名
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryTeacherCourse({
    required String teacherName,
    required String semester,
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "pageNum": 1,
      "pageSize": 10000,
      "xnxq01id": semester,
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
      "jsyx": "",
      "jszc": "",
      "jsxx": teacherName,
      "zc1": "",
      "zc2": "",
      "skxq1": "",
      "skxq2": "",
      "jc1": "",
      "jc2": "",
    };

    const weekTile = [
      "星期一",
      "星期二",
      "星期三",
      "星期四",
      "星期五",
      "星期六",
      "星期日",
    ];

    return await _request
        .get("/jsxsd/kbcx/kbxx_teacher_ifr", params: params, options: options)
        .then((value) {
      List data = jsonDecode(value.data)["data"];
      List<Map> result = [];
      // logger.i(data);

      Map teacherMap = {
        "teacherName": "",
        "classList": [],
      };

      for (Map<String, dynamic> item in data) {
        if (teacherMap["teacherName"] != item["xm"]) {
          if (teacherMap["teacherName"] != "") {
            result.add(teacherMap);
          }

          teacherMap = {
            "teacherName": item["xm"],
            "classList": [],
          };
        }

        int weekIndex = weekTile.indexOf(item["zzdweek"]) + 1;
        int lesson = int.parse(item["jc"].split("-")[1]) ~/ 2;

        teacherMap["classList"].add({
          "className": item["kcmc"],
          "classTime": item["kkzc"],
          "week": weekIndex,
          "lesson": lesson,
          "classAddress": item["jsmc"] ?? "",
        });
      }
      result.add(teacherMap);

      // logger.i(result);
      return result;
    });
  }

  /// 获取考试计划
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  /// ToDo
  Future<List<Map<String, dynamic>>> queryPersonExamPlan(
      {required String semester, CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "xqlbmc": "",
      "xnxqid": semester,
      "xqlb": "",
    };

    // 处理返回数据
    return await _request
        .post("/jsxsd/xsks/xsksap_list", params: params, options: options)
        .then((value) {
      Document doc = parse(value.data);
      // logger.i(doc.outerHtml);
      Element? table = doc.getElementById("dataList");
      List<Map<String, dynamic>> result = [];
      if (table != null) {
        List<Element> trs = table.getElementsByTagName("tr");
        trs.removeAt(0);

        for (Element tr in trs) {
          if (tr.outerHtml.contains("未查询到数据")) {
            continue;
          }
          // logger.i(tr.outerHtml);
          List<Element> tds = tr.getElementsByTagName("td");

          // 考试名称
          String examName = tds[2].text;
          // 考试时间
          String examTime = tds[6].text;
          // 考试地点
          String examAddress = tds[7].text;

          result.add({
            "examName": examName,
            "examTime": examTime,
            "examAddress": examAddress,
          });
        }
      }

      return result;
    });
  }
}