import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/components/scoreCard/ScoreCard.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/pages/function/functionChild/functionTeacher/FunctionTeacherViewModel.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';

class FunctionTeacherView extends StatelessWidget {
  const FunctionTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_context) {
        final model = FunctionTeacherViewModel();
        return model;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // 页面主体
              Consumer<FunctionTeacherViewModel>(
                  builder: (context, model, child) {
                return NestedScrollView(
                  controller: model.scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      // 获取SliverAppBar
                      _getSliverAppBar(context),
                      // 获取搜索条
                      _getSliverSearchBar(context),
                    ];
                  },
                  body: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      // 获取SliverList
                      ..._getSliverList(context),
                      // 安全间距
                      SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: ScreenAdaptor().getLengthByOrientation(
                            vertical: 100.h,
                            horizon: 130.h,
                          ),
                        ),
                        sliver: const SliverToBoxAdapter(),
                      ),
                    ],
                  ),
                );
              }),
              // 返回按钮
              _getReturnButtonWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 返回按钮
  Widget _getReturnButtonWidget(BuildContext context) {
    return Positioned(
      left: 0.w,
      top: ScreenAdaptor().getLengthByOrientation(
        vertical: 32.w,
        horizon: 18.w,
      ),
      child: TextButton(
        child: Icon(
          Icons.arrow_back_rounded,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          GoRouter.of(context).pop();
        },
      ),
    );
  }

  /// 获取SliverList
  List<Widget> _getSliverList(BuildContext context) {
    List<Widget> widgets = [];
    // 获取provider
    final model = Provider.of<FunctionTeacherViewModel>(context);

    if (model.teacherCourseList.isEmpty) {
      widgets.add(SliverPadding(
        padding: EdgeInsets.only(
          top: ScreenAdaptor().getLengthByOrientation(
            vertical: 300.h,
            horizon: 60.h,
          ),
        ),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              S.of(context).functionTeacherNoData,
              style: TextStyle(
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: 40.sp,
                  horizon: 33.sp,
                ),
              ),
            ),
          ),
        ),
      ));
      return widgets;
    }

    // 遍历教师课表数据
    for (var item in model.teacherCourseList) {
      widgets.add(
        SliverPadding(
          padding: EdgeInsets.only(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 40.h,
              horizon: 30.h,
            ),
            bottom: ScreenAdaptor().getLengthByOrientation(
              vertical: 20.h,
              horizon: 15.h,
            ),
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: 30.w,
              horizon: 12.w,
            ),
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              item["teacherName"],
              style: TextStyle(
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: 40.sp,
                  horizon: 33.sp,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      widgets.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ScoreCard(
                subjectName: item["classList"][index]["className"],
                subTitle: model.getCourseTime(
                    item["classList"][index]["classTime"],
                    item["classList"][index]["week"],
                    item["classList"][index]["lesson"]),
                score: ScheduleUtils.formatAddress(
                    item["classList"][index]["classAddress"]),
              );
            },
            childCount: item["classList"].length,
          ),
        ),
      );
    }

    return widgets;
  }

  /// 获取SliverAppBar
  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 160.h,
        horizon: 170.h,
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: 35.w,
              horizon: 18.w,
            ),
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 130.w,
              horizon: 60.w,
            ),
          ),
          child: Text(
            S.of(context).functionTeacherTitle,
            style: TextStyle(
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 38.sp,
                horizon: 20.sp,
              ),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取搜索条
  Widget _getSliverSearchBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 110.h,
        horizon: 130.h,
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Align(
        alignment: Alignment.topRight,
        child: Consumer<FunctionTeacherViewModel>(
            builder: (context, model, child) {
          return AnimatedBuilder(
            animation: model.scrollController,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: max(
                  MediaQuery.sizeOf(context).width -
                      model.scrollController.offset.roundToDouble(),
                  MediaQuery.sizeOf(context).width -
                      ScreenAdaptor().byOrientationReturn(
                        vertical: 180.w,
                        horizon: 90.w,
                      )!,
                ),
                child: SearchBar(
                  controller: model.teacherNameController,
                  leading: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenAdaptor().getLengthByOrientation(
                        vertical: 13.w,
                        horizon: 8.w,
                      ),
                      right: ScreenAdaptor().getLengthByOrientation(
                        vertical: 5.w,
                        horizon: 2.w,
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                  hintText: S.of(context).functionTeacherSearchHint,
                  onSubmitted: (value) {
                    if (value.isEmpty) {
                      return;
                    }
                    model.getTeacherCourse(value);
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
