import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/v2/schedule_query_api_v2.dart';

import 'state.dart';

class FunctionSocialExamsLogic extends GetxController {
  final FunctionSocialExamsState state = FunctionSocialExamsState();

  final queryApi = ScheduleQueryApiV2();

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
