import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/v2/schedule_query_api_v2.dart';
import 'package:schedule/global_logic.dart';

import 'state.dart';

class FunctionScoreLogic extends GetxController {
  final FunctionScoreState state = FunctionScoreState();
  final globalState = Get.find<GlobalLogic>().state;

  final queryApi = ScheduleQueryApiV2();

  void init() {
    queryPersonScore(globalState.semesterWeekData['semester']);
  }

  /// 查询个人成绩
  void queryPersonScore(String semester) {
    state.isLoading.value = true;
    queryApi
        .queryPersonScore(semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) {
      state.personScoreList.value = value;
      state.isLoading.value = false;
      update();
    });
  }

  /// 获取学期列表数据
  PickerDataAdapter<String> getSemesterPickerData() {
    DateTime now = DateTime.now();

    List<String> pickerData = [];

    for (int i = 0; i < 5; i++) {
      // 判断为上半学期还是下班学期
      late int whereSemester;
      if (now.month >= 2 && now.month < 8) {
        // 下半学期
        whereSemester = 1;
      } else {
        // 上半学期
        whereSemester = 0;
      }

      // 计算学期
      if (whereSemester == 1) {
        // 下半学期
        pickerData.add("${now.year - 1}-${now.year}-2");
        pickerData.add("${now.year - 1}-${now.year}-1");
        now = now.subtract(const Duration(days: 365));
      } else {
        // 上半学期
        pickerData.add("${now.year}-${now.year + 1}-1");
        pickerData.add("${now.year - 1}-${now.year}-2");
        now = now.subtract(const Duration(days: 365));
      }
    }

    return PickerDataAdapter<String>(
      pickerData: pickerData,
      isArray: false,
    );
  }

  /// 选择学期类别确认逻辑
  void selectSemesterConfirm(Picker picker, List value) {
    String select = picker.getSelectedValues()[0];
    queryPersonScore(select);
    state.currentSemesterIndex.value = value[0];
  }
}
