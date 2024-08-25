import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/utils/screen_utils.dart';
import '../../global_logic.dart';
import 'state.dart';

// 枚举方向
enum AppMainLogicAnimationMode {
  forward,
  reverse,
  refresh,
}

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();
  final globalState = Get.find<GlobalLogic>().state;

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

  /// 初始化动画控制器
  void initAnimationController(TickerProvider vsync) {
    state.controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: vsync);
    double begin = globalState.settings["isLogin"]
        ? ScreenUtils.screenWidth * 2 / 11
        : 0.0;
    double end = globalState.settings["isLogin"]
        ? 0.0
        : ScreenUtils.screenWidth * 2 / 11;
    state.animation = Tween(begin: begin, end: end).animate(state.controller);
  }

  void animationByOrientation(AppMainLogicAnimationMode mode) {
    bool orientation = ScreenUtils.getOrientation();
    state.orientation.value = orientation;
    if (orientation) {
      double begin = globalState.settings["isLogin"] ? 80.0 : 0.0;
      double end = globalState.settings["isLogin"] ? 0.0 : 80.0;
      state.animation = Tween(begin: begin, end: end).animate(state.controller);
    } else {
      double begin = globalState.settings["isLogin"]
          ? ScreenUtils.screenWidth * 2 / 11
          : 0.0;
      double end = globalState.settings["isLogin"]
          ? 0.0
          : ScreenUtils.screenWidth * 2 / 11;
      state.animation = Tween(begin: begin, end: end).animate(state.controller);
    }

    switch (mode) {
      case AppMainLogicAnimationMode.forward:
        state.controller.forward();
        break;
      case AppMainLogicAnimationMode.reverse:
        state.controller.reverse();
        break;
      case AppMainLogicAnimationMode.refresh:
        break;
    }
  }
}
