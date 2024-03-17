import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
import 'package:schedule/pages/appMain/AppMainView.dart';
import 'package:schedule/pages/login/LoginView.dart';
import 'package:schedule/pages/splash/SplashView.dart';

class GoRouteConfig {
  static const String splash = '/splash';
  static const String appMain = '/appMain';
  static const String login = '/login';

  static BuildContext? context;

  // 数据存储器
  static final _storage= DataStorageManager();

  static final _router = GoRouter(
    initialLocation: appMain,
    redirect: (context, state) {
      if(state.fullPath == splash) {
        return splash;
      }

      String? settings = _storage.getString("settings");
      if (settings == null) {
        return login;
      }

      Map<String, dynamic> settingsMap = jsonDecode(settings);
      if (settingsMap["isLogin"] != true) {
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
    ],
  );

  static GoRouter get router => _router;

  static set setContext(BuildContext context) {
    GoRouteConfig.context = context;
  }
}
