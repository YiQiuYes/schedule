import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_query_api.dart';
import 'package:schedule/common/utils/logger_utils.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_logic.dart';
import 'state.dart';

class FunctionAllCourseLogic extends GetxController {
  final FunctionAllCourseState state = FunctionAllCourseState();
  final globalState = Get.find<GlobalLogic>().state;

  final queryApi = ScheduleQueryApi();

  /// 选择周次
  void selectWeekConfirm(Picker picker, List<int> value) {
    state.week.value = (value[0] + 1).toString();
    getCourseData(
      state.pickerData[state.collegeAndMajorIndex[0]]
          .children![state.collegeAndMajorIndex[1]].value!,
      state.week.value,
    );
  }

  /// 选择学院和专业
  void selectCollegeAndMajorConfirm(Picker picker, List<int> value) {
    // 获取课程信息
    getCourseData(state.pickerData[value[0]].children![value[1]].value!,
        state.week.value);
    state.collegeAndMajorIndex = value;
  }

  /// 初始化
  Future<void> init() async {
    // 获取学院信息
    await queryApi.queryCollegeInfo().then((value) {
      state.originCollegeInfo = value;
      state.pickerData.clear();
      state.pickerData.addAll(value
          .map((e) => PickerItem<String>(
              value: e["collegeName"],
              children: <PickerItem<String>>[PickerItem<String>(value: "")]))
          .toList());
    });

    // 多线程并发
    List<Future<List<String>>> task = [];
    for (int i = 0; i < state.pickerData.length; i++) {
      task.add(queryApi.queryMajorInfo(
          collegeId: getCollegeIdByName(state.pickerData[i].value!),
          semester: globalState.semesterWeekData["semester"]));
    }

    final result = await Future.wait(task);
    for (int i = 0; i < state.pickerData.length; i++) {
      state.pickerData[i].children?.clear();
      state.pickerData[i].children
          ?.addAll(result[i].map((e) => PickerItem<String>(value: e)).toList());
    }

    // 获取课程信息
    await getCourseData(
        state.pickerData[0].children![0].value!, state.week.value);
    state.isLoad.value = false;
    update();
  }

  /// 获取adapter
  PickerDataAdapter<String> getClassPickerData() {
    return PickerDataAdapter<String>(
      data: state.pickerData,
      isArray: false,
    );
  }

  /// 根据名称获取学院ID
  String getCollegeIdByName(String collegeName) {
    return state.originCollegeInfo.firstWhere(
        (element) => element["collegeName"] == collegeName)["collegeId"];
  }

  /// 获取周次数据
  PickerDataAdapter getWeekPickerData(BuildContext context) {
    List<PickerItem<String>> weekPickerData = List.generate(20, (index) {
      return PickerItem<String>(
        value: S.of(context).schedule_current_week(index + 1),
      );
    });
    return PickerDataAdapter<String>(
      data: weekPickerData,
      isArray: false,
    );
  }

  /// 获取课程表数据
  Future<void> getCourseData(String majorName, String week) async {
    await queryApi
        .queryMajorCourse(
            week: week,
            semester: globalState.semesterWeekData["semester"],
            majorName: majorName,
            cachePolicy: CachePolicy.refresh)
        .then((value) {
      // logger.i(value);
      state.courseData.value = value;
      update();
    });
  }
}
