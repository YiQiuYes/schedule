import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';
import 'package:schedule/global_logic.dart';
import 'package:schedule/pages/app_main/app_main_route_config.dart';

import '../../generated/l10n.dart';
import 'logic.dart';

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage>
    with TickerProviderStateMixin {
  final logic = Get.put(AppMainLogic());
  final state = Get.find<AppMainLogic>().state;

  @override
  void initState() {
    super.initState();
    // 初始化主页面控制器
    logic.initMainTabController(this);
    // 自动登录教务系统
    logic.autoLoginEducationalSystem(context);
  }

  @override
  void dispose() {
    state.mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logic.refreshOrientation();

    return Scaffold(
      body: ScreenUtils.byOrientationReturn(
        vertical: navigatorWidget(),
        horizon: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GetBuilder<GlobalLogic>(builder: (logic) {
              return Visibility(
                visible: logic.state.settings["isLogin"],
                child: SizedBox(
                  width: ScreenUtils.screenWidth * 2 / 11,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _navigationRailWidget(),
                    ],
                  ),
                ),
              );
            }),
            Expanded(
              child: navigatorWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navigationWidget(),
    );
  }

  /// 嵌套导航
  Widget navigatorWidget() {
    return Navigator(
      key: Get.nestedKey(1),
      initialRoute: AppMainRouteConfig.main,
      onGenerateRoute: (settings) {
        return AppMainRouteConfig.onGenerateRoute(settings);
      },
    );
  }

  /// 底部导航栏
  Widget? _navigationWidget() {
    return ScreenUtils.byOrientationReturn(
      vertical: GetBuilder<GlobalLogic>(builder: (globalLogic) {
        return Visibility(
          visible: globalLogic.state.settings["isLogin"],
          child: Obx(() {
            return NavigationBar(
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.article_outlined),
                  selectedIcon: const Icon(Icons.article_rounded),
                  label: S.current.app_main_schedule,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.explore_outlined),
                  selectedIcon: const Icon(Icons.explore_rounded),
                  label: S.current.app_main_function,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: S.current.app_main_person,
                ),
              ],
              selectedIndex: state.navigateCurrentIndex.value,
              onDestinationSelected: (int index) {
                logic.setNavigateCurrentIndex(index);
              },
            );
          }),
        );
      }),
      horizon: null,
    );
  }

  /// 侧边导航栏
  Widget _navigationRailWidget() {
    return Obx(() {
      return NavigationRail(
        groupAlignment: 0,
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.article_outlined),
            label: Text(S.current.app_main_schedule),
            selectedIcon: const Icon(Icons.article_rounded),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.explore_outlined),
            label: Text(S.current.app_main_function),
            selectedIcon: const Icon(Icons.explore_rounded),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.person),
            label: Text(S.current.app_main_person),
            selectedIcon: const Icon(Icons.person),
          ),
        ],
        selectedIndex: state.navigateCurrentIndex.value,
        onDestinationSelected: (int index) {
          logic.setNavigateCurrentIndex(index);
        },
      );
    });
  }
}
