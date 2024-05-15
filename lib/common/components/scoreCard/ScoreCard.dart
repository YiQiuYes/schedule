import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/ScreenAdaptor.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, this.subjectName, this.subTitle, this.score});

  // 项目名称
  final String? subjectName;

  // 项目副标题说明紧跟在项目名称下面
  final String? subTitle;

  // 项目成绩
  final String? score;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenAdaptor().getLengthByOrientation(
          vertical: 30.w,
          horizon: 15.w,
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
            horizon: 25.w,
          ),
          vertical: ScreenAdaptor().getLengthByOrientation(
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
                  width: ScreenAdaptor().getLengthByOrientation(
                    vertical: 400.w,
                    horizon: 400.w,
                  ),
                  child: Text(
                    subjectName ?? '',
                    style: TextStyle(
                      fontSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 35.sp,
                        horizon: 24.sp,
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
                Visibility(
                  visible: subTitle != null,
                  child: SizedBox(
                    width: ScreenAdaptor().getLengthByOrientation(
                      vertical: 400.w,
                      horizon: 400.w,
                    ),
                    child: Text(
                      subTitle!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: ScreenAdaptor().getLengthByOrientation(
                          vertical: 30.sp,
                          horizon: 24.sp,
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
                  width: ScreenAdaptor().getLengthByOrientation(
                    vertical: 140.w,
                    horizon: 170.w,
                  ),
                  child: Text(
                    score ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: ScreenAdaptor().getLengthByOrientation(
                        vertical: 35.sp,
                        horizon: 28.sp,
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
