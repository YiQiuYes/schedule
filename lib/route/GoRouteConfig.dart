import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
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

  static BuildContext? context;

  // settingViewModel
  static final _settingViewModel = SettingViewModel();

  static final _router = GoRouter(
    initialLocation: appMain,
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
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        name: 'appMain',
        path: appMain,
        builder: (context, state) => const AppMainView(),
      ),
      GoRoute(
        name: 'login',
        path: login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: 'setting',
        path: setting,
        builder: (context, state) => SettingView(
          settingViewModel: _settingViewModel,
        ),
      ),
    ],
  );

  static GoRouter get router => _router;

  static set setContext(BuildContext context) {
    GoRouteConfig.context = context;
    FToast().init(context);
  }
}
