import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/components/MyPopupMenuButton.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/setting/SettingViewModel.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../common/utils/PackageInfoUtils.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingViewModel settingViewModel = SettingViewModel();

  final _screen = ScreenAdaptor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: settingViewModel,
      child: Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                SliverList.list(
                  children: [
                    // 语言文本
                    _getGroupText(
                        context, S.of(context).settingViewGroupLanguage),
                    // 语言设置
                    _getLanguageSetting(context),
                    // 关于文本
                    _getGroupText(context, S.of(context).settingViewGroupAbout),
                    // 获取版本更新
                    _getVersionUpdate(context),
                    // 关于应用
                    _getAboutApplicationDialog(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 获取SliverAppBar
  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: _screen.getLengthByOrientation(
        vertical: 150.w,
        horizon: 55.w,
      ),
      pinned: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          S.of(context).settingViewTitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 38.sp,
              horizon: 20.sp,
            ),
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  /// 获取项组文本
  Widget _getGroupText(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: _screen.getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
        top: _screen.getLengthByOrientation(
          vertical: 20.w,
          horizon: 10.w,
        ),
        bottom: _screen.getLengthByOrientation(
          vertical: 10.w,
          horizon: 10.w,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: ScreenAdaptor().getLengthByOrientation(
            vertical: 25.sp,
            horizon: 17.sp,
          ),
        ),
      ),
    );
  }

  /// 获取版本更新
  Widget _getVersionUpdate(BuildContext context) {
    return ListTile(
      onTap: () {
        settingViewModel.updateVersion(context,
            newVersionDialogBuilder: _getNewVersionDialog,
            lastVersionDialogBuilder: _getLastVersionDialog);
      },
      contentPadding: EdgeInsets.only(
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
      ),
      leading: Icon(
        Icons.update_rounded,
        size: _screen.getLengthByOrientation(
          vertical: 38.w,
          horizon: 22.w,
        ),
      ),
      title: Text(
        S.of(context).settingViewUpdateMainTest,
        style: TextStyle(
          fontSize: _screen.getLengthByOrientation(
            vertical: 32.sp,
            horizon: 17.sp,
          ),
        ),
      ),
      subtitle: Text(
        S.of(context).settingCurrentVersion(settingViewModel.getVersion()),
        style: TextStyle(
          fontSize: _screen.getLengthByOrientation(
            vertical: 26.sp,
            horizon: 15.sp,
          ),
        ),
      ),
    );
  }

  /// 有新版本弹窗builder构造函数
  Widget _getNewVersionDialog(BuildContext context, String info, String url) {
    return AlertDialog(
      title: Text(S.of(context).settingViewUpdateMainTest),
      content: Text(info),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).updateDialogCancel),
        ),
        TextButton(
          onPressed: () {
            // 跳转到浏览器
            settingViewModel.jumpBrowser(url);
          },
          child: Text(S.of(context).updateDialogConfirm),
        ),
      ],
    );
  }

  /// 当前已是最新版本弹窗builder构造函数
  Widget _getLastVersionDialog(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).settingViewUpdateMainTest),
      content: Text(S.of(context).updateDialogCurrentIsLastVersion),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).updateDialogConfirm),
        ),
      ],
    );
  }

  /// 获取语言设置
  Widget _getLanguageSetting(BuildContext context) {
    return Consumer<GlobalModel>(builder: (context, model, child) {
      return MyPopupMenuButton(
        tooltip: S.of(context).settingViewSwitchLanguageTip,
        initialValue: globalModel.settings["language"],
        position: PopupMenuPosition.under,
        onSelected: (value) {
          settingViewModel.setLanguageByKey(value);
        },
        offset: Offset(
          _screen.getLengthByOrientation(
            vertical: 100.w,
            horizon: 60.w,
          ),
          0,
        ),
        itemBuilder: (context) {
          List<PopupMenuEntry> widget = [];
          settingViewModel.getLanguagesMap().forEach((key, value) {
            widget.add(
              PopupMenuItem(
                value: key,
                child: Text(value),
              ),
            );
          });
          return widget;
        },
        child: ListTile(
          contentPadding: EdgeInsets.only(
            left: ScreenAdaptor().getLengthByOrientation(
              vertical: 35.w,
              horizon: 20.w,
            ),
          ),
          leading: Icon(
            Icons.language_rounded,
            size: _screen.getLengthByOrientation(
              vertical: 38.w,
              horizon: 22.w,
            ),
          ),
          title: Text(
            S.of(context).settingViewGroupLanguage,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 32.sp,
                horizon: 17.sp,
              ),
            ),
          ),
          subtitle: Text(
            settingViewModel
                .getLanguagesMap()[globalModel.settings["language"]]!,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 26.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// 关于应用弹窗
  Widget _getAboutApplicationDialog(BuildContext context) {
    return ListTile(
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: S.of(context).settingViewAboutApplicationName,
          applicationIcon: Image.asset(
            "lib/assets/images/logo.png",
            width: _screen.getLengthByOrientation(
              vertical: 50.w,
              horizon: 30.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 50.w,
              horizon: 30.w,
            ),
          ),
          applicationVersion: PackageInfoUtils.version,
          applicationLegalese: "2024-3-17",
        );
      },
      contentPadding: EdgeInsets.only(
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
      ),
      leading: Icon(
        Icons.person_rounded,
        size: _screen.getLengthByOrientation(
          vertical: 38.w,
          horizon: 22.w,
        ),
      ),
      title: Text(
        S.of(context).settingViewAboutApplication,
        style: TextStyle(
          fontSize: _screen.getLengthByOrientation(
            vertical: 32.sp,
            horizon: 17.sp,
          ),
        ),
      ),
      subtitle: Text(
        S.of(context).settingViewAboutApplicationName,
        style: TextStyle(
          fontSize: _screen.getLengthByOrientation(
            vertical: 26.sp,
            horizon: 15.sp,
          ),
        ),
      ),
    );
  }
}
