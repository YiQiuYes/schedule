import 'dart:async';
import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:schedule/api/QueryApi.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';

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
    "fontFamily": "default",
    "themeMode": "default",
    "colorTheme": "#673AB7",
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

  final _storage = DataStorageManager();
  final queryApi = QueryApi();

  void refreshData() {
    logger.i("刷新数据");
    // 格式化日期格式
    String startDay =
    ScheduleUtils.formatDateString(_semesterWeekData["startDay"]);
    DateTime startDayTime = DateTime.parse(startDay);
    DateTime now = DateTime.now();
    // 计算当前周次
    int currentWeek = now.difference(startDayTime).inDays ~/ 7 + 1;
    _semesterWeekData["currentWeek"] = currentWeek.toString();
    notifyListeners();
  }

  /// 初始化
  void init() {
    _timer ??= Timer.periodic(const Duration(minutes: 10), (timer) {
      refreshData();
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
      _settings["deviceLocale"] = "default";
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

  /// 获取课程数据
  void getPersonCourseData({required String week, required String semester}) {
    queryApi
        .queryPersonCourse(
        week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) async {
      await setCourseData(int.parse(week) - 1, value);
      notifyListeners();
    });
  }

  /// 获取实验课表数据
  void getPersonExperimentData(
      {required String week, required String semester}) {
    queryApi
        .queryPersonExperimentCourse(
        week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) async {
      await setExperimentData(int.parse(week) - 1, value);
      notifyListeners();
    });
  }

  /// 设置数据
  Future<bool> setCourseData(int index, List<dynamic> value) async {
    _courseData[index] = value;
    return await _storage.setString("courseData", jsonEncode(_courseData));
  }

  /// 设置数据
  Future<bool> setExperimentData(int index, List<dynamic> value) async {
    _experimentData[index] = value;
    return await _storage.setString(
        "experimentData", jsonEncode(_experimentData));
  }

  /// 设置数据
  Future<bool> _setSettings(String key, dynamic value) async {
    _settings[key] = value;
    return await _storage.setString("settings", jsonEncode(_settings));
  }

  /// 设置学期数据
  Future<bool> _setSemesterWeekData(String key, dynamic value) async {
    _semesterWeekData[key] = value;
    notifyListeners();
    return await _storage.setString(
        "semesterWeekData", jsonEncode(_semesterWeekData));
  }

  /// 设置数据
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

  /// 获取字体
  String? getFontFamily() {
    if (_settings["fontFamily"] == "default") {
      return null;
    }
    return _settings["fontFamily"];
  }

  /// 设置语言
  Future<void> setLocale(String select) async {
    await _setSettings("language", select);
    notifyListeners();
  }

  /// 设置字体
  Future<void> setFontFamily(String fontFamily) async {
    await _setSettings("fontFamily", fontFamily);
    notifyListeners();
  }

  /// 设置登录状态
  Future<void> setIsLogin(bool isLogin) async {
    await _setSettings("isLogin", isLogin);
    notifyListeners();
  }

  /// 设置数据是否第一次初始化完成
  Future<void> setLoad20CountCourse(bool load20CountCourse) async {
    await _setSettings("load20CountCourse", load20CountCourse);
    notifyListeners();
  }

  /// 设置本地默认语言
  Future<void> setDeviceLocale(String deviceLocale) async {
    await _setSettings("deviceLocale", deviceLocale);
  }

  /// 设置主题模式
  Future<void> setThemeMode(String themeMode) async {
    await _setSettings("themeMode", themeMode);
    notifyListeners();
  }

  /// 获取主题模式
  ThemeMode? getThemeMode() {
    if (_settings["themeMode"] == "default") {
      return ThemeMode.system;
    } else if (_settings["themeMode"] == "light") {
      return ThemeMode.light;
    } else if (_settings["themeMode"] == "dark") {
      return ThemeMode.dark;
    }
    return null;
  }

  /// 设置主题颜色
  Future<void> setColorTheme(String colorTheme, String colorThemeName) async {
    await _setSettings("colorTheme", colorTheme);
    await _setSettings("colorThemeName", colorThemeName);
    notifyListeners();
  }

  /// 获取主题颜色
  Color getColorTheme() {
    return Color(int.parse(_settings["colorTheme"].substring(1), radix: 16));
  }

  /// 设置开始日期
  Future<void> setStartDate(String startDate) async {
    await _setSemesterWeekData("startDay", startDate);
  }

  /// 设置学期
  Future<void> setSemester(String semester) async {
    await _setSemesterWeekData("semester", semester);
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
