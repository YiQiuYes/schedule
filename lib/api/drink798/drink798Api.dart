import 'dart:typed_data';

abstract class Drink798API {
  /// 获取慧生活798登录验证码
  /// [doubleRandom] 随机浮点数
  /// [timestamp] 时间戳
  /// return 验证码图片
  Future<Uint8List> userCaptcha(
      {required String doubleRandom, required String timestamp});

  /// 获取短信验证码
  /// [doubleRandom] 随机浮点数
  /// [photoCode] 图片验证码
  /// [phone] 手机号
  /// return 是否成功
  Future<bool> userMessageCode(
      {required String doubleRandom,
      required String photoCode,
      required String phone});

  /// 开始登录
  /// [messageCode] 短信验证码
  /// [phone] 手机号
  /// return 是否成功
  Future<bool> userLogin({required String phone, required String messageCode});

  /// 获取设备列表
  /// return 设备列表
  Future<List<Map>> deviceList();

  /// 收藏或取消收藏设备
  /// return 返回是否收藏成功
  Future<bool> favoDevice({required String id, required bool isUnFavo});

  /// 开始喝水
  /// [id] 设备id
  /// return 开启设备是否成功
  Future<bool> startDrink({required String id});

  /// 结束喝水
  /// [id] 设备id
  /// return 开启设备是否成功
  Future<bool> endDrink({required String id});

  /// 检测设备状态
  /// [id] 设备id
  /// return 设备是否可用
  Future<bool> isAvailableDevice({required String id});
}
