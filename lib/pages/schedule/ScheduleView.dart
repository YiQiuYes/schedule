import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/common/components/curriculum/Curriculum.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/schedule/ScheduleViewModel.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final scheduleViewModel = ScheduleViewModel();
  final _screen = ScreenAdaptor();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    scheduleViewModel.init();
    scheduleViewModel.initTabController(this);
  }

  @override
  void dispose() {
    scheduleViewModel.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider.value(
      value: scheduleViewModel,
      child: _getTabBarView(),
    );
  }

  /// 获取1~20个TabBarView页面
  Widget _getTabBarView() {
    // 构建1~20个页面
    List<Widget> tabBarViewList = [];
    for (int i = 0; i < 20; i++) {
      tabBarViewList.add(CustomScrollView(
        slivers: [
          // 第几周次标题
          _getWeekTitle(i),
          // 日期标题
          _getDateTitle(i),
          // 课程表组件
          _getCurriculum(i),
          // 底部间隔
          _getHeightSpace(),
        ],
      ));
    }
    return TabBarView(
      controller: scheduleViewModel.tabController,
      children: tabBarViewList,
    );
  }

  /// 获取课表组件
  Widget _getCurriculum(int showWeek) {
    return Consumer<GlobalModel>(
      builder: (context, model, child) {
        return Curriculum(
          showWeek: showWeek,
          courseData: globalModel.courseData[showWeek],
          experimentData: globalModel.experimentData[showWeek],
        );
      }
    );
  }

  /// 间距
  Widget _getHeightSpace() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: _screen.getLengthByOrientation(
          vertical: 20.w,
          horizon: 15.w,
        ),
      ),
    );
  }

  /// 获取周次标题
  Widget _getWeekTitle(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 20.w,
          horizon: 4.w,
        ),
        left: _screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            borderRadius: BorderRadius.circular(
              _screen.getLengthByOrientation(
                vertical: 15.w,
                horizon: 10.w,
              ),
            ),
            onTap: () {
              // 点击周次标题
              scheduleViewModel.weekTitleTap(showWeek, context);
            },
            child: Text(
              scheduleViewModel.getTabPageWeek(
                  S.of(context).scheduleViewCurrentWeek, showWeek),
              style: TextStyle(
                fontSize: _screen.getLengthByOrientation(
                  vertical: 50.sp,
                  horizon: 23.sp,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取日期标题
  Widget _getDateTitle(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: _screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
        top: _screen.getLengthByOrientation(
          vertical: 5.w,
          horizon: 2.w,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          scheduleViewModel.getTabPageTodayDate(
              showWeek, S.of(context).scheduleViewYearAndMonth),
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 30.sp,
              horizon: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}
