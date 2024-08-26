import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../../common/widget/score_card/view.dart';
import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionScorePage extends StatelessWidget {
  FunctionScorePage({super.key});

  final logic = Get.put(FunctionScoreLogic());
  final state = Get.find<FunctionScoreLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).function_score_title,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.select_all_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              showSemesterList();
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 获取SliverList
          sliverListWidget(),
          // 暂无成绩
          emptyScoreWidget(),
        ],
      ),
    );
  }

  /// 暂无成绩
  Widget emptyScoreWidget() {
    return GetBuilder<FunctionScoreLogic>(
      builder: (logic) {
        if (logic.state.personScoreList.isEmpty &&
            !logic.state.isLoading.value) {
          return SliverPadding(
            padding: EdgeInsets.only(
              top: ScreenUtils.length(
                vertical: 350.w,
                horizon: 120.w,
              ),
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  S.current.function_score_empty,
                  style: TextStyle(
                    fontSize: ScreenUtils.length(
                      vertical: 40.sp,
                      horizon: 30.sp,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }

  /// 间距
  Widget heightSpaceWidget() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenUtils.length(
          vertical: 100.w,
          horizon: 50.w,
        ),
      ),
    );
  }

  /// 获取SliverList
  Widget sliverListWidget() {
    return GetBuilder<FunctionScoreLogic>(builder: (logic) {
      return SliverList.builder(
        itemCount: logic.state.personScoreList.length,
        itemBuilder: (context, index) {
          return ScoreCardComponent(
            subjectName: logic.state.personScoreList[index]['className'],
            subTitle: S.of(context).function_score_gpa(
                logic.state.personScoreList[index]['classGPA']),
            score: logic.state.personScoreList[index]['classScore'],
          );
        },
      );
    });
  }

  /// 学期弹出选择列表
  void showSemesterList() {
    PickerDataAdapter<String> adapter = logic.getSemesterPickerData();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [state.currentSemesterIndex.value],
      changeToFirst: true,
      textAlign: TextAlign.left,
      textStyle: TextStyle(
        color: Theme.of(Get.context!).colorScheme.primary,
        fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
      ),
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(Get.context!).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: ScreenUtils.length(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: ScreenUtils.length(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: ScreenUtils.length(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      containerColor:
          Theme.of(Get.context!).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(
        vertical: 350.w,
        horizon: 130.w,
      ),
      itemExtent: ScreenUtils.length(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(Get.context!);
          },
          child: Text(
            S.of(Get.context!).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(
                vertical: 22.sp,
                horizon: 15.sp,
              ),
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
      onConfirm: logic.selectSemesterConfirm,
    );
    picker.showModal(Get.context!);
  }
}
