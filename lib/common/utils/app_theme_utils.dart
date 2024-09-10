import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemeUtils {
  AppThemeUtils._privateConstructor();
  static final AppThemeUtils _instance = AppThemeUtils._privateConstructor();
  factory AppThemeUtils() {
    return _instance;
  }

  /// 状态栏和底部小白条沉浸
  static void statusBarAndBottomBarImmersed() {
    PlatformDispatcher window = PlatformDispatcher.instance;
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
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    };
  }

  /// 判断是否为light或者dart模式
  static Brightness brightnessMode(BuildContext context) {
    return Theme.of(context).brightness;
  }
}
