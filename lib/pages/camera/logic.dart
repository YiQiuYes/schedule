import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/pages/camera/view.dart';

import '../../generated/l10n.dart';
import 'state.dart';

class CameraLogic extends GetxController {
  final CameraState state = CameraState();

  void init(BuildContext context) {
    getArguments(context);

    final type = getPageType();
    switch (type) {
      case CameraPageType.qrCode:
        break;
      default:
        break;
    }
  }

  /// 获取页面传参
  void getArguments(BuildContext context) {
    Object? arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map) {
      state.arguments = arguments as Map<String, dynamic>;
    }
  }

  /// 获取页面类型
  CameraPageType getPageType() {
    if (state.arguments["type"] != null &&
        state.arguments["type"] is CameraPageType) {
      return state.arguments["type"];
    } else {
      return CameraPageType.qrCode;
    }
  }

  /// 获取页面标题
  String getAppBarTitle() {
    if (state.arguments["appBarTitle"] != null &&
        state.arguments["appBarTitle"] is String) {
      return state.arguments["appBarTitle"];
    } else {
      return S.current.camera_appBar_title;
    }
  }
}
