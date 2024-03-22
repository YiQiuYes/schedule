import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:schedule/api/QueryApi.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';

class GlobalModel extends ChangeNotifier {
  // 课程数据
  List<dynamic> _courseData = List.generate(20, (index) => []);
  // 设置数据
  Map<String, dynamic> _settings = {
    "isLogin": false,
    "load20CountCourse": false,
  };
  // 学期周次数据
  Map<String, dynamic> _semesterWeekData = {
    "semester": "2023-2024-2",
    "startDay": "2024-3-4",
    "currentWeek": "3",
  };
  // 用户个人数据
  Map<String, dynamic> _userInfoData = {
    "username": "",
    "password": "",
  };

  final _storage = DataStorageManager();
  final queryApi = QueryApi();

  /// 获取课程数据
  void getPersonCourseData({required String week, required String semester}) {
    queryApi
        .queryPersonCourse(
            week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) {
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
      _storage.setString("courseData", jsonEncode(_courseData));
    }

    // 读取设置数据
    String? settingsStr = _storage.getString("settings");
    if (settingsStr != null) {
      _settings = jsonDecode(settingsStr);
    } else {
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
      _storage.setString("semesterWeekData", jsonEncode(_semesterWeekData));
    }

    // 读取用户个人数据
    String? userInfoDataStr = _storage.getString("userInfoData");
    if (userInfoDataStr != null) {
      _userInfoData = jsonDecode(userInfoDataStr);
    } else {
      _storage.setString("userInfoData", jsonEncode(_userInfoData));
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

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setUserInfoData(String key, dynamic value) async {
    _userInfoData[key] = value;
    return await _storage.setString("userInfoData", jsonEncode(_userInfoData));
  }

  /// 获取课程数据
  List<dynamic> get courseData => _courseData;

  /// 获取设置数据
  Map<String, dynamic> get settings => _settings;

  /// 获取学期周次数据
  Map<String, dynamic> get semesterWeekData => _semesterWeekData;

  /// 获取用户个人数据
  Map<String, dynamic> get userInfoData => _userInfoData;
}
