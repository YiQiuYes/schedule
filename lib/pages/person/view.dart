import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:schedule/pages/person/person_route_config.dart';

import '../../common/utils/screen_utils.dart';
import '../../generated/l10n.dart';
import '../app_main/logic.dart';
import 'logic.dart';

class PersonMainPage extends StatelessWidget {
  PersonMainPage({super.key});

  final logic = Get.put(PersonLogic());
  final state = Get.find<PersonLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return ListView(
      children: [
        // 获取app图标
        appIconWidget(),
        // 获取学期和开始日期设置行
        semesterAndStartDateWidget(context),
        // 获取设置项
        settingItemWidget(context),
        // 更新方式
        updateMethodWidget(context),
        // 获取交流方式
        contactItemWidget(context),
        // 获取退出登录项
        logoutItemWidget(context),
      ],
    );
  }

  /// 更新方式
  Widget updateMethodWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(
          vertical: 40.w,
          horizon: 25.w,
        ),
      ),
      child: listTileItemWidget(
        onTap: () {
          logic.showUpdateMethod(context);
        },
        title: S.of(context).setting_update_method,
        iconData: Icons.system_update_rounded,
      ),
    );
  }

  /// 获取app图标
  Widget appIconWidget() {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
        bottom: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
      ),
      child: Center(
        child: Lottie.asset(
          "lib/assets/lotties/person.json",
          width: ScreenUtils.length(vertical: 270.w, horizon: 120.w),
          height: ScreenUtils.length(vertical: 270.w, horizon: 120.w),
        ),
      ),
    );
  }

  /// 获取学期和开始日期设置行
  Widget semesterAndStartDateWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(child: SizedBox()),
        // 学期设置
        SizedBox(
          width: ScreenUtils.length(vertical: 290.w, horizon: 100.w),
          child: TextField(
            controller: state.semesterController,
            readOnly: true,
            textAlign: TextAlign.center,
            onTap: () {
              showSemesterList(context);
            },
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 11.sp),
            ),
            decoration: InputDecoration(
              labelText: S.of(context).person_semester_tip,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // 间隔
        SizedBox(
          width: ScreenUtils.length(vertical: 50.w, horizon: 22.w),
        ),
        // 开始日期设置
        SizedBox(
          width: ScreenUtils.length(vertical: 290.w, horizon: 100.w),
          child: TextField(
            controller: state.startDateController,
            readOnly: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 11.sp),
            ),
            decoration: InputDecoration(
              labelText: S.of(context).person_start_day_tip,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTap: () {
              logic.selectStartDate(context, state.startDateController);
            },
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// 学期弹出选择列表
  void showSemesterList(BuildContext context) {
    var adapter = logic.getSemesterPickerData();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [0],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 350.w, horizon: 130.w),
      itemExtent: ScreenUtils.length(vertical: 70.w, horizon: 40.w),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: logic.selectSemesterConfirm,
    );
    picker.showModal(context);
  }

  /// 获取ListTile
  Widget listTileItemWidget({
    Function? onTap,
    IconData? iconData,
    String? title,
  }) {
    return ListTile(
      onTap: () {
        onTap?.call();
      },
      leading: Icon(
        iconData,
        size: ScreenUtils.length(vertical: 34.w, horizon: 15.w),
      ),
      title: Text(
        title ?? "",
        style: TextStyle(
          fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 11.sp),
        ),
      ),
      contentPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 35.w, horizon: 20.w),
      ),
    );
  }

  /// 获取设置项
  Widget settingItemWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(
          vertical: 40.w,
          horizon: 25.w,
        ),
      ),
      child: listTileItemWidget(
        onTap: () {
          final appMainLogic = Get.find<AppMainLogic>().state;

          if (appMainLogic.orientation.value) {
            Get.toNamed(PersonRouteConfig.setting, id: 4);
          } else {
            // 获取当前页面路由
            final currentRoute = Get.currentRoute;
            currentRoute == PersonRouteConfig.empty
                ? Get.toNamed(PersonRouteConfig.setting, id: 5)
                : Get.offNamed(PersonRouteConfig.setting, id: 5);
          }
        },
        title: S.of(context).setting_title,
        iconData: Icons.settings_rounded,
      ),
    );
  }

  /// 获取交流方式
  Widget contactItemWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 40.w, horizon: 25.w),
      ),
      child: listTileItemWidget(
        onTap: () {
          logic.joinQQGroup(context);
        },
        title: S.of(context).person_contact,
        iconData: Icons.contact_support_rounded,
      ),
    );
  }

  /// 获取退出登录项
  Widget logoutItemWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 40.w, horizon: 25.w),
      ),
      child: listTileItemWidget(
        onTap: () {
          logic.logout(context);
        },
        title: S.of(context).person_logout,
        iconData: Icons.logout_rounded,
      ),
    );
  }
}

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtils.byOrientationReturn(
        vertical: navigatorWidget(),
        horizon: Row(
          children: [
            Expanded(
              flex: 1,
              child: PersonMainPage(),
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
            key: Get.nestedKey(4),
            initialRoute: PersonRouteConfig.main,
            onGenerateRoute: (settings) {
              return PersonRouteConfig.onGenerateRoute(settings);
            },
          );
        } else {
          return Navigator(
            key: Get.nestedKey(5),
            initialRoute: PersonRouteConfig.empty,
            onGenerateRoute: (settings) {
              return PersonRouteConfig.onGenerateRoute(settings);
            },
          );
        }
      },
    );
  }
}
