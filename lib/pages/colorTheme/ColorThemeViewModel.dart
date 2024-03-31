import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../main.dart';

class ColorThemeViewModel with ChangeNotifier {
  final _colorMap = {
    "deepPurple": {
      "name": S.current.deepPurpleColor,
      "color": Colors.deepPurple,
      "hex": "#673AB7",
    },
    "green": {
      "name": S.current.greenColor,
      "color": Colors.green,
      "hex": "#4CAF50",
    },
    "pink": {
      "name": S.current.pinkColor,
      "color": Colors.pink,
      "hex": "#E91E63",
    },
    "blue": {
      "name": S.current.blueColor,
      "color": Colors.blue,
      "hex": "#2196F3",
    },
    "lime": {
      "name": S.current.limeColor,
      "color": Colors.lime,
      "hex": "#CDDC39",
    },
  };

  /// 获取主题颜色列表
  List<String> get colorList => _colorMap.keys.toList();

  /// 获取主题颜色Map
  Map<String, Map<String, dynamic>> get colorMap => _colorMap;

  /// 设置主题颜色点击事件
  void setColorTheme(String color) {
    globalModel.setColorTheme(
      _colorMap[color]?["hex"] as String,
      _colorMap[color]?["name"] as String,
    );
  }
}
