import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/pages/appMain/AppMainViewModel.dart';
import 'package:schedule/pages/function/FunctionView.dart';
import 'package:schedule/pages/person/PersonView.dart';
import 'package:schedule/pages/schedule/ScheduleView.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class AppMainView extends StatefulWidget {
  const AppMainView({super.key});

  @override
  State<AppMainView> createState() => _AppMainViewState();
}

class _AppMainViewState extends State<AppMainView>
    with TickerProviderStateMixin {
  final _screenAdaptor = ScreenAdaptor();
  final _scheduleViewModel = AppMainViewModel();

  @override
  void initState() {
    super.initState();
    // 设置tabbar控制器
    _scheduleViewModel.setTabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // 销毁控制器
    _scheduleViewModel.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppMainViewModel>.value(
      value: _scheduleViewModel,
      child: Scaffold(
        primary: false,
        body: Row(
          children: [
            // 侧边导航栏
            _getNavigationRail(),
            // 主页面
            Expanded(
              child: _getMainPage(),
            ),
          ],
        ),
        // 底部导航栏
        bottomNavigationBar: _getBottomNavigationBar(),
      ),
    );
  }

  /// 获取主页面
  Widget _getMainPage() {
    return SafeArea(
      left: false,
      bottom: false,
      child: Consumer<AppMainViewModel>(builder: (context, model, child) {
        return TabBarView(
          controller: model.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ScheduleView(),
            FunctionView(),
            PersonView(),
          ],
        );
      }),
    );
  }

  /// 获取侧边导航栏
  Widget _getNavigationRail() {
    return _screenAdaptor.byOrientationReturn(
      vertical: const SizedBox(),
      horizon: Consumer<AppMainViewModel>(builder: (context, model, child) {
        return NavigationRail(
          groupAlignment: -0.95,
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.article_outlined),
              label: Text(S.of(context).navigationSchedule),
              selectedIcon: const Icon(Icons.article_rounded),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.explore_outlined),
              label: Text(S.of(context).navigationFunction),
              selectedIcon: const Icon(Icons.explore_rounded),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.person),
              label: Text(S.of(context).navigationPerson),
              selectedIcon: const Icon(Icons.person),
            ),
          ],
          selectedIndex: model.navigateCurrentIndex,
          onDestinationSelected: model.setNavigateCurrentIndex,
          labelType: NavigationRailLabelType.selected,
        );
      }),
    )!;
  }

  /// 获取底部导航栏
  Widget? _getBottomNavigationBar() {
    return _screenAdaptor.byOrientationReturn(
      vertical: Consumer<AppMainViewModel>(
        builder: (context, model, child) {
          return NavigationBar(
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.article_outlined),
                selectedIcon: const Icon(Icons.article_rounded),
                label: S.of(context).navigationSchedule,
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore_rounded),
                label: S.of(context).navigationFunction,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: S.of(context).navigationPerson,
              ),
            ],
            selectedIndex: model.navigateCurrentIndex,
            onDestinationSelected: model.setNavigateCurrentIndex,
          );
        },
      ),
      horizon: null,
    );
  }
}
