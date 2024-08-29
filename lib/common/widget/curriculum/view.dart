import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../generated/l10n.dart';
import '../../utils/schedule_utils.dart';
import 'logic.dart';

class CurriculumComponent extends StatelessWidget {
  CurriculumComponent(
      {super.key,
      this.showWeek = 0,
      this.courseData = const [],
      this.experimentData = const [],
      this.heightRatio,
      this.crossAxisSpacing,
      this.mainAxisSpacing,
      this.classAddressFontSize,
      this.classNameFontSize,
      this.dateFontSize,
      this.weekFontSize,
      this.horizontalPadding,
      this.verticalPadding,
      this.classNameLinesLimit});

  // 显示周次
  final int showWeek;
  // 个人课表数据
  final List<dynamic> courseData;
  // 个人实验课数据
  final List<dynamic> experimentData;
  // 高度比例
  final int? heightRatio;
  // 主轴间距
  final double? mainAxisSpacing;
  // 交叉轴间距
  final double? crossAxisSpacing;
  // 课程名称字体大小
  final double? classNameFontSize;
  // 课程地点字体大小
  final double? classAddressFontSize;
  // 星期字体大小
  final double? weekFontSize;
  // 日期字体大小
  final double? dateFontSize;
  // 垂直内边距
  final double? verticalPadding;
  // 水平内边距
  final double? horizontalPadding;
  // 课程名称行数限制
  final int? classNameLinesLimit;

  final logic = Get.put(CurriculumLogic());
  final state = Get.find<CurriculumLogic>().state;

  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        // 日期周次
        _getDateWeek(showWeek, context),
        // 节次和课程列表
        _getTimeAndCourseList(showWeek),
      ],
    );
  }

  /// 获取日期周次列表
  Widget _getDateWeek(int showWeek, BuildContext context) {
    final List<String> weeks = S.of(context).schedule_week_tile.split("&");

    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 15.w, horizon: 7.w),
        right: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
        left: ScreenUtils.length(vertical: 8.w, horizon: 15.w),
      ),
      child: GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 46,
          mainAxisSpacing: mainAxisSpacing ??
              ScreenUtils.length(vertical: 11.w, horizon: 5.6.w),
          crossAxisSpacing: crossAxisSpacing ??
              ScreenUtils.length(vertical: 11.w, horizon: 5.6.w),
          pattern: [
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                4),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 5, horizon: 4)!,
                6),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const SizedBox();
            } else {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ScreenUtils.length(vertical: 17.w, horizon: 10.w),
                  ),
                  color: logic.getTodayWeekColor(showWeek, index, context),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 星期几
                    Text(
                      weeks[index - 1],
                      style: TextStyle(
                        fontSize: weekFontSize ??
                            ScreenUtils.length(vertical: 22.sp, horizon: 10.sp),
                        height: 0,
                      ),
                    ),
                    // 间距
                    SizedBox(
                      height: ScreenUtils.length(vertical: 2.w, horizon: 3.w),
                    ),
                    // 日期
                    Text(
                      ScheduleUtils.getWeekDate(index - 1, showWeek + 1),
                      style: TextStyle(
                        fontSize: dateFontSize ??
                            ScreenUtils.length(vertical: 17.sp, horizon: 7.sp),
                        height: 0,
                      ),
                    ),
                  ],
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
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 15.w, horizon: 7.w),
        right: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
        left: ScreenUtils.length(vertical: 8.w, horizon: 15.w),
      ),
      child: GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 46,
          mainAxisSpacing: mainAxisSpacing ??
              ScreenUtils.length(vertical: 11.w, horizon: 5.6.w),
          crossAxisSpacing: crossAxisSpacing ??
              ScreenUtils.length(vertical: 11.w, horizon: 5.6.w),
          pattern: [
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                4),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
            QuiltedGridTile(
                heightRatio ??
                    ScreenUtils.byOrientationReturn(vertical: 11, horizon: 6)!,
                6),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index % 8 == 0) {
              return _getTimeList(showWeek, index ~/ 8, context);
            } else {
              return _getCourseList(
                  context, showWeek, index ~/ 8 * 7 + index % 8 - 1);
            }
          },
          childCount: 40,
        ),
      ),
    );
  }

  /// 获取节次列表
  Widget _getTimeList(int showWeek, int index, BuildContext context) {
    final List<String> time =
        S.of(context).schedule_course_time_tile.split("&");

    return Align(
      child: Container(
        width: ScreenUtils.length(vertical: 45.w, horizon: 37.w),
        height: ScreenUtils.length(vertical: 70.w, horizon: 49.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenUtils.length(vertical: 17.w, horizon: 10.w),
          ),
          color: logic.getSectionColor(showWeek, index, context),
        ),
        child: Text(
          time[index],
          style: TextStyle(
            fontSize: weekFontSize ??
                ScreenUtils.length(vertical: 25.sp, horizon: 10.sp),
            height: 0,
          ),
        ),
      ),
    );
  }

  /// 获取课程列表
  Widget _getCourseList(BuildContext context, int showWeek, int index) {
    // 判断是否有课程数据
    if ((courseData.isEmpty || courseData[index].isEmpty) &&
        (experimentData.isEmpty || experimentData[index].isEmpty)) {
      return const SizedBox();
    }

    late Map course;
    late Map experiment;

    if (courseData.isNotEmpty && courseData.length > index) {
      course = (courseData[index] is List)
          ? courseData[index][0]
          : courseData[index];
    } else {
      course = {};
    }

    if (experimentData.isNotEmpty && experimentData.length > index) {
      experiment = experimentData[index];
    } else {
      experiment = {};
    }

    return InkWell(
      onTap: () {
        // 显示课程详细
        logic.showCourseDetail(context, courseData[index], experiment);
      },
      borderRadius: BorderRadius.circular(
        ScreenUtils.length(vertical: 15.w, horizon: 10.w),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ScreenUtils.length(vertical: 15.w, horizon: 10.w),
        ),
        child: Stack(
          children: [
            // 课程容器
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? ScreenUtils.length(vertical: 9.w, horizon: 6.w),
                horizontal: horizontalPadding ?? ScreenUtils.length(vertical: 9.w, horizon: 7.w),
              ),
              decoration: BoxDecoration(
                color: logic.getTodayCourseColor(
                    showWeek, index, context, courseData, experimentData),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // 课程名称
                  Text(
                    ScheduleUtils.getCourseName(
                      course,
                      experiment,
                    ),
                    maxLines: classNameLinesLimit ?? ScreenUtils.byOrientationReturn(
                        vertical: 4, horizon: 3)!,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: classNameFontSize ??
                          ScreenUtils.length(vertical: 18.sp, horizon: 9.sp),
                      height: 1.2,
                    ),
                  ),
                  // 课程地点
                  Text(
                    ScheduleUtils.getCourseAddress(course, experiment),
                    maxLines: ScreenUtils.byOrientationReturn(
                        vertical: 3, horizon: 2)!,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: classAddressFontSize ??
                          ScreenUtils.length(vertical: 16.sp, horizon: 7.sp),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            // 冲突课程高亮
            Visibility(
              visible: (course.isNotEmpty && experiment.isNotEmpty) ||
                  courseData[index] is List,
              child: Positioned(
                right: ScreenUtils.length(vertical: -13.w, horizon: -4.w),
                bottom: ScreenUtils.length(vertical: -13.w, horizon: -4.w),
                child: Container(
                  height: ScreenUtils.length(vertical: 30.w, horizon: 15.w),
                  width: ScreenUtils.length(vertical: 30.w, horizon: 15.w),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(
                      ScreenUtils.length(vertical: 15.w, horizon: 7.5.w),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
