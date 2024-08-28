import 'dart:async';

import 'package:get/get.dart';

class FunctionDrinkState {
  // 设备列表
  RxList deviceList = [].obs;
  // 选中的设备值
  RxInt choiceDevice = (-1).obs;
  // 设备状态检测
  Timer? deviceStatusTimer;

  FunctionDrinkState() {
    ///Initialize variables
  }
}
