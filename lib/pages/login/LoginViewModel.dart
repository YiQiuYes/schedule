import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'dart:typed_data';

import 'package:schedule/api/UserApi.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class LoginViewModel with ChangeNotifier {
  // 用户名输入框TextEditingController
  TextEditingController usernameController = TextEditingController();
  // 密码输入框TextEditingController
  TextEditingController passwordController = TextEditingController();
  // 验证码输入框TextEditingController
  TextEditingController captchaController = TextEditingController();

  // 密码是否可见
  bool obscureText = true;

  // 获取验证码定时器
  Timer? captchaTimer;

  // 验证码数据
  Future<Uint8List> captchaData = Future.value(Uint8List(0));

  // userApi
  final UserApi _userApi = UserApi();

  /// 初始化
  void loginViewModelInit() {
    // 获取验证码
    captchaData = _userApi.getCaptcha();
    captchaTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      changeCaptcha(isTimer: true);
    });
    usernameController.text = globalModel.userInfoData["username"];
    passwordController.text = globalModel.userInfoData["password"];
    notifyListeners();
  }

  /// 点击登录
  void login(BuildContext context) {
    String username = usernameController.text;
    String password = passwordController.text;
    String captcha = captchaController.text;

    if (username.isNotEmpty && password.isNotEmpty && captcha.isNotEmpty) {
      // 显示加载动画
      FlutterToastUtil.showLoading(milliseconds: 5000);
      _userApi
          .loginEducationalSystem(
              userAccount: username, userPassword: password, captcha: captcha)
          .then((value) {
        // 判断是否登录成功
        if (value) {
          // 保存用户信息
          globalModel.setUserInfoData("username", username);
          globalModel.setUserInfoData("password", password);

          // 储存登录成功
          globalModel.setSettings("isLogin", true);
          Future.delayed(const Duration(milliseconds: 1500), () {
            FToast().removeQueuedCustomToasts();
            FToast().removeCustomToast();
            GoRouter.of(context).replace(GoRouteConfig.appMain);
          });
        } else {
          FToast().removeQueuedCustomToasts();
          FToast().removeCustomToast();
          FlutterToastUtil.errorToast(S.of(context).loginViewLoginFiled);
          captchaController.clear();
          changeCaptcha(isTimer: false);
        }
      });
    } else {
      FlutterToastUtil.errorToast(S.of(context).loginViewTextEditNoNull);
    }
    notifyListeners();
  }

  /// 自动登录
  Future<void> autoLogin(BuildContext context) async {
    if (globalModel.userInfoData["username"] != "" &&
        globalModel.userInfoData["password"] != "") {
      // 显示加载动画 防止报错
      Future.delayed(const Duration(milliseconds: 10), () {
        FlutterToastUtil.showLoading(milliseconds: 1000 * 60);
      });

      bool isLogin = await _userApi.autoLoginEducationalSystem(
          userAccount: globalModel.userInfoData["username"],
          userPassword: globalModel.userInfoData["password"]);

      if (isLogin) {
        // 储存登录成功
        globalModel.setSettings("isLogin", true);
        Future.delayed(const Duration(milliseconds: 1500), () {
          FToast().removeQueuedCustomToasts();
          FToast().removeCustomToast();
          GoRouter.of(context).replace(GoRouteConfig.appMain);
        });
      } else {
        FToast().removeQueuedCustomToasts();
        FToast().removeCustomToast();
        FlutterToastUtil.errorToast(S.current.loginViewAutoLogin);
        changeCaptcha(isTimer: false);
      }
    }
  }

  /// 点击切换验证码
  void changeCaptcha({required bool isTimer}) async {
    Uint8List data = await captchaData;
    if (isTimer && data.isNotEmpty) {
      captchaTimer?.cancel();
      return;
    }

    captchaData = _userApi.getCaptcha().then((value) {
      captchaTimer?.cancel();
      return value;
    }).onError((error, stackTrace) {
      FlutterToastUtil.errorToast(S.current.loginViewCaptchaFailed,
          milliseconds: 5000);
      return Uint8List(0);
    });
    notifyListeners();
  }

  /// 点击切换密码是否可见
  void changeObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
