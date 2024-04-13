import 'package:dio/dio.dart';
import 'package:schedule/common/manager/RequestManager.dart';

import '../OtherApi.dart';

class OtherApiImpl extends OtherApi {
  OtherApiImpl._privateConstructor();

  static final OtherApiImpl _instance = OtherApiImpl._privateConstructor();

  factory OtherApiImpl() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  // 获取版本信息
  @override
  Future<Map<String, dynamic>> getVersionInfo() async {
    // 获取版本信息
    Response response = await _request
        .get('https://api.github.com/repos/YiQiuYes/schedule/releases/latest');
    return response.data;
  }
}
