import 'package:get/get.dart';

import '../../../global_logic.dart';
import 'state.dart';

class ColorThemeLogic extends GetxController {
  final ColorThemeState state = ColorThemeState();
  final globalLogic = Get.find<GlobalLogic>();

  /// 获取主题颜色列表
  List<String> get colorList => state.colorMap.keys.toList();

  /// 设置主题颜色点击事件
  void setColorTheme(String color) {
    globalLogic.setColorTheme(state.colorMap[color]?["hex"] as String);
  }
}
