import 'package:flutter/material.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../generated/l10n.dart';

class FunctionViewModel with ChangeNotifier {
  FunctionViewModel({required BuildContext context}) {
    // 初始化
    _functionScheduleCardList = [
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
        'icon': Icons.grade_rounded,
        'title': S.of(context).functionViewSocialExams,
        'route': GoRouteConfig.functionSocialExams,
      },
      {
        'icon': Icons.house_rounded,
        'title': S.of(context).functionEmptyClassroom,
        'route': GoRouteConfig.functionEmptyClassroom,
      },
      {
        'icon': Icons.people_rounded,
        'title': S.of(context).functionTeacherTitle,
        'route': GoRouteConfig.functionTeacher,
      },
      {
        'icon': Icons.schedule_rounded,
        'title': S.of(context).functionExamSchedule,
        'route': GoRouteConfig.functionExam,
      }
    ];

    _functionLifeAssistantCardList = [
      {
        'icon': Icons.school_rounded,
        'title': S.of(context).functionViewLearnThroughTitle,
        'route': GoRouteConfig.functionLearnThrough,
      },
      {
        'icon': Icons.water_drop_rounded,
        'title': S.of(context).functionViewDrink798,
        'route': GoRouteConfig.function798,
      },
    ];
  }

  // 课表区域列表
  late List<Map<String, dynamic>> _functionScheduleCardList;
  // 生活助手区域列表
  late List<Map<String, dynamic>> _functionLifeAssistantCardList;

  List<Map<String, dynamic>> get functionScheduleCardList => _functionScheduleCardList;
  List<Map<String, dynamic>> get functionLifeAssistantCardList => _functionLifeAssistantCardList;
}