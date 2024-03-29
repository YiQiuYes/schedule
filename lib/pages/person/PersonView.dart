import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../common/utils/ScreenAdaptor.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  final _screen = ScreenAdaptor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [];
        },
        body: CustomScrollView(
          slivers: [
            // 获取app图标
            _getAppIcon(),
            // 设置项
            _getSettingItem(context),
          ],
        ),
      ),
    );
  }

  /// 获取app图标
  Widget _getAppIcon() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top: _screen.getLengthByOrientation(
            vertical: 50.w,
            horizon: 30.w,
          ),
          bottom: _screen.getLengthByOrientation(
            vertical: 50.w,
            horizon: 30.w,
          ),
        ),
        child: Center(
          child: Lottie.asset(
            "lib/assets/lotties/person.json",
            width: _screen.getLengthByOrientation(
              vertical: 300.w,
              horizon: 180.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 300.w,
              horizon: 180.w,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取设置项
  Widget _getSettingItem(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListTile(
        onTap: () {
          GoRouter.of(context).push(GoRouteConfig.setting);
        },
        leading: Icon(
          Icons.settings_rounded,
          size: _screen.getLengthByOrientation(
            vertical: 38.w,
            horizon: 22.w,
          ),
        ),
        title: Text(
          S.of(context).settingViewTitle,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 32.sp,
              horizon: 17.sp,
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 35.w,
            horizon: 20.w,
          ),
        ),
      ),
    );
  }
}
