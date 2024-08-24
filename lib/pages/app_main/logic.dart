import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();

  /// 设置导航栏索引
  void setNavigateCurrentIndex(int index) {
    state.navigateCurrentIndex.value = index;
    state.mainTabController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// 初始化主页面控制器
  void initMainTabController(TickerProvider vsync) {
    state.mainTabController = PageController(
      initialPage: 0,
    );
  }
}
