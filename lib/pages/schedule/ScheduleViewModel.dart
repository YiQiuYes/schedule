import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';

class ScheduleViewModel with ChangeNotifier {
  // tabBarController
  late TabController tabController;
  // 定时器限流
  Timer? timer;

  final _screen = ScreenAdaptor();

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
      return Theme.of(context).colorScheme.primary.withOpacity(0.3);
    }
    return null;
  }

  /// 获取今日是周几并且时间正确阴影颜色
  List<BoxShadow>? getTodayWeekBoxShadow(
      int showWeek, int day, BuildContext context) {
    // 获取当前周次
    int week = int.parse(globalModel.semesterWeekData["currentWeek"]);
    if (week - 1 != showWeek) {
      return null;
    }

    // 今天是星期几
    DateTime today = DateTime.now();
    if (today.weekday == day) {
      return [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
          blurRadius: 4,
          blurStyle: BlurStyle.outer,
        ),
      ];
    }
    return null;
  }

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

  /// 获取节次阴影颜色
  List<BoxShadow>? getSectionBoxShadow(
      int showWeek, int index, BuildContext context) {
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
    final defaultShadowList = [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
        blurRadius: 4,
        blurStyle: BlurStyle.outer,
      ),
    ];
    final now = DateTime.now();
    final currentHourAndMinute =
        "${now.hour < 10 ? "0${now.hour}" : now.hour}:${now.minute}";

    for (int i = 0; i < time.length; i++) {
      if (currentHourAndMinute.compareTo(time[i]) < 0) {
        if (i == index) {
          return defaultShadowList;
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
      final currentHourAndMinute = "${now.hour < 10 ? "0${now.hour}" : now.hour}:${now.minute}";

      for (int i = 0; i < time.length; i++) {
        if (currentHourAndMinute.compareTo(time[i]) < 0) {
          if (currentSectionTime == i) {
            return heightColor;
          }
          break;
        }
      }
      return defaultColor;
    }

    return defaultColor;
  }

  /// 获取今日课程阴影颜色
  List<BoxShadow>? getTodayCourseBoxShadow(
      int showWeek, int index, BuildContext context) {
    return [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
        blurRadius: 2.5,
        blurStyle: BlurStyle.outer,
      ),
    ];
  }

  /// 周次标题点击事件
  void weekTitleTap(int index, BuildContext context) {
    List<String> pickerData = [];
    for (int i = 0; i < 20; i++) {
      pickerData.add(getTabPageWeek(S.of(context).scheduleViewCurrentWeek, i));
    }

    var adapter = PickerDataAdapter<String>(pickerData: pickerData);

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [index],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: _screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: _screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: _screen.getLengthByOrientation(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: _screen.getLengthByOrientation(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: _screen.getLengthByOrientation(
        vertical: 500.w,
        horizon: 150.w,
      ),
      itemExtent: _screen.getLengthByOrientation(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) {
        tabController.animateTo(value[0]);
      },
    );
    picker.showModal(context);
  }
}
