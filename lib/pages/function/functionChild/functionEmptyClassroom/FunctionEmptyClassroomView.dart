import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';
import 'FunctionEmptyClassroomViewModel.dart';

class FunctionEmptyClassroomView extends StatelessWidget {
  const FunctionEmptyClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final model = FunctionEmptyClassroomViewModel();
        model.init();
        return model;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                // SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                // 第几节课选择器
                _getLessonSelector(context),
                // 空教室列表
                _getGridView(context),
                // 安全距离
                _getSafeArea(),
              ],
            ),
          ),
        ),
        floatingActionButton: _getSettingFloatBtn(context),
      ),
    );
  }

  /// 安全距离
  Widget _getSafeArea() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 190.w,
          horizon: 90.w,
        ),
      ),
    );
  }

  /// 获取网格布局
  Widget _getGridView(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 20.w,
          horizon: 4.w,
        ),
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
        right: ScreenAdaptor().getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
      ),
      sliver: Consumer<FunctionEmptyClassroomViewModel>(
          builder: (context, model, child) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ScreenAdaptor().byOrientationReturn(
              vertical: 3,
              horizon: 5,
            )!,
            crossAxisSpacing: ScreenAdaptor().getLengthByOrientation(
              vertical: 10.w,
              horizon: 5.w,
            ),
            mainAxisSpacing: ScreenAdaptor().getLengthByOrientation(
              vertical: 10.w,
              horizon: 5.w,
            ),
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
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 15.w,
                      horizon: 10.w,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenAdaptor().getLengthByOrientation(
                    vertical: 36.w,
                    horizon: 15.w,
                  ),
                ),
                child: Text(
                  ScheduleUtils.formatAddress(model.emptyClassroomList[index], breakWord: true),
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: ScreenAdaptor().getLengthByOrientation(
                      vertical: 28.sp,
                      horizon: 18.sp,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            childCount: model.emptyClassroomList.length,
          ),
        );
      }),
    );
  }

  /// 获取设置按钮
  Widget _getSettingFloatBtn(BuildContext context) {
    return Consumer<FunctionEmptyClassroomViewModel>(
      builder: (context, model, child) {
        return FloatingActionButton(
          onPressed: () {
            // 点击选择教学楼
            model.choiceBuilding(context);
          },
          child: const Icon(Icons.home_rounded),
        );
      },
    );
  }

  /// 获取第几节课选择器
  Widget _getLessonSelector(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 20.w,
          horizon: 4.w,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.center,
          child: Consumer<FunctionEmptyClassroomViewModel>(
              builder: (context, model, child) {
            return InkWell(
              borderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 15.w,
                  horizon: 10.w,
                ),
              ),
              onTap: () {
                // 点击选择第几节课
                model.choiceLesson(context);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenAdaptor().getLengthByOrientation(
                    vertical: 20.w,
                    horizon: 10.w,
                  ),
                  right: ScreenAdaptor().getLengthByOrientation(
                    vertical: 20.w,
                    horizon: 10.w,
                  ),
                  top: ScreenAdaptor().getLengthByOrientation(
                    vertical: 15.w,
                    horizon: 12.w,
                  ),
                  bottom: ScreenAdaptor().getLengthByOrientation(
                    vertical: 7.w,
                    horizon: 5.w,
                  ),
                ),
                child: Text(
                  model.getLessonText(context, model.lessonIndex),
                  style: TextStyle(
                    fontSize: ScreenAdaptor().getLengthByOrientation(
                      vertical: 50.sp,
                      horizon: 33.sp,
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
  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 160.h,
        horizon: 170.h,
      ),
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 60.h,
        horizon: 80.h,
      ),
      pinned: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Consumer<FunctionEmptyClassroomViewModel>(
            builder: (context, model, child) {
          return Text(
            "${S.of(context).functionEmptyClassroom} - ${model.selectedBuilding["buildingName"]}",
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 38.sp,
                horizon: 20.sp,
              ),
            ),
          );
        }),
        centerTitle: false,
      ),
    );
  }
}
