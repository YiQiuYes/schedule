import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/api/QueryApi.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class SplashViewModel with ChangeNotifier {
  final queryApi = QueryApi();
  late Future<Uint8List> splashImg;

  /// 跳转主页面
  /// [context] 上下文
  /// [milliseconds] 延迟时间
  void navigateToSchedule(BuildContext context, int milliseconds) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      GoRouter.of(context).replace(GoRouteConfig.appMain);
    });
  }

  /// 获取随机首页图片
  void getRandomHomeImg() {
    splashImg = queryApi.getRandomTwoDimensionalSpace();
    notifyListeners();
  }
}
