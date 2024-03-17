import 'package:flutter/material.dart';

class AppMainViewModel with ChangeNotifier {
  // 底部导航栏索引
  int _navigateCurrentIndex = 0;
  // TabBarView控制器
  late TabController _tabController;

  /// 改变导航栏索引
  void setNavigateCurrentIndex(int index) {
    _navigateCurrentIndex = index;
    _tabController.animateTo(index);
    notifyListeners();
  }

  /// get方法
  int get navigateCurrentIndex => _navigateCurrentIndex;
  TabController get tabController => _tabController;

  /// set方法
  set setTabController(TabController tabController) {
    _tabController = tabController;
  }
}