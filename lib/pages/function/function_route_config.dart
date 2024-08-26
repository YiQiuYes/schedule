import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/pages/function/pages/function_score/view.dart';
import 'package:schedule/pages/function/view.dart';

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
  static const String functionExam = '/functionExam';

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
    };

    return getPages[settings.name];
  }
}