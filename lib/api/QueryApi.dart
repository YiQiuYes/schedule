import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/manager/FileManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/manager/RequestManager.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';

class QueryApi {
  QueryApi._privateConstructor();

  static final QueryApi _instance = QueryApi._privateConstructor();

  factory QueryApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();
  // 数据存储
  final _storage = DataStorageManager();
  // 文件存储
  final _file = FileManager();

  /// 获取随机图片
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

  /// 查询所有课程
  /// - [week] : 周次
  /// - [semester] : 学期
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
}
