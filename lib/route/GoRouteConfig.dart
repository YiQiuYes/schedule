import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/appMain/AppMainView.dart';
import 'package:schedule/pages/login/LoginView.dart';
import 'package:schedule/pages/setting/SettingView.dart';
import 'package:schedule/pages/setting/SettingViewModel.dart';
import 'package:schedule/pages/splash/SplashView.dart';

class GoRouteConfig {
  static const String splash = '/splash';
  static const String appMain = '/appMain';
  static const String login = '/login';
  static const String setting = '/setting';

  static late BuildContext _context;

  static final _router = GoRouter(
    initialLocation: splash,
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
    ],
  );

  static GoRouter get router => _router;

  static BuildContext get context => _context;

  static set _setContext(BuildContext context) {
    _context = context;
    FToast().init(context);
  }
}
