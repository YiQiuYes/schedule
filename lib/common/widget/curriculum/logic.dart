import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../generated/l10n.dart';
import '../../../global_logic.dart';
import 'state.dart';

class CurriculumLogic extends GetxController {
  final CurriculumState state = CurriculumState();
  final globalLogic = Get.find<GlobalLogic>();
  final globalState = Get.find<GlobalLogic>().state;

  /// 获取节次背景颜色
  Color? getSectionColor(int showWeek, int index, BuildContext context) {
    final defaultColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
    // 获取当前周次
    int week = int.parse(globalState.semesterWeekData["currentWeek"]);
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
  Color? getTodayCourseColor(int showWeek, int index, BuildContext context,
      List course, List experiment) {
    final defaultColor =
        Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.8);
    final heightColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);
    // 获取当前周次
    int week = int.parse(globalState.semesterWeekData["currentWeek"]);
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
        // 找到当前课程的时间
        if (currentHourAndMinute.compareTo(time[i]) < 0) {
          if (currentSectionTime == i) {
            return heightColor;
          } else if (currentSectionTime > i) {
            int start = day - 1 + (currentSectionTime - 1) * 7;
            for (int j = start; j <= index; j += 7) {
              if (course[j].isNotEmpty || experiment[j].isNotEmpty) {
                return defaultColor;
              }
            }
            return heightColor;
          }
          break;
        }
      }
      return defaultColor;
    }

    return defaultColor;
  }

  /// 获取今日是周几并且时间正确
  Color? getTodayWeekColor(int showWeek, int day, BuildContext context) {
    // 获取当前周次
    int week = int.parse(globalState.semesterWeekData["currentWeek"]);
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

  /// 点击查看课程详细
  void showCourseDetail(BuildContext context, dynamic course, Map experiment) {
    List<Map> listData = [];
    if (course.isNotEmpty) {
      if (course is List) {
        for (Map data in course) {
          listData.add(data);
        }
      } else {
        listData.add(course);
      }
    }

    if (experiment.isNotEmpty) {
      listData.add(experiment);
    }

    List<Widget> list = [];
    for (Map data in listData) {
      const heightWidget = SizedBox(height: 10);
      list.add(heightWidget);
      list.add(Text(S.of(context).schedule_course_name(data["className"])));
      list.add(heightWidget);
      list.add(
          Text(S.of(context).schedule_course_teacher(data["classTeacher"])));
      list.add(heightWidget);
      list.add(Text(S.of(context).schedule_course_time(data["classTime"])));
      list.add(heightWidget);
      list.add(Text(S.of(context).schedule_course_room(data["classAddress"])));
      list.add(heightWidget);
      list.add(const Text("ヾ(≧▽≦*)o"));
    }
    list.removeLast();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).schedule_course_detail),
          content: SizedBox(
            width: ScreenUtils.length(vertical: 200.w, horizon: 250.w),
            child: ListView(
              shrinkWrap: true,
              children: list,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(S.of(context).pickerConfirm),
            )
          ],
        );
      },
    );
  }
}
