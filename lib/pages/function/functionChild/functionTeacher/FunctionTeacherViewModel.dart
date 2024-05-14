import 'package:flutter/material.dart';
import 'package:schedule/api/schedule/QueryApi.dart';
import 'package:schedule/api/schedule/impl/QueryApiImpl.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/main.dart';

class FunctionTeacherViewModel with ChangeNotifier {
  // 滚动控制器
  ScrollController scrollController = ScrollController();
  final QueryApi _queryApi = QueryApiImpl();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// 获取教师课表
  Future<void> getTeacherCourse(String teacherName) async {
    // 获取教师课表
    await _queryApi.queryTeacherCourse(
      semester: globalModel.semesterWeekData["semester"],
      teacherName: '肖',
    );
  }
}
