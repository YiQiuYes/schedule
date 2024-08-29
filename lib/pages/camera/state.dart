import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraState {
  // 二维码扫描控制器
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  // 页面传递的参数
  Map<String, dynamic> arguments = {};

  CameraState() {
    ///Initialize variables
  }
}
