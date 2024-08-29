import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';
import 'package:schedule/common/widget/curriculum/view.dart';

import '../../generated/l10n.dart';
import '../../global_logic.dart';
import 'logic.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final logic = Get.put(ScheduleLogic());
  final state = Get.find<ScheduleLogic>().state;

  @override
  void initState() {
    super.initState();
    // 初始化tabBarController
    logic.initTabController(this);
    logic.init();
  }

  @override
  void dispose() {
    state.tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child: tabBarViewWidget());
  }

  /// 获取1~20个TabBarView页面
  Widget tabBarViewWidget() {
    // 构建1~20个页面
    List<Widget> tabBarViewList = [];
    for (int i = 0; i < 20; i++) {
      tabBarViewList.add(CustomScrollView(
        slivers: [
          // 第几周次标题
          weekTitleWidget(i),
          // 日期标题
          dateTitleWidget(i),
          // 课程表组件
          curriculumWidget(i),
          // 底部间隔
          heightSpaceWidget(),
        ],
      ));
    }
    return Padding(
      padding: EdgeInsets.only(
        right: ScreenUtils.length(vertical: 0, horizon: 70.w),
      ),
      child: TabBarView(
        controller: state.tabController,
        children: tabBarViewList,
      ),
    );
  }

  /// 获取课表组件
  Widget curriculumWidget(int showWeek) {
    return GetBuilder<GlobalLogic>(builder: (logic) {
      return CurriculumComponent(
        showWeek: showWeek,
        courseData: logic.state.courseData[showWeek],
        experimentData: logic.state.experimentData[showWeek],
      );
    });
  }

  /// 获取日期标题
  Widget dateTitleWidget(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 30.w, horizon: 15.w),
        top: ScreenUtils.length(vertical: 5.w, horizon: 0.w),
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          S.of(context).schedule_year_and_month(
              logic.getTabPageTodayYear(showWeek),
              logic.getTabPageTodayMonth(showWeek)),
          style: TextStyle(
            fontSize: ScreenUtils.length(vertical: 30.sp, horizon: 13.sp),
          ),
        ),
      ),
    );
  }

  /// 获取周次标题
  Widget weekTitleWidget(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 20.w, horizon: 0.w),
        left: ScreenUtils.length(vertical: 10.w, horizon: 15.w),
      ),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              ScreenUtils.length(vertical: 15.w, horizon: 10.w),
            ),
            onTap: () {
              // 点击周次标题
              logic.weekTitleTap(showWeek, context);
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
                  vertical: 5.w,
                  horizon: 5.w,
                ),
                bottom: ScreenUtils.length(
                  vertical: 5.w,
                  horizon: 6.w,
                ),
              ),
              child: Text(
                S.of(context).schedule_current_week(showWeek + 1),
                style: TextStyle(
                  fontSize: ScreenUtils.length(vertical: 50.sp, horizon: 20.sp),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 间距
  Widget heightSpaceWidget() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenUtils.length(vertical: 0.w, horizon: 0.w),
      ),
    );
  }
}
