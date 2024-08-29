import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/widget/curriculum/view.dart';

import '../../../../common/utils/screen_utils.dart';
import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionAllCoursePage extends StatelessWidget {
  FunctionAllCoursePage({super.key});

  final logic = Get.put(FunctionAllCourseLogic());
  final state = Get.find<FunctionAllCourseLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return Scaffold(
      appBar: appBarWidget(context),
      body: Stack(
        children: [
          // 主体
          mainBodyWidget(),
          // 课表加载中
          loadingWidget(),
        ],
      ),
    );
  }

  /// 获取AppBar
  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(
      title: Text(S.current.function_all_course_title),
      actions: [
        GetBuilder<FunctionAllCourseLogic>(builder: (logic) {
          return IconButton(
            icon: Icon(
              Icons.select_all_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              logic.state.isLoad.value == false
                  ? showSemesterList(logic)
                  : null;
            },
          );
        }),
        GetBuilder<FunctionAllCourseLogic>(builder: (logic) {
          return IconButton(
            icon: Icon(
              Icons.access_time_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              logic.state.isLoad.value == false ? showWeeksList(logic) : null;
            },
          );
        }),
      ],
    );
  }

  /// 获取主体Widget
  Widget mainBodyWidget() {
    return GetBuilder<FunctionAllCourseLogic>(builder: (logic) {
      return Visibility(
        visible: !logic.state.isLoad.value,
        child: CustomScrollView(
          slivers: [
            // 课表
            curriculumWidget(),
            // 底部间隔
            SliverToBoxAdapter(
              child: SizedBox(
                height: ScreenUtils.length(vertical: 130.w, horizon: 25.w),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// 获取课表加载中
  Widget loadingWidget() {
    return GetBuilder<FunctionAllCourseLogic>(
      builder: (logic) {
        return Visibility(
          visible: logic.state.isLoad.value,
          child: Center(
            child: Text(
              S.current.function_all_course_loading,
              style: TextStyle(
                fontSize: ScreenUtils.length(vertical: 55.sp, horizon: 17.sp),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 获取课表组件
  Widget curriculumWidget() {
    return GetBuilder<FunctionAllCourseLogic>(builder: (logic) {
      return CurriculumComponent(
        showWeek: int.parse(logic.state.week.value) - 1,
        courseData: logic.state.courseData,
        crossAxisSpacing: ScreenUtils.byOrientationReturn(horizon: 2.w),
        classNameFontSize: ScreenUtils.byOrientationReturn(horizon: 6.sp),
        classAddressFontSize: ScreenUtils.byOrientationReturn(horizon: 5.sp),
        weekFontSize: ScreenUtils.byOrientationReturn(horizon: 8.sp),
        dateFontSize: ScreenUtils.byOrientationReturn(horizon: 6.sp),
        verticalPadding: ScreenUtils.byOrientationReturn(horizon: 4.5.w),
        horizontalPadding: ScreenUtils.byOrientationReturn(horizon: 3.w),
        classNameLinesLimit: ScreenUtils.byOrientationReturn(horizon: 4),
      );
    });
  }

  /// 弹出选择班级课表
  void showSemesterList(FunctionAllCourseLogic logic) {
    PickerDataAdapter<dynamic> adapter = logic.getClassPickerData();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: logic.state.collegeAndMajorIndex,
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(Get.context!).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      containerColor:
          Theme.of(Get.context!).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 350.w, horizon: 130.w),
      itemExtent: ScreenUtils.length(vertical: 60.w, horizon: 40.w),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.w),
        ),
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(Get.context!);
          },
          child: Text(
            S.of(Get.context!).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
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
            adapter.picker!.doCancel(Get.context!);
          },
          child: Text(
            S.of(Get.context!).pickerCancel,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: logic.selectCollegeAndMajorConfirm,
    );
    picker.showModal(Get.context!);
  }

  /// 弹出周次选择器
  void showWeeksList(FunctionAllCourseLogic logic) {
    PickerDataAdapter<dynamic> adapter = logic.getWeekPickerData(Get.context!);

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [int.parse(logic.state.week.value) - 1],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(Get.context!).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      containerColor:
          Theme.of(Get.context!).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 350.w, horizon: 130.w),
      itemExtent: ScreenUtils.length(vertical: 60.w, horizon: 40.w),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.w),
        ),
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(Get.context!);
          },
          child: Text(
            S.of(Get.context!).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
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
            adapter.picker!.doCancel(Get.context!);
          },
          child: Text(
            S.of(Get.context!).pickerCancel,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: logic.selectWeekConfirm,
    );
    picker.showModal(Get.context!);
  }
}
