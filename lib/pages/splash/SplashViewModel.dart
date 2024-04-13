import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../api/schedule/UserApi.dart';
import '../../api/schedule/impl/UserApiImpl.dart';
import '../../main.dart';

class SplashViewModel with ChangeNotifier {
  // 动画控制器
  late AnimationController animationController;

  final UserApi _userApi = UserApiImpl();

  /// 初始化动画控制器
  void initAnimationController(TickerProvider vsync, BuildContext context) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // logger.i("success");
        navigateToSchedule(context);
      }
    });
    animationController.forward();
  }

  /// 跳转主页面
  /// [context] 上下文
  /// [milliseconds] 延迟时间
  void navigateToSchedule(BuildContext context) {
      GoRouter.of(context).replace(GoRouteConfig.appMain);
  }

  /// 登录
  void login() {
    _userApi.autoLoginEducationalSystem(
        userAccount: globalModel.userInfoData["username"],
        userPassword: globalModel.userInfoData["password"]);
  }
}
