import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:schedule/common/utils/logger_utils.dart';

import '../../common/utils/screen_utils.dart';
import '../app_main/logic.dart';
import 'logic.dart';

// 枚举
enum CameraPageType {
  qrCode,
}

class CameraPage extends StatelessWidget {
  CameraPage({super.key});

  final logic = Get.put(CameraLogic());
  final state = Get.find<CameraLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init(context);
    final type = logic.getPageType();

    return Scaffold(
      appBar: AppBar(
        title: Text(logic.getAppBarTitle()),
      ),
      body: Stack(
        children: [
          // 获取相册类型
          switchTypeWidget(context, type),
          // 获取底部操作行
          bottomPhotoBtnWidget(type),
        ],
      ),
    );
  }

  /// 获取相册类型
  Widget switchTypeWidget(BuildContext context, CameraPageType type) {
    switch (type) {
      case CameraPageType.qrCode:
        return qrViewPreviewWidget(type);
      default:
        return qrViewPreviewWidget(type);
    }
  }

  /// 获取二维码扫描预览
  Widget qrViewPreviewWidget(CameraPageType type) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: QRView(
        key: state.qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Theme.of(Get.context!).colorScheme.primary,
          borderRadius: ScreenUtils.length(vertical: 20.w, horizon: 10.w),
          borderLength: ScreenUtils.length(vertical: 35.w, horizon: 20.w),
          borderWidth: ScreenUtils.length(vertical: 8.w, horizon: 5.w),
          cutOutSize: ScreenUtils.length(vertical: 350.w, horizon: 180.w),
          cutOutBottomOffset:
          ScreenUtils.length(vertical: 150.w, horizon: 65.w),
        ),
        onQRViewCreated: (controller) {
          state.qrViewController = controller;
          controller.scannedDataStream.listen((scanData) {
            controller.stopCamera();

            final appMainLogic = Get.find<AppMainLogic>().state;
            if (appMainLogic.orientation.value) {
              // 处理识别结果并返回上一个页面
              Get.back(result: {'enc': scanData.code}, id: 2);
            } else {
              // 处理识别结果并返回上一个页面
              Get.back(result: {'enc': scanData.code}, id: 3);
            }
          });
        },
      ),
    );
  }

  /// 获取底部选择相册按钮
  Widget bottomPhotoBtnWidget(CameraPageType type) {
    if (type == CameraPageType.qrCode) {
      return Align(
        alignment: const Alignment(0, 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 闪光灯按钮
            IconButton(
              onPressed: () {
                // 翻转闪光灯
                state.qrViewController?.toggleFlash();
              },
              padding: EdgeInsets.all(
                ScreenUtils.length(vertical: 20.w, horizon: 12.w),
              ),
              icon: Icon(
                Icons.flash_on_rounded,
                color: Colors.white,
                size: ScreenUtils.length(vertical: 80.w, horizon: 40.w),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
