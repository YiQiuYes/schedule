import 'package:flutter/material.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../generated/l10n.dart';

class FunctionViewModel with ChangeNotifier {
  FunctionViewModel({required BuildContext context}) {
    // 初始化
    _functionCardList = [
      {
        'icon': Icons.score_rounded,
        'title': S.of(context).functionViewScoreTitle,
        'route': GoRouteConfig.functionScore,
      },
      {
        'icon': Icons.book_rounded,
        'title': S.of(context).functionViewAllCourseTitle,
        'route': GoRouteConfig.functionAllCourse,
      },
      {
        'icon': Icons.school_rounded,
        'title': S.of(context).functionViewLearnThroughTitle,
        'route': GoRouteConfig.functionLearnThrough,
      },
    ];
  }

  // 功能区域列表
  late List<Map<String, dynamic>> _functionCardList;

  List<Map<String, dynamic>> get functionCardList => _functionCardList;
}