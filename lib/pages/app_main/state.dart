import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMainState {
  // 导航栏索引
  RxInt navigateCurrentIndex = 0.obs;
  // 主页面控制器
  late PageController mainTabController;
  // 是否为登录状态
  RxBool isLogin = false.obs;
  // 屏幕旋转方向
  RxBool orientation = true.obs;

  AppMainState() {}
}
