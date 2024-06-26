import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/appMain/AppMainView.dart';
import 'package:schedule/pages/function/functionChild/function798/function798View.dart';
import 'package:schedule/pages/function/functionChild/functionEmptyClassroom/FunctionEmptyClassroomView.dart';
import 'package:schedule/pages/function/functionChild/functionExam/functionExamView.dart';
import 'package:schedule/pages/function/functionChild/functionLearnThrough/LearnThroughView.dart';
import 'package:schedule/pages/function/functionChild/functionSocialExams/FunctionSocialExamsView.dart';
import 'package:schedule/pages/function/functionChild/functionTeacher/FunctionTeacherView.dart';
import 'package:schedule/pages/login/LoginView.dart';
import 'package:schedule/pages/setting/SettingView.dart';
import 'package:schedule/pages/splash/SplashView.dart';

import '../pages/camera/CameraView.dart';
import '../pages/setting/colorTheme/ColorThemeView.dart';
import '../pages/function/functionChild/functionAllCourse/functionAllCourseView.dart';
import '../pages/function/functionChild/functionScore/FunctionScoreView.dart';

class GoRouteConfig {
  static const String splash = '/splash';
  static const String appMain = '/appMain';
  static const String login = '/login';
  static const String setting = '/setting';
  static const String colorTheme = '/colorTheme';
  static const String functionScore = '/functionScore';
  static const String functionAllCourse = '/functionAllCourse';
  static const String functionLearnThrough = '/functionLearnThrough';
  static const String function798 = '/function798';
  static const String functionSocialExams = '/functionSocialExams';
  static const String functionEmptyClassroom = '/functionEmptyClassroom';
  static const String functionTeacher = '/functionTeacher';
  static const String functionExam = '/functionExam';
  static const String camera = '/camera';

  static late BuildContext _context;

  static final _router = GoRouter(
    initialLocation: splash,
    // initialExtra: {"type": CameraType.desktop, "appBarTitle": "拍照"},
    redirect: (context, state) {
      if (state.fullPath == splash) {
        return splash;
      }

      bool isLogin = globalModel.settings["isLogin"];
      if (!isLogin) {
        return login;
      }
      return state.fullPath;
    },
    routes: [
      GoRoute(
        name: 'splash',
        path: splash,
        builder: (context, state) {
          _setContext = context;
          return const SplashView();
        },
      ),
      GoRoute(
        name: 'appMain',
        path: appMain,
        builder: (context, state) {
          _setContext = context;
          return const AppMainView();
        },
      ),
      GoRoute(
        name: 'login',
        path: login,
        builder: (context, state) {
          _setContext = context;
          return const LoginView();
        },
      ),
      GoRoute(
        name: 'setting',
        path: setting,
        builder: (context, state) {
          _setContext = context;
          return const SettingView();
        },
      ),
      GoRoute(
        name: 'colorTheme',
        path: colorTheme,
        builder: (context, state) {
          _setContext = context;
          return const ColorThemeView();
        },
      ),
      GoRoute(
        name: 'functionScore',
        path: functionScore,
        builder: (context, state) {
          _setContext = context;
          return const FunctionScoreView();
        },
      ),
      GoRoute(
        name: 'functionAllCourse',
        path: functionAllCourse,
        builder: (context, state) {
          _setContext = context;
          return const FunctionAllCourseView();
        },
      ),
      GoRoute(
        name: 'functionLearnThrough',
        path: functionLearnThrough,
        builder: (context, state) {
          _setContext = context;
          return const LearnThroughView();
        },
      ),
      GoRoute(
        name: 'function798',
        path: function798,
        builder: (context, state) {
          _setContext = context;
          return const Function798View();
        },
      ),
      GoRoute(
        name: 'functionSocialExams',
        path: functionSocialExams,
        builder: (context, state) {
          _setContext = context;
          return const FunctionSocialExamsView();
        },
      ),
      GoRoute(
        name: 'functionEmptyClassroom',
        path: functionEmptyClassroom,
        builder: (context, state) {
          _setContext = context;
          return const FunctionEmptyClassroomView();
        },
      ),
      GoRoute(
        name: 'functionTeacher',
        path: functionTeacher,
        builder: (context, state) {
          _setContext = context;
          return const FunctionTeacherView();
        },
      ),
      GoRoute(
        name: 'functionExam',
        path: functionExam,
        builder: (context, state) {
          _setContext = context;
          return const FunctionExamView();
        },
      ),
      GoRoute(
        name: 'camera',
        path: camera,
        builder: (context, state) {
          _setContext = context;
          return CameraView(
            type: (state.extra as Map)["type"],
            appBarTitle: (state.extra as Map)["appBarTitle"],
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;

  static BuildContext get context => _context;

  static set _setContext(BuildContext context) {
    _context = context;
    FToast().init(context);
  }
}
