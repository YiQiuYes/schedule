import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/utils/package_info_utils.dart';
import '../../../common/utils/screen_utils.dart';
import '../../../generated/l10n.dart';
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
      String title, String subtitle, IconData icon, Function? onTap) {
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
    );
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
    return listTileWidget(
        S.of(context).setting_about_application,
        S.of(context).setting_about_application_name,
        Icons.person_rounded, () {
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
