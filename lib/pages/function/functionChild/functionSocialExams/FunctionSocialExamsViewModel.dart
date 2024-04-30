import 'package:flutter/material.dart';

import '../../../../api/schedule/QueryApi.dart';
import '../../../../api/schedule/impl/QueryApiImpl.dart';

class FunctionSocialExamsViewModel with ChangeNotifier {
  final QueryApi _queryApi = QueryApiImpl();

  // 用于存储个人成绩数据
  List<Map<String, dynamic>> _personScoreList = [];
  // 是否正在加载
  bool _isLoading = true;

  FunctionSocialExamsViewModel() {
    querySocialExamsScore();
  }

  /// 查询社会考试成绩
  void querySocialExamsScore() {
    _isLoading = true;
    _queryApi
        .queryPersonSocialExams()
        .then((value) {
      _isLoading = false;
      _personScoreList = value;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get personScoreList => _personScoreList;
  bool get isLoading => _isLoading;
}
