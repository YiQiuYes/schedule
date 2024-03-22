import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/pages/setting/SettingViewModel.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingViewModel settingViewModel = SettingViewModel();

  final _screen = ScreenAdaptor();

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
                    // 关于文本
                    _getGroupText(context, S.of(context).settingViewGroupAbout),
                    // 获取版本更新
                    _getVersionUpdate(context),
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
        left: ScreenAdaptor().getLengthByOrientation(
          vertical: 35.w,
          horizon: 20.w,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: ScreenAdaptor().getLengthByOrientation(
            vertical: 25.sp,
            horizon: 20.sp,
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
      leading: const Icon(Icons.update_rounded),
      title: Text(S.of(context).settingViewUpdateMainTest),
      subtitle: Text(
        S.of(context).settingViewCurrentVersion(settingViewModel.getVersion()),
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
}

