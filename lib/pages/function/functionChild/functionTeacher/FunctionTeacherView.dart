import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/pages/function/functionChild/functionTeacher/FunctionTeacherViewModel.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';

class FunctionTeacherView extends StatelessWidget {
  const FunctionTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (_context) {
        final model = FunctionTeacherViewModel();
        model.getTeacherCourse('肖');
        return model;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Consumer<FunctionTeacherViewModel>(
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
                slivers: <Widget>[],
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
        vertical: 95.h,
        horizon: 100.h,
      ),
      pinned: true,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: EdgeInsets.only(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 16.h,
              horizon: 32.h,
            ),
          ),
          child: Text(
            S.of(context).functionTeacherTitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 38.sp,
                horizon: 20.sp,
              ),
            ),
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  /// 获取搜索条
  Widget _getSliverSearchBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 110.h,
        horizon: 115.h,
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
                      model.scrollController.offset.roundToDouble() -
                      30.w,
                  MediaQuery.sizeOf(context).width - 340.w,
                ),
                child: SearchBar(
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
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
