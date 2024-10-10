import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'function_route_config.dart';

class FunctionState {
  // 初始化
  List<Map<String, dynamic>> functionScheduleCardList = [
    {
      'icon': Icons.score_rounded,
      'title': S.current.function_score_title,
      'route': FunctionRouteConfig.functionScore,
    },
    {
      'icon': Icons.book_rounded,
      'title': S.current.function_all_course_title,
      'route': FunctionRouteConfig.functionAllCourse,
    },
    {
      'icon': Icons.grade_rounded,
      'title': S.current.function_social_exams,
      'route': FunctionRouteConfig.functionSocialExams,
    },
    {
      'icon': Icons.house_rounded,
      'title': S.current.function_empty_classroom,
      'route': FunctionRouteConfig.functionEmptyClassroom,
    },
    {
      'icon': Icons.people_rounded,
      'title': S.current.function_teacher_title,
      'route': FunctionRouteConfig.functionTeacher,
    },
    {
      'icon': Icons.schedule_rounded,
      'title': S.current.function_exam_plan,
      'route': FunctionRouteConfig.functionExamPlan,
    }
  ];

  List<Map<String, dynamic>> functionLifeAssistantCardList = [
    {
      'icon': Icons.water_drop_rounded,
      'title': S.current.function_drink,
      'route': FunctionRouteConfig.functionDrink,
    },
    {
      'icon': Icons.bathtub_rounded,
      'title': S.current.function_hot_water,
      'route': FunctionRouteConfig.functionHotWater,
    }
  ];

  FunctionState() {
    ///Initialize variables
  }
}
