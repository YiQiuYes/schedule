import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gesture_pwd/gesture_password.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/api/learnThrough/LearnOtherApi.dart';
import 'package:schedule/api/learnThrough/LearnSignApi.dart';
import 'package:schedule/api/learnThrough/impl/LearnUserApiImpl.dart';
import 'package:schedule/common/components/alertDialogTextField/AlertDialogTextField.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/ResponseUtils.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/route/GoRouteConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api/learnThrough/LearnUserApi.dart';
import '../../../../api/learnThrough/impl/LearnOtherApiImpl.dart';
import '../../../../api/learnThrough/impl/LearnSignApiImpl.dart';
import '../../../../common/manager/DataStorageManager.dart';
import '../../../../generated/l10n.dart';
import '../../../camera/CameraView.dart';

class LearnThroughViewModel with ChangeNotifier {
  final LearnUserApi _learnUserApi = LearnUserApiImpl();
  final LearnSignApi _learnSignApi = LearnSignApiImpl();
  final LearnOtherApi _learnOtherApi = LearnOtherApiImpl();
  final _storage = DataStorageManager();

  // 账号控制器
  final TextEditingController phoneController = TextEditingController();
  // 密码控制器
  final TextEditingController passwordController = TextEditingController();
  // 签到码控制器
  final TextEditingController signCodeController = TextEditingController();
  // 位置经纬控制器
  final TextEditingController lonAndLatController = TextEditingController();
  // 位置地址控制器
  final TextEditingController addressController = TextEditingController();

  // 用户个人数据
  final Map<String, dynamic> _learnThroughUserData = {
    "phone": "",
    "password": "",
  };

  /// 初始化
  void init(BuildContext context) {
    // 读取用户个人数据
    String? userInfoDataStr = _storage.getString("learnThroughUserData");
    if (userInfoDataStr != null) {
      Map<String, dynamic> map = jsonDecode(userInfoDataStr);
      map.forEach((key, value) {
        _learnThroughUserData[key] = value;
      });
    } else {
      _storage.setString(
          "learnThroughUserData", jsonEncode(_learnThroughUserData));
    }

    // 用户名和密码为空则需要登录
    if (_learnThroughUserData["phone"] == "" ||
        _learnThroughUserData["password"] == "") {
      showLoginDialog(context);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    signCodeController.dispose();
    lonAndLatController.dispose();
    addressController.dispose();
    super.dispose();
  }

  /// 弹出登录窗口
  void showLoginDialog(BuildContext context) {
    // 弹出登录窗口
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogTextField(
          textControllerList: [phoneController, passwordController],
          labelTextList: [
            S.current.functionViewLearnThroughLoginPhone,
            S.current.functionViewLearnThroughLoginPassword,
          ],
          title: S.current.functionViewLearnThroughLoginTitle,
          confirmCallback: () async {
            await setLearnThroughUser("phone", phoneController.text);
            await setLearnThroughUser("password", passwordController.text);
            bool isLogin = await _learnUserApi.userLogin(
              phone: _learnThroughUserData["phone"],
              password: _learnThroughUserData["password"],
            );

            if (isLogin) {
              FlutterToastUtil.okToast(
                S.current.functionViewLearnThroughLoginSuccess,
                milliseconds: 3000,
              );
            } else {
              FlutterToastUtil.errorToast(
                S.current.functionViewLearnThroughLoginError,
                milliseconds: 3000,
              );
            }
            Navigator.of(context).pop();
          },
          confirmText: S.current.pickerConfirm,
          cancelCallback: () {
            phoneController.clear();
            passwordController.clear();
            Navigator.of(context).pop();
          },
          cancelText: S.current.pickerCancel,
        );
      },
    );
  }

  /// 签到按钮点击逻辑
  Future<void> signIn(BuildContext context) async {
    // 开启加载动画
    FlutterToastUtil.showLoading(milliseconds: 10000);
    // 获取班级信息
    List courses = await _learnUserApi.getAllCourse();
    // 需要重新登录
    if (courses.isNotEmpty && courses[0] == 302) {
      bool isLogin = await _learnUserApi.userLogin(
        phone: _learnThroughUserData["phone"],
        password: _learnThroughUserData["password"],
      );

      if (!isLogin) {
        // 账号或密码错误
        FlutterToastUtil.errorToast(
          S.current.functionViewLearnThroughLoginError,
          milliseconds: 3000,
        );
        showLoginDialog(context);
        return;
      } else {
        courses = await _learnUserApi.getAllCourse();
      }
    }
    // 获取活跃课程
    Map activity = await _learnSignApi.traverseCourseActivity(courses: courses);
    // 如果没有活跃课程说明没有签到
    if (activity.isEmpty) {
      // 没有活跃课程
      FlutterToastUtil.okToast(
        S.current.functionViewLearnThroughNoActive,
        milliseconds: 3000,
      );
      return;
    }

    // 对活动预签到
    final isNeedSign = await _learnSignApi.preSign(
      activeId: activity["activeId"].toString(),
      courseId: activity["courseId"].toString(),
      classId: activity["classId"].toString(),
    );

    // 如果当前课程已经签到
    if (!isNeedSign) {
      // 无需签到
      FlutterToastUtil.okToast(
        S.current.functionViewLearnThroughNoActive,
        milliseconds: 3000,
      );
      return;
    }

    // 获取用户名
    String name = await _learnUserApi.getAccountInfo();
    activity["name"] = name;
    // 移除加载动画
    FlutterToastUtil.cancelToast();

    // 根据活动类型选择签到方式
    await _signByActivity(activity, context);
  }

  /// 根据activity选择哪种类型的签到
  Future<void> _signByActivity(Map activity, BuildContext context) async {
    switch (activity["otherId"]) {
      case 0:
        final iptPPTActiveInfo = await _learnSignApi.getPPTActiveInfo(
            activeId: activity["activeId"].toString());
        if (iptPPTActiveInfo["ifphoto"] == 1) {
          // 拍照签到
          _signPhotoSign(activity, context);
        } else {
          // 普通签到
          _generalSign(activity);
        }
        break;
      case 2:
        // 二维码签到
        _signQRSign(activity, context);
        break;
      case 3:
        // 手势签到
        _gestureSign(activity, context);
        break;
      case 4:
        // 位置签到
        _locationSign(activity, context);
        break;
      case 5:
        // 签到码签到
        _signCodeSign(activity, context);
        break;
      default:
        break;
    }
  }

  /// 拍照签到
  Future<void> _signPhotoSign(Map activity, BuildContext context) async {
    final result = await GoRouter.of(context).push(
      GoRouteConfig.camera,
      extra: {
        "type": CameraType.camera,
        "appBarTitle": S.current.functionViewLearnThroughPhotoSign,
      },
    );
    if (result != null) {
      Uint8List image = (result as Map)["photo"];
      // 获取鉴权token
      String token = await _learnUserApi.getPanToken();
      // 上传图片文件
      final res = await _learnOtherApi.uploadPhoto(
        token: token,
        imageByte: image,
      );
      final obj = ResponseUtils.decodeData(res);
      String objectId = obj["objectId"];
      // 签到
      final signResult = await _learnSignApi.photoSign(
        name: activity["name"],
        activeId: activity["activeId"].toString(),
        objectId: objectId,
      );

      if (signResult == "success") {
        FlutterToastUtil.okToast(
          S.current.functionViewLearnThroughGestureSignSuccess,
          milliseconds: 3000,
        );
      } else {
        FlutterToastUtil.errorToast(
          S.current.functionViewLearnThroughGestureSignFailed,
          milliseconds: 3000,
        );
      }
    } else {
      FlutterToastUtil.errorToast(
        S.current.functionViewLearnThroughPhotoNoFound,
        milliseconds: 3000,
      );
    }
  }

  /// 二维码签到
  Future<void> _signQRSign(Map activity, BuildContext context) async {
    final iptPPTActiveInfo = await _learnSignApi.getPPTActiveInfo(
        activeId: activity["activeId"].toString());
    // 带有位置签到的二维码
    if (iptPPTActiveInfo["ifopenAddress"] == 1) {
      // 提示跳转到地图
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogTextField(
            title: S.of(context).functionViewLearnThroughJumpToTheBrowser,
            content: Text(S.of(context).functionViewLearnThroughJumpTip),
            confirmCallback: () async {
              jumpBrowser(
                  "https://api.map.baidu.com/lbsapi/getpoint/index.html");
              Navigator.of(context).pop();
            },
            confirmText: S.current.pickerConfirm,
            cancelCallback: () {
              lonAndLatController.clear();
              Navigator.of(context).pop();
            },
            cancelText: S.current.pickerCancel,
          );
        },
      );

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialogTextField(
            title: S.current.functionViewLearnThroughLocationSignTitle,
            textControllerList: [
              lonAndLatController,
              addressController
            ],
            labelTextList: [
              S
                  .of(context)
                  .functionViewLearnThroughLocationSignLatitudeAndLongitude,
              S.of(context).functionViewLearnThroughLocationSignAddress
            ],
            hintTextList: [
              "113.114551, 27.824458",
              S.of(context).functionViewLearnThroughAddressHint,
            ],
            confirmCallback: () async {
              String latAndLon = lonAndLatController.text;
              // 判断经纬度是否为空
              if (latAndLon.isEmpty ||
                  latAndLon.split(",").length != 2) {
                FlutterToastUtil.errorToast(
                  S.current.functionViewLearnThroughLocationError,
                  milliseconds: 3000,
                );
                return;
              }
              GoRouter.of(context).pop();
            },
            confirmText: S.current.pickerConfirm,
            cancelCallback: () {
              lonAndLatController.clear();
              Navigator.of(context).pop();
            },
            cancelText: S.current.pickerCancel,
          );
        },
      );
    }

    // 显示二维码部分
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialogTextField(
          title: S.of(context).functionViewLearnThroughQRCodeSign,
          content: Text(S.of(context).functionViewLearnThroughQRJumpTip),
          cancelText: S.current.pickerCancel,
          confirmText: S.current.pickerConfirm,
          cancelCallback: () {
            GoRouter.of(context).pop();
          },
          confirmCallback: () async {
            // 二维码签到
            final result = await GoRouter.of(context).push(
              GoRouteConfig.camera,
              extra: {
                "type": CameraType.qrCode,
                "appBarTitle": S.current.functionViewLearnThroughQRCodeSign,
              },
            );

            if (result != null) {
              String qrCode = (result as Map)["enc"];
              // 处理qrCode得到enc
              List<String> split = qrCode.split("&");
              // 找到含有enc=的字符串
              String enc = "";
              for (var i in split) {
                if (i.contains("enc=")) {
                  enc = i.split("=")[1];
                  break;
                }
              }

              String lonAndLat = lonAndLatController.text;
              String lat = "";
              String lon = "";
              // 判断经纬度是否存在
              if (lonAndLat.split(",").length == 2) {
                lat = lonAndLat.split(",")[1];
                lon = lonAndLat.split(",")[0];
              }

              final signResult = await _learnSignApi.qrCodeSign(
                name: activity["name"],
                activeId: activity["activeId"].toString(),
                enc: enc,
                address: addressController.text,
                lat: lat,
                lon: lon,
                altitude: "100",
              );

              if (signResult == "success") {
                FlutterToastUtil.okToast(
                  S.current.functionViewLearnThroughGestureSignSuccess,
                  milliseconds: 3000,
                );
                GoRouter.of(context).pop();
              } else {
                FlutterToastUtil.errorToast(
                  S.current.functionViewLearnThroughGestureSignFailed,
                  milliseconds: 3000,
                );
              }
            } else {
              FlutterToastUtil.errorToast(
                S.current.functionViewLearnThroughQRCodeNoCurrent,
                milliseconds: 3000,
              );
            }
          },
        );
      },
    );
  }

  /// 位置签到
  Future<void> _locationSign(Map activity, BuildContext context) async {
    BuildContext parentContext = context;
    // 提示跳转到地图
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialogTextField(
          title: S.of(context).functionViewLearnThroughJumpToTheBrowser,
          content: Text(S.of(context).functionViewLearnThroughJumpTip),
          confirmCallback: () {
            jumpBrowser("https://api.map.baidu.com/lbsapi/getpoint/index.html");
            Navigator.of(context).pop();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialogTextField(
                  title: S.current.functionViewLearnThroughLocationSignTitle,
                  textControllerList: [lonAndLatController, addressController],
                  labelTextList: [
                    S
                        .of(context)
                        .functionViewLearnThroughLocationSignLatitudeAndLongitude,
                    S.of(context).functionViewLearnThroughLocationSignAddress
                  ],
                  hintTextList: [
                    "113.114551, 27.824458",
                    S.of(context).functionViewLearnThroughAddressHint,
                  ],
                  confirmCallback: () async {
                    FToast().init(context);

                    String latAndLon = lonAndLatController.text;
                    // 判断经纬度是否为空
                    if (latAndLon.isEmpty || latAndLon.split(",").length != 2) {
                      FlutterToastUtil.errorToast(
                        S.current.functionViewLearnThroughLocationError,
                        milliseconds: 3000,
                      );
                      return;
                    }

                    final result = await _learnSignApi.locationSign(
                      name: activity["name"],
                      address: addressController.text,
                      activeId: activity["activeId"].toString(),
                      lat: lonAndLatController.text.split(",")[1],
                      lon: lonAndLatController.text.split(",")[0],
                    );
                    if (result == "success") {
                      FlutterToastUtil.okToast(
                        S.current.functionViewLearnThroughGestureSignSuccess,
                        milliseconds: 3000,
                      );
                      FToast().init(parentContext);
                      GoRouter.of(context).pop();
                    } else {
                      FlutterToastUtil.errorToast(
                        S.current.functionViewLearnThroughGestureSignFailed,
                        milliseconds: 3000,
                      );
                      FToast().init(parentContext);
                    }
                  },
                  confirmText: S.current.pickerConfirm,
                  cancelCallback: () {
                    lonAndLatController.clear();
                    Navigator.of(context).pop();
                  },
                  cancelText: S.current.pickerCancel,
                );
              },
            );
          },
          confirmText: S.current.pickerConfirm,
          cancelCallback: () {
            lonAndLatController.clear();
            Navigator.of(context).pop();
          },
          cancelText: S.current.pickerCancel,
        );
      },
    );
  }

  /// 普通签到
  Future<void> _generalSign(Map activity) async {
    final result = await _learnSignApi.generalSign(
      name: activity["name"],
      activeId: activity["activeId"].toString(),
    );

    if (result == "success") {
      FlutterToastUtil.okToast(
        S.current.functionViewLearnThroughGestureSignSuccess,
        milliseconds: 3000,
      );
    } else {
      FlutterToastUtil.errorToast(
        S.current.functionViewLearnThroughGestureSignFailed,
        milliseconds: 3000,
      );
    }
  }

  /// 签到码签到
  Future<void> _signCodeSign(Map activity, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialogTextField(
          title: S.current.functionViewLearnThroughSignCodeTitle,
          textControllerList: [signCodeController],
          labelTextList: [S.current.functionViewLearnThroughSignCodeLabel],
          confirmCallback: () async {
            final result = await _learnSignApi.gestureSign(
              name: activity["name"],
              activeId: activity["activeId"].toString(),
              signCode: signCodeController.text,
            );

            if (result == "success") {
              Navigator.pop(context);
              FlutterToastUtil.okToast(
                S.current.functionViewLearnThroughGestureSignSuccess,
                milliseconds: 3000,
              );
            } else {
              FlutterToastUtil.errorToast(
                S.current.functionViewLearnThroughGestureSignFailed,
                milliseconds: 3000,
              );
            }
          },
          confirmText: S.current.pickerConfirm,
          cancelCallback: () {
            signCodeController.clear();
            Navigator.of(context).pop();
          },
          cancelText: S.current.pickerCancel,
        );
      },
    );
  }

  /// 手势签到
  Future<void> _gestureSign(Map activity, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialogTextField(
          title: S.current.functionViewLearnThroughGestureSignTitle,
          content: GesturePasswordWidget(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            highlightColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.6),
            pathColor: Theme.of(context).colorScheme.tertiary,
            frameRadius: ScreenAdaptor().getLengthByOrientation(
              vertical: 55.w,
              horizon: 20.w,
            ),
            pointRadius: ScreenAdaptor().getLengthByOrientation(
              vertical: 15.w,
              horizon: 5.w,
            ),
            onFinishGesture: (gesture) async {
              String signCode = "";
              for (var i in gesture) {
                signCode = signCode + (i + 1).toString();
              }

              final result = await _learnSignApi.gestureSign(
                name: activity["name"],
                activeId: activity["activeId"].toString(),
                signCode: signCode,
              );

              if (result == "success") {
                Navigator.pop(context);
                FlutterToastUtil.okToast(
                  S.current.functionViewLearnThroughGestureSignSuccess,
                  milliseconds: 3000,
                );
              } else {
                FlutterToastUtil.errorToast(
                  S.current.functionViewLearnThroughGestureSignFailed,
                  milliseconds: 3000,
                );
              }
            },
          ),
        );
      },
    );
  }

  /// 设置数据
  Future<bool> setLearnThroughUser(String key, dynamic value) async {
    _learnThroughUserData[key] = value;
    notifyListeners();
    return await _storage.setString(
        "learnThroughUserData", jsonEncode(_learnThroughUserData));
  }

  /// 跳转浏览器
  void jumpBrowser(String url) {
    // 外部浏览器打开
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
