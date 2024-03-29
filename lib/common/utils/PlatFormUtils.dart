import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../manager/DataStorageManager.dart';

class PlatformUtils {
  static bool _isWeb() {
    return kIsWeb == true;
  }

  static bool _isAndroid() {
    return _isWeb() ? false : Platform.isAndroid;
  }

  static bool _isIOS() {
    return _isWeb() ? false : Platform.isIOS;
  }

  static bool _isMacOS() {
    return _isWeb() ? false : Platform.isMacOS;
  }

  static bool _isWindows() {
    return _isWeb() ? false : Platform.isWindows;
  }

  static bool _isFuchsia() {
    return _isWeb() ? false : Platform.isFuchsia;
  }

  static bool _isLinux() {
    return _isWeb() ? false : Platform.isLinux;
  }

  static bool get isWeb => _isWeb();

  static bool get isAndroid => _isAndroid();

  static bool get isIOS => _isIOS();

  static bool get isMacOS => _isMacOS();

  static bool get isWindows => _isWindows();

  static bool get isFuchsia => _isFuchsia();

  static bool get isLinux => _isLinux();

  static Future<void> initForDesktop() async {
    if (isWindows || isLinux || isMacOS) {
      await windowManager.ensureInitialized();
      String? size = DataStorageManager().getString("windowsSize");
      Size? windowSize;
      if (size != null) {
        Map<String, dynamic> sizeMap = jsonDecode(size);
        windowSize = Size(sizeMap["width"], sizeMap["height"]);
      }

      WindowOptions windowOptions = WindowOptions(
        size: windowSize ?? const Size(400, 700),
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        minimumSize: const Size(400, 700),
      );
      String? offset = DataStorageManager().getString("windowsOffsetPosition");
      if (offset != null) {
        Map<String, dynamic> offsetMap = jsonDecode(offset);
        windowManager.setPosition(Offset(offsetMap["x"], offsetMap["y"]));
      }
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }
}
