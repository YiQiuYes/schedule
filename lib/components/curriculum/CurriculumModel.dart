import 'package:flutter/material.dart';

import '../../main.dart';

class CurriculumModel with ChangeNotifier {
  /// 获取节次背景颜色
  Color? getSectionColor(int showWeek, int index, BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
    // 获取当前周次
    int week = int.parse(globalModel.semesterWeekData["currentWeek"]);
    if (week - 1 != showWeek) {
      return null;
    }

    const time = [
      "09:45",
      "11:40",
      "15:40",
      "17:40",
      "20:40",
    ];
    final now = DateTime.now();
    final currentHourAndMinute =
        "${now.hour < 10 ? "0${now.hour}" : now.hour}:${now.minute}";

    for (int i = 0; i < time.length; i++) {
      if (currentHourAndMinute.compareTo(time[i]) < 0) {
        if (index == i) {
          return defaultColor;
        }
        break;
      }
    }
    return null;
  }

  /// 获取今日课程背景颜色
  Color? getTodayCourseColor(int showWeek, int index, BuildContext context) {
    final defaultColor =
    Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.8);
    final heightColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
    // 获取当前周次
    int week = int.parse(globalModel.semesterWeekData["currentWeek"]);
    if (week - 1 != showWeek) {
      return defaultColor;
    }

    // 今天是星期几
    DateTime today = DateTime.now();
    int day = index % 7 + 1;
    if (today.weekday == day) {
      // 计算当前课程为第几节课
      int currentSectionTime = index ~/ 7;

      const time = [
        "09:45",
        "11:40",
        "15:40",
        "17:40",
        "20:40",
      ];
      final now = DateTime.now();
      final currentHourAndMinute =
          "${now.hour < 10 ? "0${now.hour}" : now.hour}:${now.minute}";

      for (int i = 0; i < time.length; i++) {
        if (currentHourAndMinute.compareTo(time[i]) < 0) {
          if (currentSectionTime == i) {
            return heightColor;
          } else if (currentSectionTime > i) {
            for (int j = day - 1; j < index; j += 7) {
              if (globalModel.courseData[showWeek][j].isNotEmpty) {
                return defaultColor;
              }
            }
            return heightColor;
          }
        }
      }
      return defaultColor;
    }

    return defaultColor;
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
      return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }
    return null;
  }
}