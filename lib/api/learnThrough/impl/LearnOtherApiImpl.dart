import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_vision/qr_code_vision.dart';

import '../../../common/manager/RequestManager.dart';
import '../../../common/utils/LoggerUtils.dart';
import '../LearnOtherApi.dart';

class LearnOtherApiImpl extends LearnOtherApi {
  LearnOtherApiImpl._privateConstructor();

  static final LearnOtherApiImpl _instance =
      LearnOtherApiImpl._privateConstructor();

  factory LearnOtherApiImpl() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  /// 本地扫描二维码
  /// [imageByte] 图片字节
  /// return 二维码内容
  @override
  Future<String> localQRScan({required Uint8List imageByte}) async {
    final qrCode = QrCode();
    qrCode.scanImageBytes(imageByte);
    if (qrCode.content != null) {
      return qrCode.content!.text;
    } else {
      return "";
    }
  }

  /// 上传图片
  /// [imageByte] 图片字节
  /// [token] 用户鉴权token
  /// return objectId
  @override
  Future<String> uploadPhoto(
      {required Uint8List imageByte, required String token}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();
    options.contentType = Headers.multipartFormDataContentType;

    String url =
        "https://pan-yz.chaoxing.com/upload?_from=mobilelearn&_token=$token";
    String uid = await _request
        .getCookieJar()
        .loadForRequest(Uri.parse(url))
        .then((value) {
      for (var element in value) {
        if (element.name == "_uid") {
          return element.value;
        }
      }
      return "";
    });
    Map<String, dynamic> map = {
      "file": MultipartFile.fromBytes(imageByte, filename: "1.png"),
      "puid": uid,
    };

    // 通过FormData
    FormData formData = FormData.fromMap(map);
    return await _request
        .post(url, options: options, data: formData)
        .then((value) {
      return "${value.data}";
    });
  }
}
