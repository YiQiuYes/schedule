import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../function/view.dart';
import '../login/view.dart';
import '../person/view.dart';
import '../schedule/view.dart';
import 'logic.dart';

class AppMainRouteConfig {
  static const String main = "/";
  static const String login = "/login";

  static Route? onGenerateRoute(RouteSettings settings) {
    Map<String, GetPageRoute> getPages = {
      main: GetPageRoute(
        page: () {
          return GetBuilder<AppMainLogic>(builder: (logic) {
            return PageView(
              controller: logic.state.mainTabController,
              scrollDirection: logic.state.orientation.value
                  ? Axis.horizontal
                  : Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                SchedulePage(),
                FunctionPage(),
                PersonPage(),
              ],
            );
          });
        },
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
    };

    return getPages[settings.name];
  }
}
