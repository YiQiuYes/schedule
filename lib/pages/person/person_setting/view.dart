import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/widget/my_popup_menu/my_popup_menu.dart';
import 'package:schedule/global_logic.dart';
import 'package:schedule/pages/person/person_route_config.dart';

import '../../../common/utils/package_info_utils.dart';
import '../../../common/utils/screen_utils.dart';
import '../../../generated/l10n.dart';
import '../../app_main/logic.dart';
import 'logic.dart';

class PersonSettingPage extends StatelessWidget {
  PersonSettingPage({super.key});

  final logic = Get.put(PersonSettingLogic());
  final state = Get.find<PersonSettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).setting_title),
      ),
      body: ListView(
        children: [
          // 界面文本
          groupTextWidget(context, S.of(context).setting_group_interface),
          // 深浅色主题模式
          themeSettingWidget(context),
          // 是否支持莫奈取色
          switchMonetColorWidget(context),
          // 选择主题
          choiceThemeColorWidget(context),
          // 关于文本
          groupTextWidget(context, S.of(context).setting_group_about),
          // 获取版本更新
          versionUpdateWidget(context),
          // 关于应用
          aboutApplicationDialogWidget(context),
        ],
      ),
    );
  }

  /// 获取项组文本
  Widget groupTextWidget(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 35.w, horizon: 20.w),
        top: ScreenUtils.length(vertical: 20.w, horizon: 10.w),
        bottom: ScreenUtils.length(vertical: 10.w, horizon: 10.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: ScreenUtils.length(vertical: 25.sp, horizon: 9.sp),
        ),
      ),
    );
  }

  /// 获取ListTile
  Widget listTileWidget(
      String title, String subtitle, IconData icon, Function? onTap,
      {Widget? trailing}) {
    return ListTile(
      onTap: onTap == null ? null : () => onTap(),
      contentPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 35.w, horizon: 20.w),
      ),
      leading: Icon(
        icon,
        size: ScreenUtils.length(vertical: 38.w, horizon: 15.w),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 11.sp),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 9.sp),
        ),
      ),
      trailing: trailing,
    );
  }

  /// 获取深浅色主题模式
  Widget themeSettingWidget(BuildContext context) {
    return GetBuilder<GlobalLogic>(builder: (globalLogic) {
      return MyPopupMenuButton(
        tooltip: S.of(context).setting_interface_theme,
        initialValue: globalLogic.state.settings["theme"],
        position: PopupMenuPosition.under,
        onSelected: (value) {
          globalLogic.setThemeMode(value);
        },
        offset: Offset(ScreenUtils.length(vertical: 100.w, horizon: 60.w), 0),
        itemBuilder: (context) {
          List<PopupMenuEntry> widget = [];
          logic.getThemesMap().forEach((key, value) {
            widget.add(
              PopupMenuItem(
                value: key,
                child: Text(value),
              ),
            );
          });
          return widget;
        },
        child: listTileWidget(
          S.of(context).setting_interface_theme,
          logic.getThemesMap()[globalLogic.state.settings["themeMode"]]!,
          Icons.dark_mode_rounded,
          null,
        ),
      );
    });
  }

  /// 选择主题
  Widget choiceThemeColorWidget(BuildContext context) {
    return listTileWidget(
      S.of(context).setting_choice_color_theme,
      S.of(context).setting_choice_color_sub_title,
      Icons.palette_rounded,
      () {
        final appMainLogic = Get.find<AppMainLogic>().state;

        if (appMainLogic.orientation.value) {
          Get.toNamed(PersonRouteConfig.colorTheme, id: 4);
        } else {
          Get.toNamed(PersonRouteConfig.colorTheme, id: 5);
        }
      },
    );
  }

  /// 获取是否支持莫奈取色
  Widget switchMonetColorWidget(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      // 不支持莫奈取色则返回空组件
      if (lightDynamic == null || darkDynamic == null) {
        return const SizedBox();
      }

      return GetBuilder<GlobalLogic>(builder: (globalLogic) {
        return listTileWidget(
          S.of(context).setting_switch_monet_color,
          S.of(context).setting_switch_monet_color_sub,
          Icons.colorize_rounded,
          () {
            globalLogic
                .setMonetColor(!globalLogic.state.settings["isMonetColor"]);
          },
          trailing: Switch(
            value: globalLogic.state.settings["isMonetColor"],
            onChanged: (value) {
              globalLogic
                  .setMonetColor(!globalLogic.state.settings["isMonetColor"]);
            },
          ),
        );
      });
    });
  }

  /// 获取版本更新
  Widget versionUpdateWidget(BuildContext context) {
    return listTileWidget(
        S.of(context).setting_update_main_text,
        S.of(context).setting_current_version(logic.getVersion()),
        Icons.update_rounded, () {
      logic.updateVersion(
          newVersionDialogBuilder: _getNewVersionDialog,
          lastVersionDialogBuilder: lastVersionDialogWidget);
    });
  }

  /// 有新版本弹窗builder构造函数
  Widget _getNewVersionDialog(BuildContext context, String info, String url) {
    return AlertDialog(
      title: Text(S.of(context).setting_update_main_text),
      content: Text(info),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).update_dialog_cancel),
        ),
        TextButton(
          onPressed: () {
            Get.snackbar(
              S.of(context).snackbar_tip,
              S.of(context).update_dialog_snackbar_vpn,
              backgroundColor:
                  Theme.of(Get.context!).colorScheme.primaryContainer,
              margin: EdgeInsets.only(
                top: 30.w,
                left: 50.w,
                right: 50.w,
              ),
            );
            // 跳转到浏览器
            logic.jumpBrowser(url);
          },
          child: Text(S.of(context).update_dialog_confirm),
        ),
      ],
    );
  }

  /// 当前已是最新版本弹窗builder构造函数
  Widget lastVersionDialogWidget(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).setting_update_main_text),
      content: Text(S.of(context).update_dialog_current_is_last_version),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(S.of(context).update_dialog_confirm),
        ),
      ],
    );
  }

  /// 关于应用弹窗
  Widget aboutApplicationDialogWidget(BuildContext context) {
    return listTileWidget(S.of(context).setting_about_application,
        S.of(context).setting_about_application_name, Icons.person_rounded, () {
      showAboutDialog(
        context: context,
        applicationName: S.of(context).setting_about_application_name,
        applicationIcon: Image.asset(
          "lib/assets/images/logo.png",
          width: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
          height: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
        ),
        applicationVersion: "v${PackageInfoUtils.version}",
        applicationLegalese: "2024-3-17",
      );
    });
  }
}
