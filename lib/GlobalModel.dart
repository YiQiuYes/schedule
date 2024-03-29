import 'dart:async';
import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schedule/api/QueryApi.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/main.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import 'common/utils/LoggerUtils.dart';

class GlobalModel extends ChangeNotifier {
  // 课程数据
  List<dynamic> _courseData =
      List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}]);
  // 实验课表数据
  List<dynamic> _experimentData =
      List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}]);
  // 设置数据
  final Map<String, dynamic> _settings = {
    "isLogin": false,
    "load20CountCourse": false,
    "language": "default",
    "deviceLocale": "default",
  };
  // 学期周次数据
  final Map<String, dynamic> _semesterWeekData = {
    "semester": "2023-2024-2",
    "startDay": "2024-3-4",
    "currentWeek": "1",
  };
  // 用户个人数据
  final Map<String, dynamic> _userInfoData = {
    "username": "",
    "password": "",
  };

  // 定时器刷新数据
  Timer? _timer;
  // 是否第一次获取语言设置

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

  /// 获取实验课表数据
  void getPersonExperimentData(
      {required String week, required String semester}) {
    queryApi
        .queryPersonExperimentCourse(
            week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) {
      setExperimentData(int.parse(week) - 1, value);
      notifyListeners();
    });
  }

  /// 初始化
  void init() {
    _timer ??= Timer.periodic(const Duration(minutes: 10), (timer) {
      logger.i("定时器刷新数据");
      init();
      notifyListeners();
    });

    // 读取课程数据
    String? courseDataStr = _storage.getString("courseData");
    if (courseDataStr != null) {
      _courseData = jsonDecode(courseDataStr);
    } else {
      _storage.setString("courseData", jsonEncode(_courseData));
    }

    // 读取实验课表数据
    String? experimentDataStr = _storage.getString("experimentData");
    if (experimentDataStr != null) {
      _experimentData = jsonDecode(experimentDataStr);
    } else {
      _storage.setString("experimentData", jsonEncode(_experimentData));
    }

    // 读取设置数据
    String? settingsStr = _storage.getString("settings");
    if (settingsStr != null) {
      Map<String, dynamic> map = jsonDecode(settingsStr);
      map.forEach((key, value) {
        _settings[key] = value;
      });
    } else {
      _storage.setString("settings", jsonEncode(_settings));
    }

    // 读取学期周次数据
    String? semesterWeekDataStr = _storage.getString("semesterWeekData");
    if (semesterWeekDataStr != null) {
      Map<String, dynamic> map = jsonDecode(semesterWeekDataStr);
      map.forEach((key, value) {
        _semesterWeekData[key] = value;
      });

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
      Map<String, dynamic> map = jsonDecode(userInfoDataStr);
      map.forEach((key, value) {
        _userInfoData[key] = value;
      });
    } else {
      _storage.setString("userInfoData", jsonEncode(_userInfoData));
    }
  }

  /// 设置数据
  /// - [index] : 索引
  /// - [value] : 值
  Future<bool> setCourseData(int index, List<dynamic> value) async {
    _courseData[index] = value;
    notifyListeners();
    return await _storage.setString("courseData", jsonEncode(_courseData));
  }

  /// 设置数据
  /// - [index] : 索引
  /// - [value] : 值
  Future<bool> setExperimentData(int index, List<dynamic> value) async {
    _experimentData[index] = value;
    notifyListeners();
    return await _storage.setString(
        "experimentData", jsonEncode(_experimentData));
  }

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setSettings(String key, dynamic value) async {
    _settings[key] = value;
    notifyListeners();
    return await _storage.setString("settings", jsonEncode(_settings));
  }

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setSemesterWeekData(String key, dynamic value) async {
    _semesterWeekData[key] = value;
    notifyListeners();
    return await _storage.setString(
        "semesterWeekData", jsonEncode(_semesterWeekData));
  }

  /// 设置数据
  /// - [key] : 键
  /// - [value] : 值
  Future<bool> setUserInfoData(String key, dynamic value) async {
    _userInfoData[key] = value;
    notifyListeners();
    return await _storage.setString("userInfoData", jsonEncode(_userInfoData));
  }

  /// 获取语言
  Locale? getLocale() {
    String language = _settings["language"];
    if (language == "default") {
      return null;
    }
    // setSettings("language", "default");
    if (language.split("-").length > 1) {
      return Locale(language.split("-")[0], language.split("-")[1]);
    } else {
      return Locale(language);
    }
  }

  /// 获取课程数据
  List<dynamic> get courseData => _courseData;

  /// 获取实验课表数据
  List<dynamic> get experimentData => _experimentData;

  /// 获取设置数据
  Map<String, dynamic> get settings => _settings;

  /// 获取学期周次数据
  Map<String, dynamic> get semesterWeekData => _semesterWeekData;

  /// 获取用户个人数据
  Map<String, dynamic> get userInfoData => _userInfoData;
}
