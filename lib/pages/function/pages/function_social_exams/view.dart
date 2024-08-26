import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/widget/score_card/view.dart';

import '../../../../common/utils/screen_utils.dart';
import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionSocialExamsPage extends StatelessWidget {
  FunctionSocialExamsPage({super.key});

  final logic = Get.put(FunctionSocialExamsLogic());
  final state = Get.find<FunctionSocialExamsLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.function_social_exams),
      ),
      body: CustomScrollView(
        slivers: [
          // 获取SliverList
          sliverList(),
          // 暂无成绩
          emptyScore(),
        ],
      ),
    );
  }

  /// 暂无成绩
  Widget emptyScore() {
    return GetBuilder<FunctionSocialExamsLogic>(builder: (logic) {
      if (logic.state.personScoreList.isEmpty && !logic.state.isLoading.value) {
        return SliverPadding(
          padding: EdgeInsets.only(
            top: ScreenUtils.length(
              vertical: 350.w,
              horizon: 120.w,
            ),
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                S.current.function_score_empty,
                style: TextStyle(
                  fontSize: ScreenUtils.length(
                    vertical: 40.sp,
                    horizon: 30.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return const SliverToBoxAdapter(child: SizedBox());
    });
  }

  /// 获取SliverList
  Widget sliverList() {
    return GetBuilder<FunctionSocialExamsLogic>(builder: (logic) {
      return SliverList.builder(
        itemCount: logic.state.personScoreList.length,
        itemBuilder: (context, index) {
          return ScoreCardComponent(
            subjectName: logic.state.personScoreList[index]['examName'],
            subTitle: S.current.function_social_exams_time(
                logic.state.personScoreList[index]['examTime']),
            score: logic.state.personScoreList[index]['examScore'],
          );
        },
      );
    });
  }
}
