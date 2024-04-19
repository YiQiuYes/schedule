import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/api/learnThrough/LearnUserApi.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';

import '../../../common/manager/RequestManager.dart';
import '../../../common/utils/ResponseUtils.dart';

class LearnUserApiImpl extends LearnUserApi {
  LearnUserApiImpl._privateConstructor();

  static final LearnUserApiImpl _instance =
      LearnUserApiImpl._privateConstructor();

  factory LearnUserApiImpl() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  /// 学习通登录
  /// [phone] 手机号
  /// [password] 密码
  /// return 是否登录成功
  @override
  Future<bool> userLogin(
      {required String phone, required String password}) async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    options.contentType = Headers.formUrlEncodedContentType;
    options.headers = {"X-Requested-With": "XMLHttpRequest"};

    Map<String, dynamic> params = {
      "uname": phone,
      "password": password,
      "fid": "-1",
      "t": "true",
      "refer": "http%3A%2F%2Fi.mooc.hut.edu.cn",
      "forbidotherlogin": "0",
      "validate": "",
      "doubleFactorLogin": "0",
      "independentId": "0",
    };

    String url = "https://passport2.chaoxing.com/fanyalogin";
    bool isLogin = await _request
        .post(url, options: options, params: params)
        .then((value) {
      var result = ResponseUtils.transformObj(value);
      // 保存cookie
      _request
          .getCookieJar()
          .loadForRequest(Uri.parse(url))
          .then((value) async {
        value = value.map((e) {
          e.domain = null;
          return e;
        }).toList();
        // logger.i(value);
        // await _request
        //     .getCookieJar()
        //     .saveFromResponse(Uri.parse("https://mooc1.hut.edu.cn"), value);

        // await _request
        //     .getCookieJar()
        //     .saveFromResponse(Uri.parse("http://i.mooc.hut.edu.cn"), value);
      });
      return result["status"];
    });

    return isLogin;
  }

  /// 返回全部课程
  /// return 课程列表id
  @override
  Future<List> getAllCourse() async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();
    options.followRedirects = false;
    options.validateStatus = (status) {
      return status! < 500;
    };

    String url = "https://mooc1-1.chaoxing.com/visit/courses";
    return await _request.get(url, options: options).then((value) {
      if (value.statusCode == 302) {
        return [302];
      }

      List result = [];
      Document doc = parse(value.data);
      List<Element> ul = doc.getElementsByClassName("clearfix");
      if (ul.isNotEmpty) {
        ul.removeLast();
        List<Element> li = ul[0].getElementsByTagName("li");
        for (var element in li) {
          List<Element> inputs = element.getElementsByTagName("input");
          if (inputs.isNotEmpty) {
            result.add({
              "courseId": inputs[0].attributes["value"],
              "classId": inputs[1].attributes["value"],
            });
          }
        }
      }

      return result;
    });
  }

  /// 获取用户名
  /// return 用户名
  @override
  Future<String> getAccountInfo() async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://passport2.chaoxing.com/mooc/accountManage";
    return await _request.get(url, options: options).then((value) {
      Document doc = parse(value.data);
      logger.i(doc.outerHtml);
      Element? span = doc.getElementById("messageName");
      // logger.i(ps[0].attributes["title"]!);
      if (span != null) {
        return span.text;
      }
      return "";
    });
  }

  /// 获取用户鉴权token
  /// return token
  @override
  Future<String> getPanToken() async {
    Options options =
        _request.cacheOptions.copyWith(policy: CachePolicy.refresh).toOptions();

    String url = "https://pan-yz.chaoxing.com/api/token/uservalid";
    return await _request.get(url, options: options).then((value) {
      var result = ResponseUtils.transformObj(value);
      // logger.i(result);
      return result["_token"];
    });
  }
}
