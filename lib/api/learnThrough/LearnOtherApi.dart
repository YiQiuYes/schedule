import 'dart:typed_data';

abstract class LearnOtherApi {
  /// 本地扫描二维码
  /// [imageByte] 图片字节
  /// return 二维码内容
  Future<String> localQRScan({required Uint8List imageByte});

  /// 上传图片
  /// [imageByte] 图片字节
  /// [token] 用户鉴权token
  /// return objectId
  Future<String> uploadPhoto(
      {required Uint8List imageByte, required String token});
}
