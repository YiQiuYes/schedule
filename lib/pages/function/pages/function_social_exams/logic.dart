import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_query_api.dart';

import 'state.dart';

class FunctionSocialExamsLogic extends GetxController {
  final FunctionSocialExamsState state = FunctionSocialExamsState();

  final queryApi = ScheduleQueryApi();

  void init() {
    querySocialExamsScore();
  }

  /// 查询社会考试成绩
  void querySocialExamsScore() {
    state.isLoading.value = true;
    queryApi.queryPersonSocialExams().then((value) {
      state.isLoading.value = false;
      state.personScoreList.value = value;
      update();
    });
  }
}
