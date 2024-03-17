import 'package:flutter/material.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/main.dart';

class ScheduleViewModel with ChangeNotifier {
  // tabBarController
  late TabController tabController;

  /// 初始化
  void init() {
    // 获取课程数据

    bool load20CountCourse = globalModel.settings["load20CountCourse"];
    if (load20CountCourse) {
      for (int i = 1; i <= 20; i++) {
        globalModel.getPersonCourseData(
            week: i.toString(),
            semester: globalModel.semesterWeekData["semester"]);
      }
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
}
