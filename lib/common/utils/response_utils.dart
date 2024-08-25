import 'dart:convert';

import 'package:dio/dio.dart';

class ResponseUtils {
  static dynamic transformObj(Response response) {
    return response.data is String ? jsonDecode(response.data) : response.data;
  }

  static dynamic decodeData(String input) {
    return jsonDecode(input);
  }
}