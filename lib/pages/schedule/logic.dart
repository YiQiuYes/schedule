import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';
import 'package:schedule/global_logic.dart';

import '../../common/utils/schedule_utils.dart';
import '../../generated/l10n.dart';
import 'state.dart';

class ScheduleLogic extends GetxController {
  final ScheduleState state = ScheduleState();
  final globalLogic = Get.find<GlobalLogic>();
  final globalState = Get.find<GlobalLogic>().state;

  /// 初始化
  Future<void> init() async {
    // 获取课程数据
    bool load20CountCourse = globalState.settings["load20CountCourse"];
    if (!load20CountCourse) {
      for (int i = 1; i <= 20; i++) {
        await globalLogic.getPersonCourseData(
            week: i.toString(),
            semester: globalState.semesterWeekData["semester"]);
        await globalLogic.getPersonExperimentData(
            week: i.toString(),
            semester: globalState.semesterWeekData["semester"]);
      }
      globalLogic.setLoad20CountCourse(true);
    } else {
      await globalLogic.getPersonCourseData(
          week: globalState.semesterWeekData["currentWeek"],
          semester: globalState.semesterWeekData["semester"]);
      await globalLogic.getPersonExperimentData(
          week: globalState.semesterWeekData["currentWeek"],
          semester: globalState.semesterWeekData["semester"]);
    }
    globalLogic.update();
  }

  /// 初始化tabBarController
  void initTabController(TickerProvider vsync) {
    int initialIndex =
        int.parse(globalState.semesterWeekData["currentWeek"]) - 1;
    if (initialIndex > 20) {
      initialIndex = 19;
    }
    state.tabController = TabController(
      initialIndex: initialIndex,
      length: 20,
      vsync: vsync,
    );
    state.tabController.addListener(() {
      // 获取课程数据
      globalLogic.getPersonCourseData(
        week: (state.tabController.index + 1).toString(),
        semester: globalState.semesterWeekData["semester"],
      );
      // 获取实验课程数据
      globalLogic.getPersonExperimentData(
        week: (state.tabController.index + 1).toString(),
        semester: globalState.semesterWeekData["semester"],
      );
      globalLogic.update();
    });
  }

  /// 通过索引计算是第几个年
  String getTabPageTodayYear(int index) {
    String startDay = ScheduleUtils.formatDateString(
        globalState.semesterWeekData["startDay"]);
    DateTime now = DateTime.parse(startDay);
    DateTime today = now.add(Duration(days: index * 7));
    return today.year.toString();
  }

  /// 通过索引计算是第几个月
  String getTabPageTodayMonth(int index) {
    String startDay = ScheduleUtils.formatDateString(
        globalState.semesterWeekData["startDay"]);
    DateTime now = DateTime.parse(startDay);
    DateTime today = now.add(Duration(days: index * 7));
    return today.month.toString();
  }

  /// 周次标题点击事件
  void weekTitleTap(int index, BuildContext context) {
    List<String> pickerData = [];
    for (int i = 0; i < 20; i++) {
      pickerData.add(S.of(context).schedule_current_week(i + 1));
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
        left: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 500.w, horizon: 150.w),
      itemExtent: ScreenUtils.length(vertical: 70.w, horizon: 40.w),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 30.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 30.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) {
        state.tabController.animateTo(value[0]);
      },
    );
    picker.showModal(context);
  }
}