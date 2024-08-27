import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/screen_utils.dart';
import 'logic.dart';

class ScoreCardComponent extends StatelessWidget {
  ScoreCardComponent({super.key, this.subjectName, this.subTitle, this.score});

  // 项目名称
  final String? subjectName;

  // 项目副标题说明紧跟在项目名称下面
  final String? subTitle;

  // 项目成绩
  final String? score;

  final logic = Get.put(ScoreCardLogic());
  final state = Get.find<ScoreCardLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.primary,
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtils.length(
          vertical: 30.w,
          horizon: 15.w,
        ),
        vertical: ScreenUtils.length(
          vertical: 10.w,
          horizon: 5.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.length(
            vertical: 50.w,
            horizon: 25.w,
          ),
          vertical: ScreenUtils.length(
            vertical: 30.w,
            horizon: 18.w,
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
                  width: ScreenUtils.length(
                    vertical: 400.w,
                    horizon: 90.w,
                  ),
                  child: Text(
                    subjectName ?? '',
                    style: TextStyle(
                      fontSize: ScreenUtils.length(
                        vertical: 30.sp,
                        horizon: 11.sp,
                      ),
                    ),
                  ),
                ),
                // 间距
                SizedBox(
                  height: ScreenUtils.length(
                    vertical: 15.w,
                    horizon: 5.w,
                  ),
                ),
                // 绩点
                Visibility(
                  visible: subTitle != null,
                  child: SizedBox(
                    width: ScreenUtils.length(
                      vertical: 400.w,
                      horizon: 90.w,
                    ),
                    child: Text(
                      subTitle!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: ScreenUtils.length(
                          vertical: 25.sp,
                          horizon: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 课程成绩
                SizedBox(
                  width: ScreenUtils.length(
                    vertical: 140.w,
                    horizon: 40.w,
                  ),
                  child: Text(
                    score ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: ScreenUtils.length(
                        vertical: 30.sp,
                        horizon: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
