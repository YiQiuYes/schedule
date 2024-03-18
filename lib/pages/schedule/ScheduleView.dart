import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
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
    scheduleViewModel.initTabController(this);
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
          // 日期周次
          _getDateWeek(i),
          // 节次和课程
          _getTimeAndCourseList(i),
          // 底部间隔
          SliverToBoxAdapter(
            child: SizedBox(
              height: _screen.getLengthByOrientation(
                vertical: 20.w,
                horizon: 15.w,
              ),
            ),
          ),
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
              horizon: 19.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取日期周次列表
  Widget _getDateWeek(int showWeek) {
    List<String> weeks = S.of(context).scheduleViewWeekName.split("&");

    return SliverPadding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 27.w,
          horizon: 17.w,
        ),
        right: _screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
      ),
      sliver: SliverGrid(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 23,
          mainAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          crossAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          pattern: [
            const QuiltedGridTile(2, 2),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
            const QuiltedGridTile(2, 3),
          ],
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const SizedBox();
            } else {
              return ClipRRect(
                borderRadius: BorderRadius.circular(
                  _screen.getLengthByOrientation(vertical: 17.w, horizon: 10.w),
                ),
                child: Container(
                  color: scheduleViewModel.getTodayWeekColor(
                      showWeek, index, context),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: _screen.getLengthByOrientation(
                      vertical: 10.w,
                      horizon: 8.w,
                    ),
                  ),
                  child: Text(
                    weeks[index - 1],
                    style: TextStyle(
                      fontSize: _screen.getLengthByOrientation(
                        vertical: 25.sp,
                        horizon: 19.sp,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          childCount: 8,
        ),
      ),
    );
  }

  /// 获取节次和课程列表
  Widget _getTimeAndCourseList(int showWeek) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 30.w,
          horizon: 18.w,
        ),
        right: _screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
      ),
      sliver: SliverGrid(
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 23,
          mainAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          crossAxisSpacing: _screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          pattern: [
            const QuiltedGridTile(6, 2),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
            const QuiltedGridTile(6, 3),
          ],
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index % 8 == 0) {
              return _getTimeList(index ~/ 8);
            } else {
              return _getCourseList(showWeek, index ~/ 8 * 7 + index % 8 - 1);
            }
          },
          childCount: 40,
        ),
      ),
    );
  }

  /// 获取节次列表
  Widget _getTimeList(int index) {
    final List<String> time =
        S.of(context).scheduleViewCourseTimeName.split("&");

    return Container(
      alignment: Alignment.center,
      child: Text(
        time[index],
        style: TextStyle(
          fontSize: _screen.getLengthByOrientation(
            vertical: 25.sp,
            horizon: 19.sp,
          ),
          height: 0,
        ),
      ),
    );
  }

  /// 获取课程列表
  Widget _getCourseList(int showWeek, int index) {
    return Consumer2<GlobalModel, ScheduleViewModel>(
        builder: (context, globalModel, scheduleModel, child) {
      // 判断是否有课程数据
      if (globalModel.courseData[showWeek].isEmpty ||
          globalModel.courseData[showWeek][index].isEmpty) {
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
          alignment: Alignment.topCenter,
          color: scheduleViewModel.getTodayCourseColor(
              showWeek, index % 7 + 1, context),
          padding: EdgeInsets.symmetric(
            vertical: _screen.getLengthByOrientation(
              vertical: 12.w,
              horizon: 12.w,
            ),
            horizontal: _screen.getLengthByOrientation(
              vertical: 11.w,
              horizon: 13.w,
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
                    horizon: 15.sp,
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
                    vertical: 15.sp,
                    horizon: 13.sp,
                  ),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
