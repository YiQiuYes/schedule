import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';

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
          final state = Get.find<AppMainLogic>().state;
          return Obx(() {
            return PageView(
              controller: state.mainTabController,
              scrollDirection:
                  state.orientation.value ? Axis.horizontal : Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SchedulePage(),
                FunctionPage(),
                PersonPage(),
              ],
            );
          });
        },
      ),
      login: GetPageRoute(
        page: () => const LoginPage(),
      ),
    };

    return getPages[settings.name];
  }
}
