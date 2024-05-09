import 'package:flutter/material.dart';

class FunctionTeacherViewModel with ChangeNotifier {
  // 滚动控制器
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }


}
