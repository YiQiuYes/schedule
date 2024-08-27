import 'package:dio/dio.dart';
import '../../manager/request_manager.dart';

class OtherApi {
  OtherApi._privateConstructor();

  static final OtherApi _instance = OtherApi._privateConstructor();

  factory OtherApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  // 获取版本信息
  Future<Map<String, dynamic>> getVersionInfo() async {
    Options options = _request.cacheOptions.copyWith().toOptions();
    options.validateStatus = (status) {
      return status! < 500;
    };

    // 获取版本信息
    Response response = await _request.get(
        'https://api.github.com/repos/YiQiuYes/schedule/releases/latest',
        options: options);
    return response.data;
  }
}
