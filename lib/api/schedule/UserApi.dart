import 'dart:typed_data';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

abstract class UserApi {
  /// 获取验证码数据
  Future<Uint8List> getCaptcha();

  /// 登录api
  Future<bool> loginEducationalSystem(
      {required String userAccount,
        required String userPassword,
        required String captcha});

  /// 自动登录api
  Future<bool> autoLoginEducationalSystem(
      {required String userAccount, required String userPassword});

  /// 获取个人信息
  Future<Map<String, dynamic>> userInfo({CachePolicy? cachePolicy});
}