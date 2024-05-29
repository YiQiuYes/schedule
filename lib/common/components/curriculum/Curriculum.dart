import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/common/components/curriculum/CurriculumModel.dart';

import '../../../common/utils/ScheduleUtils.dart';
import '../../../generated/l10n.dart';

class Curriculum extends StatelessWidget {
  const Curriculum(
      {super.key,
      this.showWeek = 0,
      this.courseData = const [],
      this.experimentData = const []});

  // 显示周次
  final int showWeek;
  // 个人课表数据
  final List<dynamic> courseData;
  // 个人实验课数据
  final List<dynamic> experimentData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurriculumModel(),
      child: SliverList.list(
        children: [
          // 日期周次
          _getDateWeek(showWeek, context),
          // 节次和课程列表
          _getTimeAndCourseList(showWeek),
        ],
      ),
    );
  }

  /// 获取日期周次列表
  Widget _getDateWeek(int showWeek, BuildContext context) {
    final screen = ScreenAdaptor();
    final List<String> weeks = S.of(context).scheduleViewWeekName.split("&");

    return Padding(
      padding: EdgeInsets.only(
        top: screen.getLengthByOrientation(
          vertical: 27.w,
          horizon: 17.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
        left: screen.getLengthByOrientation(
          vertical: 8.w,
          horizon: 15.w,
        ),
      ),
      child: GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 46,
          mainAxisSpacing: screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          crossAxisSpacing: screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          pattern: [
            const QuiltedGridTile(5, 4),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
            const QuiltedGridTile(5, 6),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0) {
              return const SizedBox();
            } else {
              return Consumer<CurriculumModel>(
                  builder: (context, model, child) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      screen.getLengthByOrientation(
                          vertical: 17.w, horizon: 10.w),
                    ),
                    color: model.getTodayWeekColor(showWeek, index, context),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 星期几
                      Text(
                        weeks[index - 1],
                        style: TextStyle(
                          fontSize: screen.getLengthByOrientation(
                            vertical: 22.sp,
                            horizon: 18.sp,
                          ),
                          height: 0,
                        ),
                      ),
                      // 间距
                      SizedBox(
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 2.w,
                          horizon: 3.w,
                        ),
                      ),
                      // 日期
                      Text(
                        ScheduleUtils.getWeekDate(index - 1, showWeek + 1),
                        style: TextStyle(
                          fontSize: screen.getLengthByOrientation(
                            vertical: 15.sp,
                            horizon: 11.sp,
                          ),
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                );
              });
            }
          },
          childCount: 8,
        ),
      ),
    );
  }

  /// 获取节次和课程列表
  Widget _getTimeAndCourseList(int showWeek) {
    final screen = ScreenAdaptor();

    return Padding(
      padding: EdgeInsets.only(
        top: screen.getLengthByOrientation(
          vertical: 30.w,
          horizon: 18.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 25.w,
          horizon: 15.w,
        ),
        left: screen.getLengthByOrientation(
          vertical: 8.w,
          horizon: 15.w,
        ),
      ),
      child: GridView.custom(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverQuiltedGridDelegate(
          crossAxisCount: 23,
          mainAxisSpacing: screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          crossAxisSpacing: screen.getLengthByOrientation(
            vertical: 11.w,
            horizon: 8.6.w,
          ),
          pattern: [
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 2),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
            QuiltedGridTile(
                screen.byOrientationReturn(vertical: 6, horizon: 3)!, 3),
          ],
        ),
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index % 8 == 0) {
              return _getTimeList(showWeek, index ~/ 8, context);
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
  Widget _getTimeList(int showWeek, int index, BuildContext context) {
    final List<String> time =
        S.of(context).scheduleViewCourseTimeName.split("&");
    final screen = ScreenAdaptor();

    return Align(
      child: Consumer<CurriculumModel>(builder: (context, model, child) {
        return Container(
          width: screen.getLengthByOrientation(
            vertical: 45.w,
            horizon: 37.w,
          ),
          height: screen.getLengthByOrientation(
            vertical: 70.w,
            horizon: 49.w,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              screen.getLengthByOrientation(vertical: 17.w, horizon: 10.w),
            ),
            color: model.getSectionColor(showWeek, index, context),
          ),
          child: Text(
            time[index],
            style: TextStyle(
              fontSize: screen.getLengthByOrientation(
                vertical: 25.sp,
                horizon: 18.sp,
              ),
              height: 0,
            ),
          ),
        );
      }),
    );
  }

  /// 获取课程列表
  Widget _getCourseList(int showWeek, int index) {
    final screen = ScreenAdaptor();

    return Consumer<CurriculumModel>(
        builder: (context, curriculumModel, child) {
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
          curriculumModel.showCourseDetail(
              context, courseData[index], experiment);
        },
        borderRadius: BorderRadius.circular(
          screen.getLengthByOrientation(
            vertical: 15.w,
            horizon: 10.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            screen.getLengthByOrientation(
              vertical: 15.w,
              horizon: 10.w,
            ),
          ),
          child: Stack(
            children: [
              // 课程容器
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.symmetric(
                  vertical: screen.getLengthByOrientation(
                    vertical: 9.w,
                    horizon: 6.w,
                  ),
                  horizontal: screen.getLengthByOrientation(
                    vertical: 9.w,
                    horizon: 7.w,
                  ),
                ),
                decoration: BoxDecoration(
                  color: curriculumModel.getTodayCourseColor(
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
                      maxLines:
                          screen.byOrientationReturn(vertical: 4, horizon: 3)!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screen.getLengthByOrientation(
                          vertical: 18.sp,
                          horizon: 11.sp,
                        ),
                        height: 1.2,
                      ),
                    ),
                    // 课程地点
                    Text(
                      ScheduleUtils.getCourseAddress(
                        course,
                        experiment,
                      ),
                      maxLines:
                          screen.byOrientationReturn(vertical: 3, horizon: 2)!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: screen.getLengthByOrientation(
                          vertical: 15.sp,
                          horizon: 9.sp,
                        ),
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
                  right: screen.getLengthByOrientation(
                    vertical: -13.w,
                    horizon: -4.w,
                  ),
                  bottom: screen.getLengthByOrientation(
                    vertical: -13.w,
                    horizon: -4.w,
                  ),
                  child: Container(
                    height: screen.getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 15.w,
                    ),
                    width: screen.getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 15.w,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(
                        screen.getLengthByOrientation(
                          vertical: 15.w,
                          horizon: 7.5.w,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
