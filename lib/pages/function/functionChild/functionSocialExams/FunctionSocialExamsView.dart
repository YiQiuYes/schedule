import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/components/scoreCard/ScoreCard.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';
import 'FunctionSocialExamsViewModel.dart';

class FunctionSocialExamsView extends StatelessWidget {
  const FunctionSocialExamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FunctionSocialExamsViewModel(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                // 获取SliverList
                _getSliverList(),
                // 暂无成绩
                _getEmptyScore(),
                // 间距
                _getHeightSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 暂无成绩
  Widget _getEmptyScore() {
    return Consumer<FunctionSocialExamsViewModel>(builder: (context, model, child) {
      if (model.personScoreList.isEmpty && !model.isLoading) {
        return SliverPadding(
          padding: EdgeInsets.only(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 350.w,
              horizon: 120.w,
            ),
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Text(
                S.of(context).functionScoreViewEmpty,
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
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

  /// 间距
  Widget _getHeightSpace() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 100.w,
          horizon: 50.w,
        ),
      ),
    );
  }

  /// 获取SliverList
  Widget _getSliverList() {
    return Consumer<FunctionSocialExamsViewModel>(builder: (context, model, child) {
      return SliverList.builder(
        itemCount: model.personScoreList.length,
        itemBuilder: (context, index) {
          return ScoreCard(
            subjectName: model.personScoreList[index]['examName'],
            subTitle: S.of(context).functionSocialExamsViewSub(
                model.personScoreList[index]['examTime']),
            score: model.personScoreList[index]['examScore'],
          );
        },
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
          S.of(context).functionViewSocialExams,
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
    );
  }
}
