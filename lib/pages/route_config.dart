import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:schedule/pages/app_main/view.dart';
import 'package:schedule/pages/splash/view.dart';

class RouteConfig {
  static const String appMain = "/appMain";
  static const String splash = "/splash";

  static final List<GetPage> getPages = [
    GetPage(
      name: appMain,
      page: () => const AppMainPage(),
    ),
    GetPage(
      name: splash,
      page: () => const SplashPage(),
    ),
  ];
}
