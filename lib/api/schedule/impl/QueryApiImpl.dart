import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/manager/FileManager.dart';
import 'package:schedule/common/manager/RequestManager.dart';

import '../QueryApi.dart';

class QueryApiImpl extends QueryApi {
  QueryApiImpl._privateConstructor();

  static final QueryApiImpl _instance = QueryApiImpl._privateConstructor();

  factory QueryApiImpl() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  // 文件存储
  final _file = FileManager();

  /// 获取随机图片
  @override
  Future<Uint8List> getRandomTwoDimensionalSpace() async {
    // 判断本地是否有缓存
    List<String> filePathList =
        await _file.loadFileList(headerPath: "randomTwoDimensionalSpace");

    late List<Uint8List> randomTwoDimensionalSpace;
    if (filePathList.isNotEmpty) {
      // 异步读取文件
      randomTwoDimensionalSpace = await _file.readAsUint8List(filePathList);
    } else {
      // 从本地读取图片数据
      final image = await rootBundle.load("lib/assets/images/splash.jpg");
      Uint8List data = image.buffer.asUint8List();
      randomTwoDimensionalSpace = [data];
    }

    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions();
    options.responseType = ResponseType.bytes;
    _request.get("https://t.mwm.moe/mp", options: options).then((value) async {
      final result = value.data;

      if (randomTwoDimensionalSpace.length > 10) {
        randomTwoDimensionalSpace = randomTwoDimensionalSpace.sublist(0, 1);
        // 删除文件
        await _file.deleteFileList(filePathList);
      }

      randomTwoDimensionalSpace.add(result);
      // 写入文件
      _file.writeAsBytes(
          "randomImage${randomTwoDimensionalSpace.length + 1}.png", result,
          headerPath: "randomTwoDimensionalSpace");
    });

    final random = Random();
    return randomTwoDimensionalSpace[
        random.nextInt(randomTwoDimensionalSpace.length)];
  }

  /// 查询个人成绩
  /// - [semester] : 学期
  /// - [retake] : 是否显示补重成绩
  /// - [cachePolicy] : 缓存策略
  @override
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

  /// 查询个人课程
  /// - [week] : 周次
  /// - [semester] : 学期
  @override
  Future<List<Map>> queryPersonCourse(
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

      List<Map> result = [];
      if (tables.isNotEmpty) {
        Element table = tables[0];
        List<Element> list = table.getElementsByClassName("kbcontent");

        const time = [
          "8:00-9:40",
          "10:00-11:40",
          "14:00-15:40",
          "16:30-17:40",
          "19:00-20:40",
        ];

        for (int i = 0; i < list.length; i++) {
          Element element = list[i];

          // 获取课程名称
          String? className = element.firstChild?.text;
          className ??= "";
          className == " " ? className = "" : className = className;

          // 获取课程时间
          int index = i ~/ 7;
          String classTime = time[index];

          // 获取课程地点
          String? classAddress;
          classAddress = element.querySelector('[title=教室]')?.text;
          classAddress ??= "";

          // 获取课程老师
          String? classTeacher;
          classTeacher = element.querySelector('[title=老师]')?.text;
          classTeacher ??= "";

          // 获取课程周数
          String classWeek;
          classWeek = week;

          if (className.isNotEmpty) {
            result.add({
              "className": className,
              "classTime": classTime,
              "classAddress": classAddress,
              "classTeacher": classTeacher,
              "classWeek": classWeek,
            });
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
  @override
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
          "16:30-17:40",
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

            List<String> split = tds[i].innerHtml.split("<br>");
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
  @override
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
  @override
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
  @override
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
              "16:30-17:40",
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
}
