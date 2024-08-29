import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/pages/person/person_setting/view.dart';
import 'package:schedule/pages/person/view.dart';

import 'color_theme/view.dart';

class PersonRouteConfig {
  static const String empty = "/";
  static const String main = "/main";
  static const String setting = "/setting";
  static const String colorTheme = "/colorTheme";

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
        page: () => PersonMainPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      setting: GetPageRoute(
        page: () => PersonSettingPage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
      colorTheme: GetPageRoute(
        page: () => ColorThemePage(),
        settings: RouteSettings(
          name: settings.name,
          arguments: settings.arguments,
        ),
      ),
    };

    return getPages[settings.name];
  }
}
