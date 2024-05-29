import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/components/scoreCard/ScoreCard.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';
import 'FunctionScoreViewModel.dart';

class FunctionScoreView extends StatelessWidget {
  const FunctionScoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FunctionScoreViewModel(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                // 获取SliverList
                _getSliverList(),
                // 暂无成绩
                _getEmptyScore(),
                // 间距
                _getHeightSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 暂无成绩
  Widget _getEmptyScore() {
    return Consumer<FunctionScoreViewModel>(builder: (context, model, child) {
      if (model.personScoreList.isEmpty && !model.isLoading) {
        return SliverPadding(
          padding: EdgeInsets.only(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 350.w,
              horizon: 120.w,
            ),
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                S.of(context).functionScoreViewEmpty,
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
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
    });
  }

  /// 间距
  Widget _getHeightSpace() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 100.w,
          horizon: 50.w,
        ),
      ),
    );
  }

  /// 获取SliverList
  Widget _getSliverList() {
    return Consumer<FunctionScoreViewModel>(builder: (context, model, child) {
      return SliverList.builder(
        itemCount: model.personScoreList.length,
        itemBuilder: (context, index) {
          return ScoreCard(
            subjectName: model.personScoreList[index]['className'],
            subTitle: S.of(context).functionScoreViewGPA(
                model.personScoreList[index]['classGPA']),
            score: model.personScoreList[index]['classScore'],
          );
        },
      );
    });
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
        title: Text(
          S.of(context).functionViewScoreTitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 38.sp,
              horizon: 20.sp,
            ),
          ),
        ),
        centerTitle: false,
      ),
      actions: [
        Consumer<FunctionScoreViewModel>(builder: (context, model, child) {
          return IconButton(
            icon: Icon(
              Icons.select_all_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              _showSemesterList(context, model);
            },
          );
        }),
      ],
    );
  }

  /// 学期弹出选择列表
  void _showSemesterList(BuildContext context, FunctionScoreViewModel model) {
    PickerDataAdapter<String> adapter = model.getSemesterPickerData();
    final screen = ScreenAdaptor();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [model.currentSemesterIndex],
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
        left: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: screen.getLengthByOrientation(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: screen.getLengthByOrientation(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: screen.getLengthByOrientation(
        vertical: 500.w,
        horizon: 150.w,
      ),
      itemExtent: screen.getLengthByOrientation(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: screen.getLengthByOrientation(
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
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: screen.getLengthByOrientation(
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
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      onConfirm: model.selectSemesterConfirm,
    );
    picker.showModal(context);
  }
}
