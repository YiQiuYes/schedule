import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DeviceInfoUtils {
  static void specificDeviceConfigurations() {
    final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
    bool isTablet = data.size.shortestSide > 600;

    if (!isTablet) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    }
  }
}
