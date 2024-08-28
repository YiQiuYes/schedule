import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';

class LoginState {
  // 验证码倒计时Timer
  Timer? captchaTimer;
  // 倒计时秒数
  RxInt time = 0.obs;
  // 随机数
  double doubleRandom = 0;
  // 用户名
  String name = "";
  // 密码
  String password = "";
  // 确认密码
  String confirmPassword = "";
  // 验证码
  String captcha = "";
  // 短信验证码
  String messageCode = "";

  // 验证码数据
  Rx<Future<Uint8List>> captchaData = Future.value(Uint8List(0)).obs;

  LoginState() {}
}
