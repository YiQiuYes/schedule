import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../../common/utils/schedule_utils.dart';
import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionEmptyClassroomPage extends StatelessWidget {
  FunctionEmptyClassroomPage({super.key});

  final logic = Get.put(FunctionEmptyClassroomLogic());
  final state = Get.find<FunctionEmptyClassroomLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return Scaffold(
      appBar: appBarWidget(context),
      body: CustomScrollView(
        slivers: <Widget>[
          // 第几节课选择器
          lessonSelectorWidget(),
          // 空教室列表
          gridViewWidget(context),
          // 安全间距
          safeHeightWidget(),
        ],
      ),
      floatingActionButton: settingFloatBtnWidget(),
    );
  }

  /// 获取安全间距
  Widget safeHeightWidget() {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: ScreenUtils.length(vertical: 150.w, horizon: 50.w)));
  }

  /// 获取网格布局
  Widget gridViewWidget(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 20.w, horizon: 4.w),
        left: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
        right: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
      ),
      sliver: GetBuilder<FunctionEmptyClassroomLogic>(builder: (logic) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                ScreenUtils.byOrientationReturn(vertical: 3, horizon: 3)!,
            crossAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 5.w),
            mainAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 5.w),
            childAspectRatio: 2,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(
                    ScreenUtils.length(vertical: 15.w, horizon: 10.w),
                  ),
                ),
                child: Center(
                  child: Text(
                    ScheduleUtils.formatAddress(
                        logic.state.emptyClassroomList[index],
                        breakWord: true),
                    maxLines: 2,
                    style: TextStyle(
                      fontSize:
                          ScreenUtils.length(vertical: 20.sp, horizon: 9.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            childCount: logic.state.emptyClassroomList.length,
          ),
        );
      }),
    );
  }

  /// 获取设置按钮
  Widget settingFloatBtnWidget() {
    return GetBuilder<FunctionEmptyClassroomLogic>(
      builder: (logic) {
        return FloatingActionButton(
          onPressed: () {
            // 点击选择教学楼
            logic.choiceBuilding(Get.context!);
          },
          child: const Icon(Icons.home_rounded),
        );
      },
    );
  }

  /// 获取第几节课选择器
  Widget lessonSelectorWidget() {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(
          vertical: 20.w,
          horizon: 4.w,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.center,
          child: GetBuilder<FunctionEmptyClassroomLogic>(builder: (logic) {
            return InkWell(
              borderRadius: BorderRadius.circular(
                ScreenUtils.length(
                  vertical: 15.w,
                  horizon: 10.w,
                ),
              ),
              onTap: () {
                // 点击选择第几节课
                logic.choiceLesson(Get.context!);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtils.length(
                    vertical: 20.w,
                    horizon: 10.w,
                  ),
                  right: ScreenUtils.length(
                    vertical: 20.w,
                    horizon: 10.w,
                  ),
                  top: ScreenUtils.length(
                    vertical: 15.w,
                    horizon: 5.w,
                  ),
                  bottom: ScreenUtils.length(
                    vertical: 20.w,
                    horizon: 6.w,
                  ),
                ),
                child: Text(
                  logic.getLessonText(
                      Get.context!, logic.state.lessonIndex.value),
                  style: TextStyle(
                    fontSize: ScreenUtils.length(
                      vertical: 35.sp,
                      horizon: 16.sp,
                    ),
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// 获取SliverAppBar
  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(
      title: GetBuilder<FunctionEmptyClassroomLogic>(builder: (logic) {
        return Text(
          "${S.of(context).function_empty_classroom} - ${logic.state.selectedBuilding["buildingName"]}",
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        );
      }),
    );
  }
}
