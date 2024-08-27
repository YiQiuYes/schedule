import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_query_api.dart';
import 'package:schedule/global_logic.dart';

import 'state.dart';

class FunctionTeacherLogic extends GetxController {
  final FunctionTeacherState state = FunctionTeacherState();
  final globalState = Get.find<GlobalLogic>().state;
  final queryApi = ScheduleQueryApi();

  @override
  void onClose() {
    state.teacherNameController.dispose();
    state.scrollController.dispose();
    super.onClose();
  }

  /// 获取教师课表
  Future<void> getTeacherCourse(String teacherName) async {
    // 获取教师课表
    state.teacherCourseList.value = await queryApi.queryTeacherCourse(
      semester: globalState.semesterWeekData["semester"],
      teacherName: teacherName,
    );
    update();
  }

  /// 获取课程时间
  String getCourseTime(String courseTime, int week, int lesson) {
    final weeks = ["一", "二", "三", "四", "五", "六", "日"];
    return "$courseTime 星期${weeks[week - 1]} 第$lesson节";
  }
}
