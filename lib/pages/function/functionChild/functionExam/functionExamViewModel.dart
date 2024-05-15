import 'package:flutter/material.dart';
import 'package:schedule/main.dart';

import '../../../../api/schedule/QueryApi.dart';
import '../../../../api/schedule/impl/QueryApiImpl.dart';

class FunctionExamViewModel with ChangeNotifier {
  final QueryApi _queryApi = QueryApiImpl();
  // 用于存储个人考试计划数据
  List<Map<String, dynamic>> _personExamList = [];
  // 是否正在加载
  bool _isLoading = true;

  FunctionExamViewModel() {
    queryExamPlan();
  }

  /// 查询考试计划
  void queryExamPlan() {
    _isLoading = true;
    _queryApi
        .queryPersonExamPlan(semester: globalModel.semesterWeekData["semester"])
        .then((value) {
      _isLoading = false;
      _personExamList = value;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get personExamList => _personExamList;
  bool get isLoading => _isLoading;
}
