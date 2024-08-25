import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../../manager/request_manager.dart';
import '../../utils/response_utils.dart';

class ScheduleQueryApi {
  ScheduleQueryApi._privateConstructor();

  static final ScheduleQueryApi _instance = ScheduleQueryApi._privateConstructor();

  factory ScheduleQueryApi() {
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
      "xsfs": retake ? 'all' : '',
      "kcxz": '',
      "kcmc": '',
    };

    // 处理返回数据
    return await _request
        .post("/jsxsd/kscj/cjcx_list", params: params, options: options)
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
          List<Element> tds = tr.getElementsByTagName("td");

          String className = tds[3].text; // 课程名称
          String classCredit = tds[7].text; // 学分
          String classScore =
          tds[5].text.replaceAll(RegExp(r'[\n\t]'), ""); // 成绩
          String classGPA = tds[9].text; // 绩点
          String classType = tds[13].text; // 课程性质

          result.add({
            "className": className,
            "classCredit": classCredit,
            "classScore": classScore,
            "classGPA": classGPA,
            "classType": classType,
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

    // 处理返回数据
    return await _request
        .post("/jsxsd/kscj/djkscj_list", options: options)
        .then((value) {
      Document doc = parse(value.data);
      // logger.i(doc.outerHtml);
      Element? table = doc.getElementById("dataList");
      List<Map<String, dynamic>> result = [];
      if (table != null) {
        List<Element> trs = table.getElementsByTagName("tr");
        trs.removeAt(0);
        trs.removeAt(0);

        for (Element tr in trs) {
          if (tr.outerHtml.contains("未查询到数据")) {
            continue;
          }
          List<Element> tds = tr.getElementsByTagName("td");

          // 考试名称
          String examName = tds[1].text.replaceAll(RegExp(r'（.*?）'), "");
          // 考试成绩
          String examScore = tds[4].text.replaceAll(RegExp(r'[\n\t]'), "");
          // 绩点
          String examTime = tds[8].text;

          result.add({
            "examName": examName,
            "examScore": examScore,
            "examTime": examTime,
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
  Future<List> queryPersonCourse(
      {required String week,
        required String semester,
        CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "xnxq01id": semester,
      "zc": week,
      "sfFD": 1,
      "cj0701id": "",
      "demo": "",
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
    };

    // 处理返回数据
    return await _request
        .post("/jsxsd/xskb/xskb_list.do", params: params, options: options)
        .then((value) {
      Document doc = parse(value.data);
      List<Element> tables = doc.getElementsByTagName("table");

      List result = [];
      if (tables.isNotEmpty) {
        Element table = tables[0];
        List<Element> list = table.getElementsByClassName("kbcontent");

        const time = [
          "8:00-9:40",
          "10:00-11:40",
          "14:00-15:40",
          "16:00-17:40",
          "19:00-20:40",
        ];

        for (int i = 0; i < list.length; i++) {
          Element element = list[i];

          // 获取课程名称
          String? className = element.firstChild?.text;
          List<String> classNameList = [];
          className ??= "";
          className == " " ? className = "" : className = className;
          classNameList.add(className);

          // 正则表达式取出 >面向过程程序设计(C语言)<br> 之间的内容
          RegExp regExp =
          RegExp(r'<br>---------------------<br>(.*)<br><font title="老师">');
          Iterable<RegExpMatch> matches = regExp.allMatches(element.outerHtml);
          for (RegExpMatch match in matches) {
            classNameList
                .add(match.group(1)?.replaceAll(RegExp(r'[<br>]'), "") ?? "");
          }

          // 获取课程时间
          int index = i ~/ 7;
          String classTime = time[index];

          // 获取课程地点
          List<String> classAddressList = [];
          element.querySelectorAll('[title=教室]').forEach((element) {
            classAddressList.add(element.text);
          });
          if (classNameList.length > classAddressList.length) {
            for (int i = classAddressList.length;
            i < classNameList.length;
            i++) {
              classAddressList.add("");
            }
          }

          // 获取课程老师
          List<String> classTeacherList = [];
          element.querySelectorAll('[title=老师]').forEach((element) {
            classTeacherList.add(element.text);
          });
          if (classNameList.length > classTeacherList.length) {
            for (int i = classTeacherList.length;
            i < classNameList.length;
            i++) {
              classTeacherList.add("");
            }
          }

          // 获取课程周数
          String classWeek;
          classWeek = week;

          if (className.isNotEmpty) {
            if (classNameList.length > 1) {
              List<Map> classContent = [];
              for (int i = 0; i < classNameList.length; i++) {
                classContent.add({
                  "className": classNameList[i],
                  "classTime": classTime,
                  "classAddress": classAddressList[i],
                  "classTeacher": classTeacherList[i],
                  "classWeek": classWeek,
                });
              }
              result.add(classContent);
            } else {
              result.add({
                "className": classNameList[0],
                "classTime": classTime,
                "classAddress": classAddressList[0],
                "classTeacher": classTeacherList[0],
                "classWeek": classWeek,
              });
            }
          } else {
            result.add({});
          }
        }
      }

      return result;
    });
  }

  /// 查询个人实验课程
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryPersonExperimentCourse(
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
      return result;
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
      // logger.i(result);
      return result;
    });
  }

  /// 获取专业信息
  Future<List<String>> queryMajorInfo({
    required String collegeId,
    required String semester,
    CachePolicy? cachePolicy,
  }) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "skyx": collegeId,
      "xnxqh": semester,
    };

    return await _request
        .get("/jsxsd/kbcx/kbxx_xzb_ifr", params: params, options: options)
        .then((value) {
      List<String> result = [];
      Document doc = parse(value.data);
      Element? table = doc.getElementById("kbtable");
      if (table != null) {
        Element? unUse = doc.getElementById("thead1");
        if (unUse != null) {
          unUse.remove();
        }

        List<Element> trs = table.getElementsByTagName("tr");
        for (Element tr in trs) {
          String majorName = tr.getElementsByTagName("td").first.text;
          result.add(majorName.replaceAll(RegExp(r'[\n\t]'), ""));
        }
      }

      return result;
    });
  }

  /// 获取班级课表
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [majorName] : 专业名称
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryMajorCourse(
      {required String week,
        required String semester,
        required String majorName,
        CachePolicy? cachePolicy}) async {
    Options options = _request.cacheOptions
        .copyWith(policy: cachePolicy ?? CachePolicy.request)
        .toOptions();

    Map<String, dynamic> params = {
      "xnxqh": semester,
      "zc1": week,
      "zc2": week,
      "skbj": majorName,
    };

    return await _request
        .post("/jsxsd/kbcx/kbxx_xzb_ifr", params: params, options: options)
        .then((value) {
      Document doc = parse(value.data);
      Element? table = doc.getElementById("kbtable");

      List<Map> result = [];
      if (table != null) {
        // 删除表头
        table.querySelector("thead")?.remove();

        List<Element> tds = table.getElementsByTagName("td");
        if (tds.isEmpty) {
          return result;
        }

        tds.removeAt(0);
        for (int i = 0; i < tds.length; i++) {
          List<Element> divs = tds[i].getElementsByTagName("div");
          if (divs.isEmpty) {
            result.add({});
          } else {
            Element div = divs.first;
            List<String> split = div.innerHtml
                .replaceAll(RegExp(r'<span>.*</span><br>'), "")
                .split("<br>");
            // logger.i(div.outerHtml);
            split =
                split.map((e) => e.replaceAll(RegExp(r'[\n\t]'), "")).toList();
            String className = split[0];
            String classAddress = split.length > 2 ? split[3] : "";
            String classTeacher = split.length > 1 ? split[2] : "";

            const time = [
              "8:00-9:40",
              "10:00-11:40",
              "14:00-15:40",
              "16:00-17:40",
              "19:00-20:40",
            ];
            String classTime = time[i % 5];

            result.add({
              "className": className,
              "classTime": classTime,
              "classAddress": classAddress,
              "classTeacher": classTeacher.split("(")[0],
              "classWeek": week,
            });
          }
        }
      }

      // 将数组转置
      List<List<Map>> transposed = [];
      for (int i = 0; i < 7; i++) {
        List<Map> tmpList = [];
        for (int j = 0; j < 5; j++) {
          tmpList.add(result[i * 5 + j]);
        }
        transposed.add(tmpList);
      }

      result.clear();
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 7; j++) {
          result.add(transposed[j][i]);
        }
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
          String url = "/jsxsd/kbcx/getJxlByAjax";
          Map<String, dynamic> params = {
            "xqid": campusId,
          };
          buildingList = await _request
              .get(url, params: params, options: options)
              .then((value) {
            final List json = ResponseUtils.transformObj(value);
            return json.map((e) {
              return {
                "buildingName": e["dmmc"],
                "buildingId": e["dm"],
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
      "xnxqh": semester,
      "kbjcmsid": "",
      "skyx": "",
      "xqid": campusId,
      "jzwid": buildingId,
      "skjsid": "",
      "skjs": "",
      "zc1": "",
      "zc2": "",
      "skxq1": "",
      "skxq2": "",
      "jc1": "",
      "jc2": "",
    };

    return await _request
        .post("/jsxsd/kbcx/kbxx_classroom_ifr",
        params: params, options: options)
        .then((value) {
      Document doc = parse(value.data);
      Element? table = doc.getElementById("kbtable");
      List result = [];
      if (table != null) {
        // 去除thead标签
        table.querySelector("thead")?.remove();
        List<Element> trs = table.getElementsByTagName("tr");
        // 判断是否为空
        if (trs.isEmpty) {
          return result;
        }

        for (Element tr in trs) {
          List<Element> tds = tr.getElementsByTagName("td");
          // 教室
          Element classBuilding = tds.removeAt(0);
          // 遍历td标签
          Element td = tds[(week - 1) * 5 + lesson - 1];
          // 文本
          String text = td.text;
          // 正则表达式提取所有 () 之间的内容
          RegExp regExp = RegExp(r'\((.*?)\)');
          Iterable<RegExpMatch> matches = regExp.allMatches(text);
          List<String> classList = [];
          for (RegExpMatch match in matches) {
            classList.add(match.group(1) ?? "");
          }

          // 检查是否包含在当前周次
          bool isContain = false;
          if (classList.isNotEmpty) {
            for (String classWeek in classList) {
              if (!classWeek.contains("周")) {
                continue;
              }
              classWeek = classWeek.replaceAll(RegExp(r'[周单双]'), "");
              if (classWeek.contains(",")) {
                List<String> split = classWeek.split(",");
                for (String item in split) {
                  List<String> interval = item.split("-");
                  if (interval.length == 2) {
                    int start = int.parse(interval[0]);
                    int end = int.parse(interval[1]);
                    if (start <= int.parse(weekly) &&
                        int.parse(weekly) <= end) {
                      isContain = true;
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
                    isContain = true;
                    break;
                  }
                }
              }
            }
          }

          if (!isContain) {
            result.add(classBuilding.text.replaceAll(RegExp(r'[\t\n]'), ""));
          }
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
      "xnxqh": semester,
      "kbjcmsid": "",
      "skyx": "",
      "jszc": "",
      "skjsid": "",
      "skjs": teacherName,
      "zc1": "",
      "zc2": "",
      "skxq1": "",
      "skxq2": "",
      "jc1": "",
      "jc2": "",
    };

    return await _request
        .post("/jsxsd/kbcx/kbxx_teacher_ifr",
        params: params, options: options)
        .then((value) {
      Document doc = parse(value.data);
      Element? table = doc.getElementById("kbtable");
      List<Map> result = [];
      if (table != null) {
        // 去除thead标签
        table.querySelector("thead")?.remove();
        // logger.i(table.outerHtml);
        List<Element> trs = table.getElementsByTagName("tr");
        // 判断是否为空
        if (trs.isEmpty) {
          return result;
        }

        for (Element tr in trs) {
          List<Element> tds = tr.getElementsByTagName("td");
          // 判断是否非空
          if (tds.isEmpty) {
            continue;
          }

          Element teacher = tds.removeAt(0);
          Map teacherMap = {
            "teacherName": teacher.text.replaceAll(RegExp(r'[\r\n\t]'), ""),
            "classList": [],
          };
          // 遍历td标签
          for (int i = 0; i < tds.length; i++) {
            // 检查是否包含div标签
            List<Element> divs = tds[i].querySelectorAll("div");
            if (divs.isEmpty) {
              continue;
            }

            for (Element div in divs) {
              // 课程名称
              String? className = div.firstChild?.text;
              // 课程地点 在最后一个<br>标签之后
              String classAddress = div.innerHtml.split("<br>").last;
              classAddress = classAddress.replaceAll(RegExp(r'[\r\n\t]'), "");
              // 课程时间 在()之间
              String classTime = div.innerHtml.split("(").last.split(")")[0];
              // 星期几
              int week = i ~/ 5 + 1;
              // 第几节课
              int lesson = i % 5 + 1;
              teacherMap["classList"].add({
                "className": className ?? "",
                "classTime": classTime,
                "week": week,
                "lesson": lesson,
                "classAddress": classAddress,
              });
            }
          }

          result.add(teacherMap);
        }
      }

      // logger.i(result);
      return result;
    });
  }

  /// 获取考试计划
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
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
        .post("/jsxsd/xsks/xsksap_list", params: params,options: options)
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
