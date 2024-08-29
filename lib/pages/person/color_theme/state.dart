import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class ColorThemeState {
  final colorMap = {
    "deepPurple": {
      "name": S.current.deep_purple_color,
      "color": Colors.deepPurple,
      "hex": "#673AB7",
    },
    "green": {
      "name": S.current.green_color,
      "color": Colors.green,
      "hex": "#4CAF50",
    },
    "pink": {
      "name": S.current.pink_color,
      "color": Colors.pink,
      "hex": "#E91E63",
    },
    "blue": {
      "name": S.current.blue_color,
      "color": Colors.blue,
      "hex": "#2196F3",
    },
    "lime": {
      "name": S.current.lime_color,
      "color": Colors.lime,
      "hex": "#CDDC39",
    },
  };

  ColorThemeState() {
    ///Initialize variables
  }
}
