import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/global_logic.dart';
import 'package:schedule/pages/app_main/logic.dart';
import 'package:schedule/pages/function/function_route_config.dart';

import '../../common/utils/screen_utils.dart';
import '../../generated/l10n.dart';
import 'logic.dart';

class FunctionMainPage extends StatelessWidget {
  FunctionMainPage({super.key});

  final logic = Get.put(FunctionLogic());
  final state = Get.find<FunctionLogic>().state;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // 课表区域
        functionAreaTitle(S.of(context).function_area_name),
        // 课表区域列表
        functionScheduleCardList(),
        // 生活助手
        SliverPadding(
          padding: EdgeInsets.only(
            top: ScreenUtils.length(vertical: 25.w, horizon: 20.w),
          ),
          sliver: functionAreaTitle(
              S.of(context).function_life_assistant_area_name),
        ),
        // 生活助手区域列表
        functionLifeAssistantCardList(),
      ],
    );
  }

  /// 课表区域列表
  Widget functionScheduleCardList() {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
        right: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
        top: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
      ),
      sliver: SliverAlignedGrid.count(
        crossAxisCount:
            ScreenUtils.byOrientationReturn(vertical: 5, horizon: 5)!,
        itemCount: state.functionScheduleCardList.length,
        crossAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 7.w),
        mainAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 7.w),
        itemBuilder: (context, index) {
          return functionCardBtn(
            context,
            state.functionScheduleCardList[index]['title'],
            state.functionScheduleCardList[index]['icon'],
            state.functionScheduleCardList[index]['route'],
          );
        },
      ),
    );
  }

  /// 生活助手区域列表
  Widget functionLifeAssistantCardList() {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
        right: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
        top: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
      ),
      sliver: SliverAlignedGrid.count(
        crossAxisCount:
            ScreenUtils.byOrientationReturn(vertical: 5, horizon: 5)!,
        itemCount: state.functionLifeAssistantCardList.length,
        crossAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 7.w),
        mainAxisSpacing: ScreenUtils.length(vertical: 10.w, horizon: 7.w),
        itemBuilder: (context, index) {
          return functionCardBtn(
            context,
            state.functionLifeAssistantCardList[index]['title'],
            state.functionLifeAssistantCardList[index]['icon'],
            state.functionLifeAssistantCardList[index]['route'],
          );
        },
      ),
    );
  }

  /// 获取功能区域按钮
  Widget functionCardBtn(
      BuildContext context, String title, IconData icon, String route) {
    return ElevatedButton(
      onPressed: () {
        final appMainLogic = Get.find<AppMainLogic>().state;

        if (appMainLogic.orientation.value) {
          Get.toNamed(route, id: 2);
        } else {
          Get.offNamed(route, id: 3);
        }
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ScreenUtils.length(vertical: 20.w, horizon: 8.w),
            ),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            vertical: ScreenUtils.length(vertical: 17.w, horizon: 6.w),
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: ScreenUtils.length(vertical: 50.w, horizon: 15.w),
            color: Theme.of(context).colorScheme.primary,
          ),
          // 间距
          SizedBox(
            height: ScreenUtils.length(vertical: 10.w, horizon: 2.w),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 20.sp, horizon: 7.sp),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能区域标题
  Widget functionAreaTitle(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: ScreenUtils.length(vertical: 25.w, horizon: 5.w),
          left: ScreenUtils.length(vertical: 20.w, horizon: 15.w),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 13.sp),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FunctionPage extends StatelessWidget {
  const FunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtils.byOrientationReturn(
        vertical: navigatorWidget(),
        horizon: Row(
          children: [
            Expanded(
              flex: 1,
              child: FunctionMainPage(),
            ),
            Expanded(
              flex: 1,
              child: navigatorWidget(),
            ),
            SizedBox(
              width: ScreenUtils.length(vertical: 0, horizon: 70.w),
            )
          ],
        ),
      )!,
    );
  }

  /// 嵌套导航
  Widget navigatorWidget() {
    return GetBuilder<AppMainLogic>(
      builder: (logic) {
        // true 为竖屏
        if (logic.state.orientation.value) {
          return Navigator(
            key: Get.nestedKey(2),
            initialRoute: FunctionRouteConfig.main,
            onGenerateRoute: (settings) {
              return FunctionRouteConfig.onGenerateRoute(settings);
            },
          );
        } else {
          return Navigator(
            key: Get.nestedKey(3),
            initialRoute: FunctionRouteConfig.empty,
            onGenerateRoute: (settings) {
              return FunctionRouteConfig.onGenerateRoute(settings);
            },
          );
        }
      },
    );
  }
}
