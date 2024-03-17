import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/ScheduleUtils.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/schedule/ScheduleViewModel.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView>
    with TickerProviderStateMixin {
  final scheduleViewModel = ScheduleViewModel();
  final _screen = ScreenAdaptor();

  @override
  void initState() {
    super.initState();
    GoRouteConfig.setContext = context;
    scheduleViewModel.init();
    scheduleViewModel.tabController = TabController(
      initialIndex: int.parse(globalModel.semesterWeekData["currentWeek"]) - 1,
      length: 20,
      vsync: this,
    );
  }

  @override
  void dispose() {
    scheduleViewModel.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: scheduleViewModel,
      child: SafeArea(
        // TabBarView
        child: _getTabBarView(),
      ),
    );
  }

  /// 获取1~20个Tabbar页面
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
          // 日期周次
          _getDateWeek(),
          // 节次和课程
          _getTimeAndCourseList(i),
        ],
      ));
    }
    return TabBarView(
      controller: scheduleViewModel.tabController,
      children: tabBarViewList,
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
        child: Text(
          scheduleViewModel.getTabPageWeek(
              S.of(context).scheduleViewCurrentWeek, showWeek),
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 50.sp,
              horizon: 30.sp,
            ),
            fontWeight: FontWeight.bold,
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
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          scheduleViewModel.getTabPageTodayDate(
              showWeek, S.of(context).scheduleViewYearAndMonth),
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 30.sp,
              horizon: 19.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取日期周次
  Widget _getDateWeek() {
    List<String> weeks = S.of(context).scheduleViewWeekName.split("&");

    return SliverPadding(
      padding: EdgeInsets.only(
        left: _screen.getLengthByOrientation(
          vertical: 80.w,
          horizon: 70.w,
        ),
        right: _screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
        top: _screen.getLengthByOrientation(
          vertical: 27.w,
          horizon: 17.w,
        ),
      ),
      sliver: SliverAlignedGrid.count(
        crossAxisCount: 7,
        itemCount: 7,
        crossAxisSpacing: _screen.getLengthByOrientation(
          vertical: 10.w,
          horizon: 8.w,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(
              _screen.getLengthByOrientation(vertical: 17.w, horizon: 10.w),
            ),
            child: Container(
              // color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: _screen.getLengthByOrientation(
                  vertical: 10.w,
                  horizon: 8.w,
                ),
              ),
              child: Text(
                weeks[index],
                style: TextStyle(
                  fontSize: _screen.getLengthByOrientation(
                    vertical: 25.sp,
                    horizon: 19.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 获取节次和课程列表
  Widget _getTimeAndCourseList(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 20.w,
          horizon: 15.w,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 节次
            _getTimeList(),
            // 间距
            SizedBox(
              width: _screen.getLengthByOrientation(
                vertical: 0,
                horizon: 20.w,
              ),
            ),
            // 课程
            _getCourseList(showWeek),
          ],
        ),
      ),
    );
  }

  /// 获取节次列表
  Widget _getTimeList() {
    List<String> time = S.of(context).scheduleViewCourseTimeName.split("&");

    List<Widget> timeWidgetList = [];
    for (int i = 0; i < time.length; i++) {
      timeWidgetList.add(
        Container(
          width: _screen.getLengthByOrientation(
            vertical: 80.w,
            horizon: 50.w,
          ),
          height: _screen.getLengthByOrientation(
            vertical: 160.w,
            horizon: 120.w,
          ),
          alignment: Alignment.center,
          child: Text(
            time[i],
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 25.sp,
                horizon: 19.sp,
              ),
              height: 0,
            ),
          ),
        ),
      );
    }
    return Column(
      children: timeWidgetList,
    );
  }

  /// 获取课程列表
  Widget _getCourseList(int showWeek) {
    return SizedBox(
      height: _screen.getLengthByOrientation(
        vertical: 800.w,
        horizon: 600.w,
      ),
      width: _screen.getLengthByOrientation(
        vertical: 615.w,
        horizon: 545.w,
      ),
      child: Consumer2<GlobalModel, ScheduleViewModel>(
          builder: (context, globalModel, scheduleModel, child) {
        // logger.i(globalModel.courseData[2]);
        return AlignedGridView.count(
          itemCount: globalModel.courseData[showWeek].length,
          crossAxisCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          crossAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          itemBuilder: (context, index) {
            // 判断是否有课程数据
            if (globalModel.courseData[showWeek][index].isEmpty) {
              return const SizedBox();
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(
                _screen.getLengthByOrientation(
                  vertical: 15.w,
                  horizon: 10.w,
                ),
              ),
              child: Container(
                height: _screen.getLengthByOrientation(
                  vertical: 160.w - 11.w,
                  horizon: 120.w - 8.6.w,
                ),
                alignment: Alignment.topCenter,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                padding: EdgeInsets.symmetric(
                  vertical: _screen.getLengthByOrientation(
                    vertical: 8.w,
                    horizon: 6.w,
                  ),
                  horizontal: _screen.getLengthByOrientation(
                    vertical: 11.w,
                    horizon: 12.w,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // 课程名称
                    Text(
                      ScheduleUtils.getCourseName(
                          globalModel.courseData[showWeek][index]),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _screen.getLengthByOrientation(
                          vertical: 18.sp,
                          horizon: 14.sp,
                        ),
                        height: 1.2,
                      ),
                    ),
                    // 课程地点
                    Text(
                      ScheduleUtils.getCourseAddress(
                          globalModel.courseData[showWeek][index]),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _screen.getLengthByOrientation(
                          vertical: 14.sp,
                          horizon: 11.sp,
                        ),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
