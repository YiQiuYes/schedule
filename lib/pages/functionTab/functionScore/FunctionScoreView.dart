import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../common/utils/ScreenAdaptor.dart';
import '../../../generated/l10n.dart';
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
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                // 获取SliverList
                _getSliverList(),
                // 间距
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 100.w,
                      horizon: 10.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          return Card(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 10.w,
              ),
              vertical: ScreenAdaptor().getLengthByOrientation(
                vertical: 10.w,
                horizon: 5.w,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenAdaptor().getLengthByOrientation(
                  vertical: 50.w,
                  horizon: 10.w,
                ),
                vertical: ScreenAdaptor().getLengthByOrientation(
                  vertical: 30.w,
                  horizon: 5.w,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 课程名称
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 400.w,
                          horizon: 200.w,
                        ),
                        child: Text(
                          model.personScoreList[index]['className'],
                          style: TextStyle(
                            fontSize: ScreenAdaptor().getLengthByOrientation(
                              vertical: 35.sp,
                              horizon: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      // 间距
                      SizedBox(
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 15.w,
                          horizon: 5.w,
                        ),
                      ),
                      // 绩点
                      Text(
                        S.of(context).functionScoreViewGPA(
                            model.personScoreList[index]['classGPA']),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: ScreenAdaptor().getLengthByOrientation(
                            vertical: 35.sp,
                            horizon: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 课程成绩
                      Text(
                        model.personScoreList[index]['classScore'],
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: ScreenAdaptor().getLengthByOrientation(
                            vertical: 40.sp,
                            horizon: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      pinned: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          S.of(context).functionScoreViewAppBarTitle,
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
              Icons.more_vert_rounded,
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
      selecteds: [0],
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
