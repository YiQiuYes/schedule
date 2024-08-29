import 'dart:async';
import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_query_api.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/global_state.dart';

import 'common/manager/data_storage_manager.dart';
import 'common/utils/schedule_utils.dart';

class GlobalLogic extends GetxController {
  final GlobalState state = GlobalState();
  final _storage = DataStorageManager();
  final ScheduleQueryApi queryApi = ScheduleQueryApi();

  /// 刷新数据
  void refreshData() {
    // 格式化日期格式
    String startDay =
        ScheduleUtils.formatDateString(state.semesterWeekData["startDay"]);
    DateTime startDayTime = DateTime.parse(startDay);
    DateTime now = DateTime.now();
    // 计算当前周次
    int currentWeek = now.difference(startDayTime).inDays ~/ 7 + 1;
    if (currentWeek > 20) currentWeek = 20;
    state.semesterWeekData["currentWeek"] = currentWeek.toString();
  }

  /// 初始化
  void init() {
    state.timer?.cancel();
    state.timer ??= Timer.periodic(const Duration(minutes: 10), (timer) {
      refreshData();
    });

    // 读取课程数据
    String? courseDataStr = _storage.getString("courseData");
    if (courseDataStr != null) {
      state.courseData = (jsonDecode(courseDataStr) as List).obs;
    } else {
      _storage.setString("courseData", jsonEncode(state.courseData));
    }

    // 读取实验课表数据
    String? experimentDataStr = _storage.getString("experimentData");
    if (experimentDataStr != null) {
      state.experimentData = (jsonDecode(experimentDataStr) as List).obs;
    } else {
      _storage.setString("experimentData", jsonEncode(state.experimentData));
    }

    // 读取设置数据
    String? settingsStr = _storage.getString("settings");
    if (settingsStr != null) {
      Map<String, dynamic> map = jsonDecode(settingsStr);
      map.forEach((key, value) {
        state.settings[key] = value;
      });
    } else {
      _storage.setString("settings", jsonEncode(state.settings));
    }

    // 读取学期周次数据
    String? semesterWeekDataStr = _storage.getString("semesterWeekData");
    if (semesterWeekDataStr != null) {
      Map<String, dynamic> map = jsonDecode(semesterWeekDataStr);
      map.forEach((key, value) {
        state.semesterWeekData[key] = value;
      });

      // 格式化日期格式
      String startDay =
          ScheduleUtils.formatDateString(state.semesterWeekData["startDay"]);
      DateTime startDayTime = DateTime.parse(startDay);
      DateTime now = DateTime.now();
      // 计算当前周次
      int currentWeek = now.difference(startDayTime).inDays ~/ 7 + 1;
      if (currentWeek > 20) currentWeek = 20;
      state.semesterWeekData["currentWeek"] = currentWeek.toString();
      // logger.i("当前周次: $currentWeek");
    } else {
      // 格式化日期格式
      String startDay =
          ScheduleUtils.formatDateString(state.semesterWeekData["startDay"]);
      DateTime startDayTime = DateTime.parse(startDay);
      DateTime now = DateTime.now();
      // 计算当前周次
      int currentWeek = now.difference(startDayTime).inDays ~/ 7 + 1;
      state.semesterWeekData["currentWeek"] = currentWeek.toString();
      _storage.setString(
          "semesterWeekData", jsonEncode(state.semesterWeekData));
    }

    // 读取用户个人数据
    String? userInfoDataStr = _storage.getString("userInfoData");
    if (userInfoDataStr != null) {
      Map<String, dynamic> map = jsonDecode(userInfoDataStr);
      map.forEach((key, value) {
        state.scheduleUserInfo[key] = value;
      });
    } else {
      _storage.setString("userInfoData", jsonEncode(state.scheduleUserInfo));
    }

    // 读取惠生活798用户个人数据
    String? hui798UserInfoDataStr = _storage.getString("hui798UserInfoData");
    if (hui798UserInfoDataStr != null) {
      Map<String, dynamic> map = jsonDecode(hui798UserInfoDataStr);
      map.forEach((key, value) {
        state.hui798UserInfo[key] = value;
      });
    } else {
      _storage.setString(
          "hui798UserInfoData", jsonEncode(state.hui798UserInfo));
    }
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    if (state.settings["themeMode"] == "default") {
      return ThemeMode.system;
    } else if (state.settings["themeMode"] == "light") {
      // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   systemNavigationBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.dark,
      // );
      // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      return ThemeMode.light;
    } else if (state.settings["themeMode"] == "dark") {
      // SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      //   statusBarColor: Colors.transparent,
      //   systemNavigationBarColor: Colors.transparent,
      //   statusBarIconBrightness: Brightness.light,
      // );
      // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  /// 获取课程数据
  Future<void> getPersonCourseData(
      {required String week, required String semester}) async {
    await queryApi
        .queryPersonCourse(
            week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) async {
      await setCourseData(int.parse(week) - 1, value);
    });
  }

  /// 获取实验课表数据
  Future<void> getPersonExperimentData(
      {required String week, required String semester}) async {
    await queryApi
        .queryPersonExperimentCourse(
            week: week, semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) async {
      await setExperimentData(int.parse(week) - 1, value);
    });
  }

  /// 获取主题颜色
  Color getColorTheme() {
    return Color(int.parse(state.settings["colorTheme"].substring(1), radix: 16));
  }

  /// 获取语言
  Locale? getLocale() {
    String language = state.settings["language"];
    if (language.split("-").length > 1) {
      return Locale(language.split("-")[0], language.split("-")[1]);
    } else {
      return Locale(language);
    }
  }


  /// 设置莫奈取色
  Future<void> setMonetColor(bool isMonetColor) async {
    state.settings["isMonetColor"] = isMonetColor;
    await setSettings("isMonetColor", isMonetColor);
    update();
  }

  /// 设置主题颜色
  Future<void> setColorTheme(String colorTheme) async {
    await setSettings("colorTheme", colorTheme);
    await setSettings("isMonetColor", false);
    update();
  }

  /// 设置主题模式
  Future<void> setThemeMode(String themeMode) async {
    await setSettings("themeMode", themeMode);
    update();
  }

  /// 设置数据
  Future<bool> setCourseData(int index, List<dynamic> value) async {
    state.courseData[index] = value;
    return await _storage.setString("courseData", jsonEncode(state.courseData));
  }

  /// 设置数据
  Future<bool> setExperimentData(int index, List<dynamic> value) async {
    state.experimentData[index] = value;
    return await _storage.setString(
        "experimentData", jsonEncode(state.experimentData));
  }

  /// 设置开始日期
  Future<void> setStartDate(String startDate) async {
    await setSemesterWeekData("startDay", startDate);
  }

  /// 设置学期
  Future<void> setSemester(String semester) async {
    await setSemesterWeekData("semester", semester);
  }

  /// 设置数据是否第一次初始化完成
  Future<void> setLoad20CountCourse(bool load20CountCourse) async {
    state.settings["load20CountCourse"] = load20CountCourse;
    await setSettings("load20CountCourse", load20CountCourse);
  }

  /// 设置数据
  Future<bool> setSettings(String key, dynamic value) async {
    state.settings[key] = value;
    return await _storage.setString("settings", jsonEncode(state.settings));
  }

  /// 设置学期数据
  Future<bool> setSemesterWeekData(String key, dynamic value) async {
    state.semesterWeekData[key] = value;
    update();
    return await _storage.setString(
        "semesterWeekData", jsonEncode(state.semesterWeekData));
  }

  /// 设置数据
  Future<bool> setScheduleUserInfo(String key, dynamic value) async {
    state.scheduleUserInfo[key] = value;
    return await _storage.setString(
        "userInfoData", jsonEncode(state.scheduleUserInfo));
  }

  /// 设置数据
  Future<bool> setHui798UserInfo(String key, dynamic value) async {
    state.hui798UserInfo[key] = value;
    return await _storage.setString(
        "hui798UserInfoData", jsonEncode(state.hui798UserInfo));
  }

  /// 设置语言
  Future<void> setLocale(String select) async {
    await setSettings("language", select);
    update();
  }

  /// 设置登录状态
  Future<void> setIsLogin(bool isLogin) async {
    state.settings["isLogin"] = isLogin;
    await setSettings("isLogin", isLogin);
    update();
  }
}
