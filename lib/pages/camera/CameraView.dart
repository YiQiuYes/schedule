import 'package:camera/camera.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';

import '../../generated/l10n.dart';
import 'CameraViewModel.dart';

// 枚举
enum CameraType {
  qrCode,
  camera,
  desktop,
}

class CameraView extends StatelessWidget {
  const CameraView(
      {super.key, this.type = CameraType.camera, this.appBarTitle});

  final CameraType type;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final model = CameraViewModel();
        model.init(type);
        return model;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle ?? S.of(context).cameraViewAppBarTitle),
        ),
        body: Stack(
          children: [
            // 获取相册类型
            _switchType(context, type),
            // 获取底部操作行
            _getBottomPhotoBtn(),
          ],
        ),
      ),
    );
  }

  /// 获取相册类型
  Widget _switchType(BuildContext context, CameraType type) {
    switch (type) {
      case CameraType.qrCode:
        return _getQrViewPreview(type);
      case CameraType.camera:
        return _getCameraPreview(type);
      case CameraType.desktop:
        return _getDesktopDragFile(context, type);
    }
  }

  /// 桌面端拖拽文件
  Widget _getDesktopDragFile(BuildContext context, CameraType type) {
    if (!PlatformUtils.isLinux &&
        !PlatformUtils.isWindows &&
        type != CameraType.desktop) {
      return const SizedBox();
    }

    return Center(
      child: Consumer<CameraViewModel>(
        builder: (context, model, child) {
          return DropTarget(
            onDragDone: (detail) {
              detail.files.first.readAsBytes().then((value) {
                model.scanQrCodeData(context, value);
              });
            },
            child: Container(
              width: ScreenAdaptor().getLengthByOrientation(
                vertical: 400.w,
                horizon: 200.w,
              ),
              height: ScreenAdaptor().getLengthByOrientation(
                vertical: 400.w,
                horizon: 200.w,
              ),
              decoration: DottedDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(
                  ScreenAdaptor().getLengthByOrientation(
                    vertical: 40.w,
                    horizon: 20.w,
                  ),
                ),
                shape: Shape.box,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 拖拽文件图标
                    Icon(
                      Icons.image_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: ScreenAdaptor().getLengthByOrientation(
                        vertical: 100.w,
                        horizon: 50.w,
                      ),
                    ),
                    // 间距
                    SizedBox(
                      height: ScreenAdaptor().getLengthByOrientation(
                        vertical: 20.w,
                        horizon: 10.w,
                      ),
                    ),
                    // 拖拽文件提示
                    Text(
                      S.of(context).cameraViewDesktopDragFile,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: ScreenAdaptor().getLengthByOrientation(
                          vertical: 40.sp,
                          horizon: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  /// 获取底部选择相册按钮
  Widget _getBottomPhotoBtn() {
    if (type == CameraType.desktop) {
      return const SizedBox();
    }

    if (type == CameraType.qrCode) {
      return Align(
        alignment: const Alignment(0, 0.5),
        child: Consumer<CameraViewModel>(
          builder: (context, model, child) {
            List<Widget> list = [];
            list.addAll([
              // 闪光灯按钮
              IconButton(
                onPressed: () {
                  // 翻转闪光灯
                  model.qrViewController?.toggleFlash();
                },
                padding: EdgeInsets.all(
                  ScreenAdaptor().getLengthByOrientation(
                    vertical: 20.w,
                    horizon: 12.w,
                  ),
                ),
                icon: Icon(
                  Icons.flash_on_rounded,
                  color: Colors.white,
                  size: ScreenAdaptor().getLengthByOrientation(
                    vertical: 80.w,
                    horizon: 40.w,
                  ),
                ),
              ),
            ]);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: list,
            );
          },
        ),
      );
    } else {
      return Align(
        alignment: const Alignment(0, 0.7),
        child: Consumer<CameraViewModel>(
          builder: (context, model, child) {
            List<Widget> list = [];
            if (!model.isTakePhoto) {
              list.addAll([
                // 闪光灯按钮
                IconButton(
                  onPressed: () {
                    // 翻转闪光灯
                    model.cameraToggleFlash();
                  },
                  padding: EdgeInsets.all(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 12.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.flash_on_rounded,
                    color: Colors.white,
                    size: ScreenAdaptor().getLengthByOrientation(
                      vertical: 80.w,
                      horizon: 40.w,
                    ),
                  ),
                ),
                // 点击拍照按钮
                IconButton(
                  onPressed: () {
                    // 拍照
                    model.cameraTakePhoto(context);
                  },
                  padding: EdgeInsets.all(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 12.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: ScreenAdaptor().getLengthByOrientation(
                      vertical: 80.w,
                      horizon: 40.w,
                    ),
                  ),
                ),
                // 相册按钮
                IconButton(
                  onPressed: () {
                    // 选择相册图片
                    model.pickImage(context);
                  },
                  padding: EdgeInsets.all(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 12.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.photo_rounded,
                    color: Colors.white,
                    size: ScreenAdaptor().getLengthByOrientation(
                      vertical: 80.w,
                      horizon: 40.w,
                    ),
                  ),
                ),
              ]);
            } else {
              list.addAll([
                // 确认按钮
                IconButton(
                  onPressed: () {
                    model.cameraConfirmTakePhoto(context);
                  },
                  padding: EdgeInsets.all(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 12.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: ScreenAdaptor().getLengthByOrientation(
                      vertical: 80.w,
                      horizon: 40.w,
                    ),
                  ),
                ),
                // 返回按钮
                IconButton(
                  onPressed: () {
                    model.cameraCancelTakePhoto();
                  },
                  padding: EdgeInsets.all(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 12.w,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: ScreenAdaptor().getLengthByOrientation(
                      vertical: 80.w,
                      horizon: 40.w,
                    ),
                  ),
                ),
              ]);
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: list,
            );
          },
        ),
      );
    }
  }

  /// 获取二维码扫描预览
  Widget _getQrViewPreview(CameraType type) {
    if (!PlatformUtils.isAndroid &&
        !PlatformUtils.isIOS &&
        type != CameraType.qrCode) {
      return const SizedBox();
    }

    return Consumer<CameraViewModel>(
      builder: (context, model, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: QRView(
            key: model.qrKey,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).colorScheme.primary,
              borderRadius: ScreenAdaptor().getLengthByOrientation(
                vertical: 20.w,
                horizon: 10.w,
              ),
              borderLength: ScreenAdaptor().getLengthByOrientation(
                vertical: 35.w,
                horizon: 20.w,
              ),
              borderWidth: ScreenAdaptor().getLengthByOrientation(
                vertical: 8.w,
                horizon: 5.w,
              ),
              cutOutSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 350.w,
                horizon: 180.w,
              ),
              cutOutBottomOffset: ScreenAdaptor().getLengthByOrientation(
                vertical: 150.w,
                horizon: 65.w,
              ),
            ),
            onQRViewCreated: (controller) {
              model.qrViewController = controller;
              controller.scannedDataStream.listen((scanData) {
                controller.stopCamera();
                // 处理识别结果并返回上一个页面
                GoRouter.of(context).pop({'enc': scanData.code});
              });
            },
          ),
        );
      },
    );
  }

  /// 获取照相预览
  Widget _getCameraPreview(CameraType type) {
    if (!PlatformUtils.isAndroid &&
        !PlatformUtils.isIOS &&
        type != CameraType.camera) {
      return const SizedBox();
    }

    return Consumer<CameraViewModel>(builder: (context, model, child) {
      return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: FutureBuilder(
            future: model.futureCameraController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(
                  snapshot.data as CameraController,
                );
              }
              return const SizedBox();
            }),
      );
    });
  }
}
