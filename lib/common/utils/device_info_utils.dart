import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DeviceInfoUtils {
  static void specificDeviceConfigurations() {
    final data =
        MediaQueryData.fromView(PlatformDispatcher.instance.implicitView!);
    bool isTablet = data.size.shortestSide > 600;

    if (!isTablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }
}
