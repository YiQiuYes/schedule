import 'dart:async';
import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
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
    state.settings["isLogin"] = true;

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

  /// 设置数据是否第一次初始化完成
  Future<void> setLoad20CountCourse(bool load20CountCourse) async {
    state.settings["load20CountCourse"] = load20CountCourse;
    await _setSettings("load20CountCourse", load20CountCourse);
  }

  /// 设置数据
  Future<bool> _setSettings(String key, dynamic value) async {
    state.settings[key] = value;
    return await _storage.setString("settings", jsonEncode(state.settings));
  }

  /// 设置数据
  Future<bool> setScheduleUserInfo(String key, dynamic value) async {
    state.scheduleUserInfo[key] = value;
    return await _storage.setString(
        "userInfoData", jsonEncode(state.scheduleUserInfo));
  }

  /// 设置登录状态
  Future<void> setIsLogin(bool isLogin) async {
    state.settings["isLogin"] = isLogin;
    await _setSettings("isLogin", isLogin);
    update();
  }
}
