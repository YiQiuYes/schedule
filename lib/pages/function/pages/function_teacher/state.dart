import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FunctionTeacherState {
  // 滚动控制器
  ScrollController scrollController = ScrollController();

  // 教师列表数据
  RxList teacherCourseList = [].obs;
  // 教师姓名查询框控制器
  TextEditingController teacherNameController = TextEditingController();

  FunctionTeacherState() {
    ///Initialize variables
  }
}
