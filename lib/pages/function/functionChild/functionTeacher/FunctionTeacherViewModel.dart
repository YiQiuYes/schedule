import 'package:flutter/material.dart';
import 'package:schedule/api/schedule/QueryApi.dart';
import 'package:schedule/api/schedule/impl/QueryApiImpl.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/main.dart';

class FunctionTeacherViewModel with ChangeNotifier {
  // 滚动控制器
  ScrollController scrollController = ScrollController();
  final QueryApi _queryApi = QueryApiImpl();
  // 教师列表数据
  List<Map> teacherCourseList = [];
  // 教师姓名查询框控制器
  TextEditingController teacherNameController = TextEditingController();

  @override
  void dispose() {
    scrollController.dispose();
    teacherNameController.dispose();
    super.dispose();
  }

  /// 获取教师课表
  Future<void> getTeacherCourse(String teacherName) async {
    // 获取教师课表
    teacherCourseList = await _queryApi.queryTeacherCourse(
      semester: globalModel.semesterWeekData["semester"],
      teacherName: teacherName,
    );
    notifyListeners();
  }

  /// 获取课程时间
  String getCourseTime(String courseTime, int week, int lesson) {
    final weeks = ["一", "二", "三", "四", "五", "六", "日"];
    return "$courseTime 星期${weeks[week - 1]} 第$lesson节";
  }
}
