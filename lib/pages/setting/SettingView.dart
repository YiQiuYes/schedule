import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/common/components/myPopupMenuButton/MyPopupMenuButton.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:schedule/pages/setting/SettingViewModel.dart';

import '../../common/utils/PackageInfoUtils.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingViewModel settingViewModel = SettingViewModel();
  late List<Widget> _widgetList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 页面widgetList
    _widgetList = [
      // 界面文本
      _getGroupText(
          context, S.of(context).settingViewGroupInterface),
      // 深浅色主题设置
      _getThemeSetting(context),
      // 选择主题颜色
      _getChoiceThemeColor(context),
      // 字体设置
      _getFontSetting(context),
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
      // 底部安全间距
      _getBottomSafeArea(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: settingViewModel,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                AnimationLimiter(
                  child: SliverList.builder(
                    itemCount: _widgetList.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _widgetList[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 底部安全间距
  Widget _getBottomSafeArea() {
    return SizedBox(
      height: ScreenAdaptor().getLengthByOrientation(
        vertical: 80.h,
        horizon: 150.h,
      ),
    );
  }

  /// 获取SliverAppBar
  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 160.h,
        horizon: 170.h,
      ),
      toolbarHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 60.h,
        horizon: 80.h,
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
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 20.w,
          horizon: 10.w,
        ),
        bottom: ScreenAdaptor().getLengthByOrientation(
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

  /// 获取ListTile
  Widget _getListTile(
      String title, String subtitle, IconData icon, Function? onTap) {
    return ListTile(
      onTap: onTap == null ? null : () => onTap(),
      contentPadding: EdgeInsets.only(
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
      ),
      leading: Icon(
        icon,
        size: ScreenAdaptor().getLengthByOrientation(
          vertical: 38.w,
          horizon: 22.w,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: ScreenAdaptor().getLengthByOrientation(
            vertical: 28.sp,
            horizon: 16.sp,
          ),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: ScreenAdaptor().getLengthByOrientation(
            vertical: 22.sp,
            horizon: 13.sp,
          ),
        ),
      ),
    );
  }

  /// 获取版本更新
  Widget _getVersionUpdate(BuildContext context) {
    return _getListTile(
        S.of(context).settingViewUpdateMainText,
        S.of(context).settingCurrentVersion(settingViewModel.getVersion()),
        Icons.update_rounded, () {
      settingViewModel.updateVersion(context,
          newVersionDialogBuilder: _getNewVersionDialog,
          lastVersionDialogBuilder: _getLastVersionDialog);
    });
  }

  /// 有新版本弹窗builder构造函数
  Widget _getNewVersionDialog(BuildContext context, String info, String url) {
    return AlertDialog(
      title: Text(S.of(context).settingViewUpdateMainText),
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
            FlutterToastUtil.toastNoContent(S.of(context).updateDialogToastDownloadingVPN);
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
      title: Text(S.of(context).settingViewUpdateMainText),
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
          ScreenAdaptor().getLengthByOrientation(
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
        child: _getListTile(
          S.of(context).settingViewGroupLanguage,
          settingViewModel.getLanguagesMap()[globalModel.settings["language"]]!,
          Icons.language_rounded,
          null,
        ),
      );
    });
  }

  /// 关于应用弹窗
  Widget _getAboutApplicationDialog(BuildContext context) {
    return _getListTile(
        S.of(context).settingViewAboutApplication,
        S.of(context).settingViewAboutApplicationName,
        Icons.person_rounded, () {
      showAboutDialog(
        context: context,
        applicationName: S.of(context).settingViewAboutApplicationName,
        applicationIcon: Image.asset(
          "lib/assets/images/logo.png",
          width: ScreenAdaptor().getLengthByOrientation(
            vertical: 50.w,
            horizon: 30.w,
          ),
          height: ScreenAdaptor().getLengthByOrientation(
            vertical: 50.w,
            horizon: 30.w,
          ),
        ),
        applicationVersion: "v${PackageInfoUtils.version}",
        applicationLegalese: "2024-3-17",
      );
    });
  }

  /// 获取界面
  Widget _getFontSetting(BuildContext context) {
    return Consumer<GlobalModel>(builder: (context, model, child) {
      return MyPopupMenuButton(
        tooltip: S.of(context).settingViewInterfaceFont,
        initialValue: globalModel.settings["fontFamily"],
        position: PopupMenuPosition.under,
        onSelected: (value) {
          settingViewModel.setFontByKey(value);
        },
        offset: Offset(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 100.w,
            horizon: 60.w,
          ),
          0,
        ),
        itemBuilder: (context) {
          List<PopupMenuEntry> widget = [];
          settingViewModel.getFontsMap().forEach((key, value) {
            widget.add(
              PopupMenuItem(
                value: key,
                child: Text(value),
              ),
            );
          });
          return widget;
        },
        child: _getListTile(
          S.of(context).settingViewInterfaceFont,
          settingViewModel.getFontsMap()[globalModel.settings["fontFamily"]]!,
          Icons.font_download_rounded,
          null,
        ),
      );
    });
  }

  /// 获取深浅色主题模式
  Widget _getThemeSetting(BuildContext context) {
    return Consumer<GlobalModel>(builder: (context, model, child) {
      return MyPopupMenuButton(
        tooltip: S.of(context).settingViewInterfaceTheme,
        initialValue: globalModel.settings["theme"],
        position: PopupMenuPosition.under,
        onSelected: (value) {
          settingViewModel.setThemeByKey(value);
        },
        offset: Offset(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 100.w,
            horizon: 60.w,
          ),
          0,
        ),
        itemBuilder: (context) {
          List<PopupMenuEntry> widget = [];
          settingViewModel.getThemesMap().forEach((key, value) {
            widget.add(
              PopupMenuItem(
                value: key,
                child: Text(value),
              ),
            );
          });
          return widget;
        },
        child: _getListTile(
          S.of(context).settingViewInterfaceTheme,
          settingViewModel.getThemesMap()[globalModel.settings["themeMode"]]!,
          Icons.dark_mode_rounded,
          null,
        ),
      );
    });
  }

  /// 选择主题
  Widget _getChoiceThemeColor(BuildContext context) {
    return Consumer<GlobalModel>(
      builder: (context, model, child) {
        return _getListTile(
          S.of(context).settingViewChoiceColorTheme,
          S.of(context).settingViewChoiceColorSubTitle,
          Icons.palette_rounded,
          () {
            GoRouter.of(context).push("/colorTheme");
          },
        );
      }
    );
  }
}
