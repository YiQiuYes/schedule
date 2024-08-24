import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';
import 'package:schedule/pages/schedule/view.dart';

import '../../generated/l10n.dart';
import '../function/view.dart';
import '../person/view.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtils.byOrientationReturn(
        vertical: const SizedBox(),
        horizon: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            _navigationRailWidget(),
            Expanded(
              flex: 9,
              child: _mainWidget(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _navigationWidget(),
    );
  }

  // 主展示页面
  Widget _mainWidget() {
    return PageView(
      controller: state.mainTabController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SchedulePage(),
        FunctionPage(),
        PersonPage(),
      ],
    );
  }

  // 底部导航栏
  Widget? _navigationWidget() {
    return ScreenUtils.byOrientationReturn(
      vertical: Obx(() {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.article_outlined),
              selectedIcon: const Icon(Icons.article_rounded),
              label: S.current.schedule,
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore_rounded),
              label: S.current.function,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: S.current.person,
            ),
          ],
          selectedIndex: state.navigateCurrentIndex.value,
          onDestinationSelected: (int index) {
            logic.setNavigateCurrentIndex(index);
          },
        );
      }),
      horizon: null,
    );
  }

  // 侧边导航栏
  Widget _navigationRailWidget() {
    return Obx(() {
      return NavigationRail(
        groupAlignment: 0,
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.article_outlined),
            label: Text(S.current.schedule),
            selectedIcon: const Icon(Icons.article_rounded),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.explore_outlined),
            label: Text(S.current.function),
            selectedIcon: const Icon(Icons.explore_rounded),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.person),
            label: Text(S.current.person),
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
