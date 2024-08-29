import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/pages/function/pages/function_all_course/view.dart';
import 'package:schedule/pages/function/pages/function_drink/view.dart';
import 'package:schedule/pages/function/pages/function_empty_classroom/view.dart';
import 'package:schedule/pages/function/pages/function_exam_plan/view.dart';
import 'package:schedule/pages/function/pages/function_score/view.dart';
import 'package:schedule/pages/function/pages/function_social_exams/view.dart';
import 'package:schedule/pages/function/pages/function_teacher/view.dart';
import 'package:schedule/pages/function/view.dart';
import 'package:schedule/pages/login/view.dart';

import '../camera/view.dart';

class FunctionRouteConfig {
  static const String empty = "/";
  static const String main = "/main";
  static const String functionScore = '/functionScore';
  static const String functionAllCourse = '/functionAllCourse';
  static const String functionLearnThrough = '/functionLearnThrough';
  static const String functionDrink = '/functionDrink';
  static const String functionSocialExams = '/functionSocialExams';
  static const String functionEmptyClassroom = '/functionEmptyClassroom';
  static const String functionTeacher = '/functionTeacher';
  static const String functionExamPlan = '/functionExamPlan';
  static const String login = '/login';
  static const String camera = '/camera';

  static Route? onGenerateRoute(RouteSettings settings) {
    Map<String, GetPageRoute> getPages = {
      empty: GetPageRoute(
        page: () => Container(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      main: GetPageRoute(
        page: () => FunctionMainPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionScore: GetPageRoute(
        page: () => FunctionScorePage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionSocialExams: GetPageRoute(
        page: () => FunctionSocialExamsPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionAllCourse: GetPageRoute(
        page: () => FunctionAllCoursePage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionEmptyClassroom: GetPageRoute(
        page: () => FunctionEmptyClassroomPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionExamPlan: GetPageRoute(
        page: () => FunctionExamPlanPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionTeacher: GetPageRoute(
        page: () => FunctionTeacherPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      functionDrink: GetPageRoute(
        page: () => FunctionDrinkPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      login: GetPageRoute(
        page: () => const LoginPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      camera: GetPageRoute(
        page: () => CameraPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
    };

    return getPages[settings.name];
  }
}
