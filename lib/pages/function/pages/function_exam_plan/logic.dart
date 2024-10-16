import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_query_api.dart';
import 'package:schedule/global_logic.dart';

import 'state.dart';

class FunctionExamPlanLogic extends GetxController {
  final FunctionExamPlanState state = FunctionExamPlanState();
  final globalState = Get.find<GlobalLogic>().state;
  final queryApi = ScheduleQueryApi();


  void init() {
    queryExamPlan();
  }

  /// 查询考试计划
  void queryExamPlan() {
    state.isLoading.value = true;
    queryApi
        .queryPersonExamPlan(semester: globalState.semesterWeekData["semester"])
        .then((value) {
      state.isLoading.value = false;
      state.personExamList.value = value;
      update();
    });
  }
}
