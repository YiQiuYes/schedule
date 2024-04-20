import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/api/drink798/drink798Api.dart';
import 'package:schedule/api/drink798/impl/drink798ApiImpl.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';

import '../../../../common/components/alertDialogTextField/AlertDialogTextField.dart';
import '../../../../generated/l10n.dart';
import '../../../camera/CameraView.dart';

class Function798ViewModel with ChangeNotifier {
  final Drink798API _drink798UserApi = Drink798ApiImpl();

  // 账号控制器
  final TextEditingController phoneController = TextEditingController();

  // 图片验证码控制器
  final TextEditingController photoCaptchaController = TextEditingController();

  // 短信验证码控制器
  final TextEditingController messageCaptchaController =
      TextEditingController();

  // Token框控制器
  final TextEditingController tokenController = TextEditingController();

  // 验证码倒计时Timer
  Timer? captchaTimer;

  // 设备状态检测
  Timer? deviceStatusTimer;

  // 倒计时秒数
  int time = 0;

  // 随机数
  double doubleRandom = 0;

  // 验证码数据
  Future<Uint8List> captchaData = Future.value(Uint8List(0));

  // 选中的设备值
  int choiceDevice = 0;

  // 设备列表
  List<Map> deviceList = [];

  // 喝水按钮状态
  int drinkStatus = 0;

  /// 初始化
  void init(BuildContext context) {
    // 获取设备列表
    getDeviceList(context);
    // 获取token
    _drink798UserApi.getToken().then((value) {
      tokenController.text = value;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    photoCaptchaController.dispose();
    messageCaptchaController.dispose();
    tokenController.dispose();
    captchaTimer?.cancel();
    deviceStatusTimer?.cancel();
    super.dispose();
  }

  /// 删除相对应的device
  void removeDeviceByName(String name) {
    deviceList.removeWhere((element) => element["name"] == name);
    notifyListeners();
  }

  /// 弹出登录窗口
  void showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialogTextField(
          content: StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              width: ScreenAdaptor().getLengthByOrientation(
                vertical: 600.w,
                horizon: 250.w,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    width: ScreenAdaptor().getLengthByOrientation(
                      vertical: 440.w,
                      horizon: 120.w,
                    ),
                    child: AlertDialogTextField.getCustomTextFiled(
                      context,
                      controller: phoneController,
                      labelText: S.current.functionViewDrinkLoginPhone,
                    ),
                  ),
                  // 纵向间距
                  SizedBox(
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 13.w,
                    ),
                  ),
                  // 图片验证码
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 验证码输入框
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 220.w,
                          horizon: 120.w,
                        ),
                        child: AlertDialogTextField.getCustomTextFiled(
                          context,
                          controller: photoCaptchaController,
                          labelText: S.current.functionViewDrinkLoginPhotoCode,
                        ),
                      ),
                      // 横向间距
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 20.w,
                          horizon: 10.w,
                        ),
                      ),
                      // 图片验证码
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 180.w,
                          horizon: 120.w,
                        ),
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 90.w,
                          horizon: 50.w,
                        ),
                        child: FutureBuilder(
                          future: captchaData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  ScreenAdaptor().getLengthByOrientation(
                                    vertical: 10.w,
                                    horizon: 5.w,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    getPhotoCaptchaData();
                                    setState(() {});
                                  },
                                  borderRadius: BorderRadius.circular(
                                    ScreenAdaptor().getLengthByOrientation(
                                      vertical: 10.w,
                                      horizon: 5.w,
                                    ),
                                  ),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      // 横向间距
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 20.w,
                          horizon: 10.w,
                        ),
                      ),
                    ],
                  ),
                  // 纵向间距
                  SizedBox(
                    height: ScreenAdaptor().getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 13.w,
                    ),
                  ),
                  // 短信验证码
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 验证码输入框
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 220.w,
                          horizon: 120.w,
                        ),
                        child: AlertDialogTextField.getCustomTextFiled(
                          context,
                          controller: messageCaptchaController,
                          labelText:
                              S.current.functionViewDrinkLoginMessageCode,
                        ),
                      ),
                      // 横向间距
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 20.w,
                          horizon: 10.w,
                        ),
                      ),
                      // 短信验证码按钮
                      SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 200.w,
                          horizon: 120.w,
                        ),
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 90.w,
                          horizon: 50.w,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // 如果验证码不为0则退出
                            if (time != 0) {
                              return;
                            }
                            String phone = phoneController.text;
                            String photoCode = photoCaptchaController.text;
                            // 获取短信验证码
                            getMessageCaptcha(photoCode, phone).then((value) {
                              if (value) {
                                FlutterToastUtil.okToast(S
                                    .of(context)
                                    .functionViewDrinkLoginMessageCodeSuccess);
                              } else {
                                FlutterToastUtil.errorToast(S
                                    .of(context)
                                    .functionViewDrinkLoginMessageCodeFail);
                                getPhotoCaptchaData();
                                time = 0;
                                captchaTimer?.cancel();
                                setState(() {});
                              }
                            });

                            // 防止内存泄露
                            captchaTimer?.cancel();
                            time = 60;
                            captchaTimer = Timer.periodic(
                                const Duration(seconds: 1), (timer) {
                              time--;
                              if (time <= 0) {
                                timer.cancel();
                              } else {
                                setState(() {});
                              }
                            });
                            setState(() {});
                          },
                          child: Text(time == 0
                              ? S.of(context).functionViewDrinkCode
                              : "$time"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          title: S.current.functionViewDrinkLoginTitle,
          confirmCallback: () async {
            String phone = phoneController.text;
            String messageCode = messageCaptchaController.text;
            loginToHuiLife798(messageCode, phone).then((value) {
              if (value) {
                FlutterToastUtil.okToast(
                    S.of(context).functionViewDrinkLoginSuccess);
                // 获取设备列表
                getDeviceList(context);
                Navigator.of(context).pop();
              } else {
                FlutterToastUtil.errorToast(
                    S.of(context).functionViewDrinkLoginFail);
                getPhotoCaptchaData();
              }
            });
          },
          confirmText: S.current.pickerConfirm,
          cancelCallback: () {
            phoneController.clear();
            photoCaptchaController.clear();
            messageCaptchaController.clear();
            Navigator.of(context).pop();
          },
          cancelText: S.current.pickerCancel,
        );
      },
    );
  }

  /// 获取喝水设备列表
  void getDeviceList(BuildContext context) {
    // 获取设备列表
    _drink798UserApi.deviceList().then((value) {
      deviceList = value;
      if (deviceList.isNotEmpty && deviceList[0]["name"] == "Account failure") {
        getPhotoCaptchaData();
        showLoginDialog(context);
      } else {
        notifyListeners();
      }
    });
  }

  /// 设置token
  void setToken(String token) {
    _drink798UserApi.setToken(token: token);
    notifyListeners();
  }

  /// 获取图片验证码
  void getPhotoCaptchaData() {
    doubleRandom = Random().nextDouble();
    captchaData = _drink798UserApi.userCaptcha(
      doubleRandom: doubleRandom.toString(),
      timestamp: DateTime.timestamp().millisecondsSinceEpoch.toString(),
    );
  }

  /// 获取短信验证码
  Future<bool> getMessageCaptcha(String photoCode, String phone) async {
    return await _drink798UserApi.userMessageCode(
      doubleRandom: doubleRandom.toString(),
      photoCode: photoCode,
      phone: phone,
    );
  }

  /// 开始登录
  Future<bool> loginToHuiLife798(String messageCode, String phone) async {
    return await _drink798UserApi.userLogin(
      phone: phone,
      messageCode: messageCode,
    );
  }

  /// 收藏或取消收藏设备
  Future<bool> favoDevice(String id, bool isUnFavo) async {
    return await _drink798UserApi
        .favoDevice(id: id, isUnFavo: isUnFavo)
        .then((value) {
      if (value) {
        FlutterToastUtil.okToast(S.current.functionViewDrinkfavoriteSuccess);
      } else {
        FlutterToastUtil.errorToast(S.current.functionViewDrinkfavoriteFail);
      }
      return value;
    });
  }

  /// 改变选中的设备值
  void setChoiceDevice(int device) {
    choiceDevice = device;
    notifyListeners();
  }

  /// 获取设备名称，格式化
  String getDeviceName(String name) {
    return name.replaceAll(RegExp(r'[栋]'), '-');
  }

  /// 设置喝水按钮状态
  void setDrinkStatus(int status) {
    drinkStatus = status;
    notifyListeners();
  }

  /// 开始喝水
  void startDrink(String id) {
    _drink798UserApi.startDrink(id: id).then((value) {
      if (value) {
        drinkStatus = 1;
        // 使用count增加容错
        int count = 0;
        FlutterToastUtil.okToast(S.current.functionViewDrinkBtnStartSuccess);
        deviceStatusTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          bool isAvailable = await _drink798UserApi.isAvailableDevice(
              id: deviceList[choiceDevice]["id"]);
          // logger.i(isAvailable);
          if (isAvailable && count > 3) {
            drinkStatus = 0;
            deviceStatusTimer?.cancel();
            notifyListeners();
          } else if (isAvailable) {
            count++;
          }
        });
      } else {
        FlutterToastUtil.errorToast(S.current.functionViewDrinkBtnStartFail);
      }
      notifyListeners();
    });
  }

  /// 结束喝水
  void endDrink(String id) {
    _drink798UserApi.endDrink(id: id).then((value) {
      if (value) {
        drinkStatus = 0;
        deviceStatusTimer?.cancel();
        FlutterToastUtil.okToast(S.current.functionViewDrinkBtnEndSuccess);
      } else {
        FlutterToastUtil.errorToast(S.current.functionViewDrinkBtnEndFail);
      }
      notifyListeners();
    });
  }

  /// 扫描二维码逻辑
  void scanQRCode(BuildContext context) async {
    final result = await GoRouter.of(context).push('/camera', extra: {
      "type": CameraType.qrCode,
      "appBarTitle": S.of(context).functionViewDrinkDeviceQRCode,
    });

    if (result != null) {
      String enc = (result as Map)["enc"];
      enc = enc.split("/").last;

      // 添加到喜好
      bool isFavo = await favoDevice(enc, false);
      if (isFavo) {
        FlutterToastUtil.okToast(
            S.of(context).functionViewDrinkfavoriteSuccess);
        // 获取设备列表
        getDeviceList(context);
      } else {
        FlutterToastUtil.errorToast(
            S.of(context).functionViewDrinkfavoriteFail);
      }
    }
  }
}
