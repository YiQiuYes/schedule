import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/RequestManager.dart';

class QueryApi {
  QueryApi._privateConstructor();

  static final QueryApi _instance = QueryApi._privateConstructor();

  factory QueryApi() {
    return _instance;
  }

  // 网络管家
  final _request = RequestManager();

  /// 查询所有课程
  /// - [week] : 周次
  /// - [semester] : 学期
  Future<List<Map>> queryPersonCourse(
      {required String week, required String semester}) async {
    Map<String, dynamic> params = {
      "xnxq01id": semester,
      "zc": week,
      "sfFD": 1,
      "cj0701id": "",
      "demo": "",
      "kbjcmsid": "94D51EECEBF4F9B4E053474110AC8060",
    };

    // 处理返回数据
    return await _request
        .post("/jsxsd/xskb/xskb_list.do", params: params)
        .then((value) {
      Document doc = parse(value.data);
      List<Element> tables = doc.getElementsByTagName("table");

      List<Map> result = [];
      if (tables.isNotEmpty) {
        Element table = tables[0];
        List<Element> list = table.getElementsByClassName("kbcontent");

        const time = [
          "8:00-9:40",
          "10:00-11:40",
          "14:00-15:40",
          "16:30-17:40",
          "19:00-20:40",
        ];

        for (int i = 0; i < list.length; i++) {
          Element element = list[i];

          // logger.i(element.outerHtml);
          // 正则表达式获取 class="kbcontent">...<br> 中的内容
          RegExp regExp = RegExp(r'class="kbcontent">([\s\S]*?)<br>');
          Iterable<RegExpMatch> matches = regExp.allMatches(element.outerHtml);

          // 获取课程名称
          String? className;
          for (var match in matches) {
            className = match.group(1);
          }
          className ??= "";

          // 获取课程时间
          int index = i ~/ 7;
          String classTime = time[index];

          // 获取课程地点
          String? classAddress;
          classAddress = element.querySelector('[title=教室]')?.text;
          classAddress ??= "";

          // 获取课程老师
          String? classTeacher;
          classTeacher = element.querySelector('[title=老师]')?.text;
          classTeacher ??= "";

          // 获取课程周数
          String classWeek;
          classWeek = week;

          if (className.isNotEmpty) {
            result.add({
              "className": className,
              "classTime": classTime,
              "classAddress": classAddress,
              "classTeacher": classTeacher,
              "classWeek": classWeek,
            });
          } else {
            result.add({});
          }
        }
      }

      return result;
    });
  }
}
