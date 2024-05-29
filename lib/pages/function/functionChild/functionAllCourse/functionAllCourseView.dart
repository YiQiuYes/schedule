import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/components/curriculum/Curriculum.dart';
import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';
import 'functionAllCourseViewModel.dart';

class FunctionAllCourseView extends StatelessWidget {
  const FunctionAllCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final model = FunctionAllCourseViewModel();
        model.init();
        return model;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // 主体
              _getMainBody(),
              // 课表加载中
              _getLoading(),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取主体Widget
  Widget _getMainBody() {
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder:
          (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // SliverAppBar
          _getSliverAppBar(context),
        ];
      },
      body: Consumer<FunctionAllCourseViewModel>(
        builder: (context, model, child) {
          return Visibility(
            visible: !model.isLoad,
            child: CustomScrollView(
              slivers: [
                // 课表
                _getCurriculum(),
                // 底部间隔
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 130.w,
                      horizon: 25.w,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  /// 获取课表加载中
  Widget _getLoading() {
    return Consumer<FunctionAllCourseViewModel>(
      builder: (context, model, child) {
        return Visibility(
          visible: model.isLoad,
          child: Center(
            child: Text(
              S.of(context).functionAllCourseViewLoading,
              style: TextStyle(
                fontSize: ScreenAdaptor().getLengthByOrientation(
                  vertical: 55.sp,
                  horizon: 35.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 获取课表组件
  Widget _getCurriculum() {
    return Consumer<FunctionAllCourseViewModel>(
        builder: (context, model, child) {
      return Curriculum(
        showWeek: int.parse(model.week) - 1,
        courseData: model.courseData,
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
          S.of(context).functionViewAllCourseTitle,
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
        Consumer<FunctionAllCourseViewModel>(builder: (context, model, child) {
          return IconButton(
            icon: Icon(
              Icons.select_all_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              model.isLoad == false ? _showSemesterList(context, model) : null;
            },
          );
        }),
        Consumer<FunctionAllCourseViewModel>(builder: (context, model, child) {
          return IconButton(
            icon: Icon(
              Icons.access_time_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: () {
              model.isLoad == false ? _showWeeksList(context, model) : null;
            },
          );
        }),
      ],
    );
  }

  /// 弹出选择班级课表
  void _showSemesterList(
      BuildContext context, FunctionAllCourseViewModel model) {
    PickerDataAdapter<dynamic> adapter = model.getClassPickerData();
    final screen = ScreenAdaptor();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: model.collegeAndMajorIndex,
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
          vertical: 20.w,
          horizon: 20.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 20.w,
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
        vertical: 60.w,
        horizon: 40.w,
      ),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.w),
        ),
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
      onConfirm: model.selectCollegeAndMajorConfirm,
    );
    picker.showModal(context);
  }

  /// 弹出周次选择器
  void _showWeeksList(BuildContext context, FunctionAllCourseViewModel model) {
    PickerDataAdapter<dynamic> adapter = model.getWeekPickerData(context);
    final screen = ScreenAdaptor();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [int.parse(model.week) - 1],
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
          vertical: 20.w,
          horizon: 20.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 20.w,
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
        vertical: 60.w,
        horizon: 40.w,
      ),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25.w),
        ),
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
      onConfirm: model.selectWeekConfirm,
    );
    picker.showModal(context);
  }
}
