import 'dart:async';
import 'package:get/get.dart';

class FunctionHotWaterState {
  // 设备列表
  RxList deviceList = [].obs;
  // 选中的设备值
  RxInt choiceDevice = (-1).obs;
  // 洗澡按钮状态
  RxBool waterStatus = false.obs;
  FunctionHotWaterState();
}
