import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schedule/api/QueryApi.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';

class GlobalModel extends ChangeNotifier {
  // 课程数据
  late List<dynamic> _courseData;
  // 设置数据
  late Map<String, dynamic> _settings;
  // 学期周次数据
  late Map<String, dynamic> _semesterWeekData;

  final _storage = DataStorageManager();
  final queryApi = QueryApi();

  /// 获取课程数据
  void getPersonCourseData({required String week, required String semester}) {
    queryApi.queryPersonCourse(week: week, semester: semester).then((value) {
      setCourseData(int.parse(week) - 1, value);
      notifyListeners();
    });
  }

  /// 初始化
  void init() {
    // 读取课程数据
    String? courseDataStr = _storage.getString("courseData");
    if (courseDataStr != null) {
      _courseData = jsonDecode(courseDataStr);
    } else {
      _courseData = List.generate(20, (index) => []);
      _storage.setString("courseData", jsonEncode(_courseData));
    }

    // 读取设置数据
    String? settingsStr = _storage.getString("settings");
    if (settingsStr != null) {
      _settings = jsonDecode(settingsStr);
    } else {
      _settings = {
        "isLogin": false,
        "load20CountCourse": false,
      };
      _storage.setString("settings", jsonEncode(_settings));
    }

    // 读取学期周次数据
    String? semesterWeekDataStr = _storage.getString("semesterWeekData");
    if (semesterWeekDataStr != null) {
      _semesterWeekData = jsonDecode(semesterWeekDataStr);

      // 格式化日期格式
      String startDay =
          ScheduleUtils.formatDateString(_semesterWeekData["startDay"]);
      DateTime startDayTime = DateTime.parse(startDay);
      DateTime now = DateTime.now();
      // 计算当前周次
      int currentWeek = now.difference(startDayTime).inDays ~/ 7 + 1;
      _semesterWeekData["currentWeek"] = currentWeek.toString();
      // logger.i("当前周次: $currentWeek");
    } else {
      _semesterWeekData = {
        "semester": "2023-2024-2",
        "startDay": "2024-3-4",
        "currentWeek": "1",
      };
      _storage.setString("semesterWeekData", jsonEncode(_semesterWeekData));
    }
  }

  /// 设置数据
  /// - [index] : 索引
  /// - [value] : 值
  Future<bool> setCourseData(int index, List<dynamic> value) async {
    _courseData[index] = value;
    return await _storage.setString("courseData", jsonEncode(_courseData));
  }

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setSettings(String key, dynamic value) async {
    _settings[key] = value;
    return await _storage.setString("settings", jsonEncode(_settings));
  }

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setSemesterWeekData(String key, dynamic value) async {
    _semesterWeekData[key] = value;
    return await _storage.setString(
        "semesterWeekData", jsonEncode(_semesterWeekData));
  }

  /// 获取课程数据
  List<dynamic> get courseData => _courseData;

  /// 获取设置数据
  Map<String, dynamic> get settings => _settings;

  /// 获取学期周次数据
  Map<String, dynamic> get semesterWeekData => _semesterWeekData;
}
