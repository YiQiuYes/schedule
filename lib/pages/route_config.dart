import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schedule/pages/app_main/view.dart';
import 'package:schedule/pages/login/view.dart';
import 'package:schedule/pages/person/view.dart';
import 'package:schedule/pages/schedule/view.dart';

import 'function/view.dart';

class RouteConfig {
  static const String appMain = "/appMain";
  static const String login = "/login";
  static const String schedule = "/schedule";
  static const String function = "/function";
  static const String person = "/person";

  static final List<GetPage> getPages = [
    GetPage(
      name: appMain,
      page: () => const AppMainPage(),
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: schedule,
      page: () => SchedulePage(),
    ),
    GetPage(
      name: function,
      page: () => FunctionPage(),
    ),
    GetPage(
      name: person,
      page: () => PersonPage(),
    ),
  ];
}
