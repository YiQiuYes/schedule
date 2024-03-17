import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class SplashViewModel with ChangeNotifier {

  /// 跳转主页面
  /// [context] 上下文
  /// [milliseconds] 延迟时间
  void navigateToSchedule(BuildContext context, int milliseconds) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      GoRouter.of(context).replace(GoRouteConfig.appMain);
    });
  }
}
