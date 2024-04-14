import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';
import 'LearnThroughViewModel.dart';

class LearnThroughView extends StatelessWidget {
  const LearnThroughView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_context) {
        final model = LearnThroughViewModel();
        Future.delayed(const Duration(milliseconds: 500), () {
          model.init(context);
        });
        return model;
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: <Widget>[
                // 获取签到按钮
                _getSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 获取签到按钮
  Widget _getSignInButton(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 190.h,
          horizon: 50.h,
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Align(
          child: Consumer<LearnThroughViewModel>(
            builder: (context, model, child) {
              return ElevatedButton(
                onPressed: () {
                  model.signIn(context);
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(13),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1000),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(
                    Size(
                      ScreenAdaptor().getLengthByOrientation(
                        vertical: 300.w,
                        horizon: 150.w,
                      ),
                      ScreenAdaptor().getLengthByOrientation(
                        vertical: 300.w,
                        horizon: 150.w,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  S.of(context).functionViewLearnThroughSignIn,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: ScreenAdaptor().getLengthByOrientation(
                      vertical: 55.sp,
                      horizon: 28.sp,
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
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
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          S.of(context).functionViewLearnThroughTitle,
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
