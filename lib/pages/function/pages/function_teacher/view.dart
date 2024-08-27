import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/widget/score_card/view.dart';

import '../../../../common/utils/schedule_utils.dart';
import '../../../../common/utils/screen_utils.dart';
import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionTeacherPage extends StatelessWidget {
  FunctionTeacherPage({super.key});

  final logic = Get.put(FunctionTeacherLogic());
  final state = Get.find<FunctionTeacherLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: CustomScrollView(
        controller: state.scrollController,
        slivers: <Widget>[
          // 搜索条
          sliverSearchBarWidget(context),
          // 获取SliverList
          sliverListWidget(context),
          // 安全间距
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: ScreenUtils.length(vertical: 100.h, horizon: 130.h),
            ),
            sliver: const SliverToBoxAdapter(),
          ),
        ],
      ),
    );
  }

  /// 获取SliverList
  Widget sliverListWidget(BuildContext context) {
    return GetBuilder<FunctionTeacherLogic>(builder: (logic) {
      List<Widget> widgets = [];

      if (logic.state.teacherCourseList.isEmpty) {
        widgets.add(Padding(
          padding: EdgeInsets.only(
            top: ScreenUtils.length(vertical: 300.h, horizon: 310.h),
          ),
          child: Center(
            child: Text(
              S.of(context).function_teacher_no_data,
              style: TextStyle(
                fontSize: ScreenUtils.length(vertical: 40.sp, horizon: 20.sp),
              ),
            ),
          ),
        ));
        return SliverList(delegate: SliverChildListDelegate(widgets));
      }

      // 遍历教师课表数据
      return SliverList.builder(
        itemCount: logic.state.teacherCourseList.length,
        itemBuilder: (context, indexTeacher) {
          return Column(children: [
            Text(
              logic.state.teacherCourseList[indexTeacher]["teacherName"],
              style: TextStyle(
                fontSize: ScreenUtils.length(vertical: 40.sp, horizon: 17.sp),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: ScreenUtils.length(vertical: 20.h, horizon: 15.h),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logic
                  .state.teacherCourseList[indexTeacher]["classList"].length,
              itemBuilder: (context, index) {
                return ScoreCardComponent(
                  subjectName: logic.state.teacherCourseList[indexTeacher]
                      ["classList"][index]["className"],
                  subTitle: logic.getCourseTime(
                      logic.state.teacherCourseList[indexTeacher]["classList"]
                          [index]["classTime"],
                      logic.state.teacherCourseList[indexTeacher]["classList"]
                          [index]["week"],
                      logic.state.teacherCourseList[indexTeacher]["classList"]
                          [index]["lesson"]),
                  score: ScheduleUtils.formatAddress(
                      logic.state.teacherCourseList[indexTeacher]["classList"]
                          [index]["classAddress"]),
                );
              },
            ),
            SizedBox(
              height: ScreenUtils.length(vertical: 15.h, horizon: 15.h),
            ),
          ]);
        },
      );
    });
  }

  /// 获取appBar
  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).function_teacher_title),
    );
  }

  /// 获取搜索条
  Widget sliverSearchBarWidget(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      toolbarHeight: ScreenUtils.length(vertical: 110.h, horizon: 130.h),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.topRight,
        child: GetBuilder<FunctionTeacherLogic>(builder: (logic) {
          return AnimatedBuilder(
            animation: logic.state.scrollController,
            builder: (context, child) {
              return LayoutBuilder(builder: (context, constraints) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: max(
                    constraints.maxWidth -
                        logic.state.scrollController.offset.roundToDouble(),
                    constraints.maxWidth -
                        ScreenUtils.byOrientationReturn(
                            vertical: 450.w, horizon: 155.w)!,
                  ),
                  child: SearchBar(
                    controller: logic.state.teacherNameController,
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtils.length(vertical: 13.w, horizon: 8.w),
                        right: ScreenUtils.length(vertical: 5.w, horizon: 2.w),
                      ),
                      child: const Icon(Icons.search),
                    ),
                    hintText: S.of(context).function_teacher_search_hint,
                    onSubmitted: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      logic.getTeacherCourse(value);
                    },
                  ),
                );
              });
            },
          );
        }),
      ),
    );
  }
}
