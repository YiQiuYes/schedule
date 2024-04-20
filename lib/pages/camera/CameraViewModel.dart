import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_vision/qr_code_vision.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/pages/camera/CameraView.dart';

import '../../generated/l10n.dart';

class CameraViewModel with ChangeNotifier {
  // 二维码扫描控制器
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;

  // 相机预览控制器
  Future<CameraController>? futureCameraController;
  // 是否点击了拍照
  bool isTakePhoto = false;
  // 拍照后的数据
  Uint8List? takePhotoData;

  void init(CameraType type) {
    if (type == CameraType.camera) {
      // 初始化相机预览
      futureCameraController = _initCamera();
    }
  }

  @override
  void dispose() {
    qrViewController?.dispose();
    futureCameraController?.then((value) => value.dispose());
    super.dispose();
  }

  /// 初始化相机预览
  Future<CameraController> _initCamera() async {
    // 获取相机列表
    final List<CameraDescription> cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    controller.setFlashMode(FlashMode.off);
    return controller;
  }

  /// 闪光灯逻辑
  void cameraToggleFlash() {
    futureCameraController?.then((value) {
      value.setFlashMode(value.value.flashMode == FlashMode.off
          ? FlashMode.torch
          : FlashMode.off);
    });
  }

  /// 点击拍照逻辑
  void cameraTakePhoto(BuildContext context) {
    futureCameraController?.then((value) async {
      XFile file = await value.takePicture();
      takePhotoData = await file.readAsBytes();
      isTakePhoto = true;
      value.pausePreview();
      notifyListeners();
      //value.resumePreview();
    });
  }

  /// 点击取消拍照返回继续拍照按钮
  void cameraCancelTakePhoto() {
    isTakePhoto = false;
    futureCameraController?.then((value) {
      value.resumePreview();
      notifyListeners();
    });
  }

  /// 点击确认拍照返回上一个页面
  void cameraConfirmTakePhoto(BuildContext context) {
    if (takePhotoData != null) {
      // 处理识别结果并返回上一个页面
      GoRouter.of(context).pop({'photo': takePhotoData});
    }
  }

  /// 选择相册图片
  Future<void> pickImage(BuildContext context) async {
    // 申请相册权限
    final ImagePicker picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      Uint8List bytes = await xFile.readAsBytes();
      GoRouter.of(context).pop({'photo': bytes});
    }
  }

  /// 扫描二维码二进制数据
  void scanQrCodeData(BuildContext context, Uint8List data) {
    final qrCode = QrCode();
    qrCode.scanImageBytes(data);

    // 处理识别结果
    if (qrCode.content != null) {
      GoRouter.of(context).pop({'enc': qrCode.content?.text});
    } else {
      FlutterToastUtil.errorToast(S.of(context).cameraViewNoFoundQRENCODE);
    }
  }
}
