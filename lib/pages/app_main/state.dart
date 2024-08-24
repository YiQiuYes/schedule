import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMainState {
  // 导航栏索引
  RxInt navigateCurrentIndex = 0.obs;
  // 主页面控制器
  late PageController mainTabController;

  AppMainState() {}
}
