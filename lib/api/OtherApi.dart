import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/manager/RequestManager.dart';

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
    // 获取版本信息
    Response response = await _request
        .get('https://api.github.com/repos/YiQiuYes/schedule/releases/latest');
    return response.data;
  }
}
