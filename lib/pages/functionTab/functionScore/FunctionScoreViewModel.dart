import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:schedule/main.dart';

import '../../../api/QueryApi.dart';

class FunctionScoreViewModel with ChangeNotifier {
  final _queryApi = QueryApi();

  // 用于存储个人成绩数据
  List<Map<String, dynamic>> _personScoreList = [];

  FunctionScoreViewModel() {
    queryPersonScore(globalModel.semesterWeekData['semester']);
  }

  // 当前选择的学期索引
  int _currentSemesterIndex = 0;

  /// 查询个人成绩
  void queryPersonScore(String semester) {
    _queryApi
        .queryPersonScore(semester: semester, cachePolicy: CachePolicy.refresh)
        .then((value) {
      _personScoreList = value;
      notifyListeners();
    });
  }

  /// 获取学期列表数据
  PickerDataAdapter<String> getSemesterPickerData() {
    DateTime now = DateTime.now();

    List<String> pickerData = [];

    for (int i = 0; i < 5; i++) {
      // 判断为上半学期还是下班学期
      late int whereSemester;
      if (now.month >= 2 && now.month <= 8) {
        whereSemester = 1;
      } else {
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
        pickerData.add("${now.year - 1}-${now.year}-1");
        pickerData.add("${now.year - 2}-${now.year - 1}-2");
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
    _currentSemesterIndex = value[0];
  }

  List<Map<String, dynamic>> get personScoreList => _personScoreList;

  int get currentSemesterIndex => _currentSemesterIndex;
}
