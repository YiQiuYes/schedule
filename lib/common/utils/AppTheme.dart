import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';

class AppTheme {
  AppTheme._privateConstructor();
  static final AppTheme _instance = AppTheme._privateConstructor();
  factory AppTheme() {
    return _instance;
  }

  /// 状态栏和底部小白条沉浸
  static void statusBarAndBottomBarImmersed() {
    if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
      SingletonFlutterWindow window = WidgetsBinding.instance.window;
      Brightness brightness = window.platformBrightness;

      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      window.onPlatformBrightnessChanged = () {
        Brightness brightness = window.platformBrightness;
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      };
    }
  }
}
