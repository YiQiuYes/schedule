import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/main.dart';

class ScheduleViewModel with ChangeNotifier {
  // tabBarController
  late TabController tabController;
  // 定时器限流
  Timer? timer;

  /// 初始化
  void init() {
    // 获取课程数据
    bool load20CountCourse = globalModel.settings["load20CountCourse"];
    if (!load20CountCourse) {
      for (int i = 1; i <= 20; i++) {
        globalModel.getPersonCourseData(
            week: i.toString(),
            semester: globalModel.semesterWeekData["semester"]);
      }
      globalModel.setSettings("load20CountCourse", true);
    } else {
      globalModel.getPersonCourseData(
          week: globalModel.semesterWeekData["currentWeek"],
          semester: globalModel.semesterWeekData["semester"]);
    }

    notifyListeners();
  }

  /// 通过索引计算是第几周
  String getTabPageWeek(String text, int index) {
    index++;
    return text.replaceAll("%%", index.toString());
  }

  /// 通过索引计算是第几个年月
  String getTabPageTodayDate(int index, String param) {
    String startDay = ScheduleUtils.formatDateString(
        globalModel.semesterWeekData["startDay"]);
    DateTime now = DateTime.parse(startDay);
    DateTime today = now.add(Duration(days: index * 7));
    String dataStr = param
        .replaceAll("%%", today.year.toString())
        .replaceAll("&&", today.month.toString());
    // logger.i(today);
    return dataStr;
  }

  /// 初始化tabBarController
  void initTabController(TickerProvider vsync) {
    tabController = TabController(
      initialIndex: int.parse(globalModel.semesterWeekData["currentWeek"]) - 1,
      length: 20,
      vsync: vsync,
    );
    tabController.addListener(() {
      timer?.cancel();
      timer = Timer(const Duration(milliseconds: 1000), () {
        globalModel.getPersonCourseData(
          week: (tabController.index + 1).toString(),
          semester: globalModel.semesterWeekData["semester"],
        );
        // 销毁定时器
        timer?.cancel();
      });
    });
  }

  /// 获取今日是周几并且时间正确
  Color? getTodayWeekColor(int showWeek, int day, BuildContext context) {
    // 获取当前周次
    int week = int.parse(globalModel.semesterWeekData["currentWeek"]);
    if (week - 1 != showWeek) {
      return null;
    }

    // 今天是星期几
    DateTime today = DateTime.now();
    if (today.weekday == day) {
      return Theme.of(context).primaryColor.withOpacity(0.3);
    }
    return null;
  }

  /// 获取今日课程颜色
  Color? getTodayCourseColor(int showWeek, int day, BuildContext context) {
    // 获取当前周次
    int week = int.parse(globalModel.semesterWeekData["currentWeek"]);
    if (week - 1 != showWeek) {
      return Theme.of(context).shadowColor.withOpacity(0.15);
    }

    // 今天是星期几
    DateTime today = DateTime.now();
    if (today.weekday == day) {
      return Theme.of(context).primaryColor.withOpacity(0.3);
    }

    return Theme.of(context).shadowColor.withOpacity(0.15);
  }
}
