import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schedule/api/schedule/impl/OtherApiImpl.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/PackageInfoUtils.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/schedule/OtherApi.dart';

class SettingViewModel with ChangeNotifier {
  final OtherApi _otherApi = OtherApiImpl();

  /// 获取版本号
  String getVersion() {
    return PackageInfoUtils.version;
  }

  /// 检查版本更新
  void updateVersion(BuildContext context,
      {required Widget Function(BuildContext context, String info, String url)
          newVersionDialogBuilder,
      required Widget Function(BuildContext context)
          lastVersionDialogBuilder}) {
    // 显示加载动画
    FlutterToastUtil.showLoading(milliseconds: 5000);

    _otherApi.getVersionInfo().then(
      (value) {
        // 关闭加载动画
        FToast().removeQueuedCustomToasts();
        FToast().removeCustomToast();

        if (value['tag_name'] == null) {
          // 获取版本信息失败
          // logger.i("获取版本信息失败");
          FlutterToastUtil.errorToast(S.of(context).updateDialogVersionFail);
          return;
        }

        String version = value['tag_name'].replaceAll("v", "");
        bool isUpdate = PackageInfoUtils.compareVersion(version);

        // logger.i("version: $version, info: $info");
        if (isUpdate) {
          // 有新版本
          // logger.i("有新版本");

          String info = value['body'];
          List assets = value['assets'];
          List<String> downloadUrls = [];
          String downloadUrl = "";

          // 遍历获取下载url
          for (var asset in assets) {
            downloadUrls.add(asset['browser_download_url']);
          }

          // 判断平台
          if (PlatformUtils.isAndroid) {
            for (String url in downloadUrls) {
              if (url.contains("android")) {
                downloadUrl = url;
                break;
              }
            }
          } else if (PlatformUtils.isIOS) {
            for (String url in downloadUrls) {
              if (url.contains("ios")) {
                downloadUrl = url;
                break;
              }
            }
          } else if (PlatformUtils.isWindows) {
            downloadUrl = "https://github.com/YiQiuYes/schedule/releases";
          } else if (PlatformUtils.isMacOS) {
            for (String url in downloadUrls) {
              if (url.contains("macos")) {
                downloadUrl = url;
                break;
              }
            }
          } else if (PlatformUtils.isLinux) {
            downloadUrl = "https://github.com/YiQiuYes/schedule/releases";
          }

          // 弹窗显示
          showDialog(
            context: context,
            builder: (context) {
              return newVersionDialogBuilder(context, info, downloadUrl);
            },
          );
        } else {
          // 当前已是最新版本
          // logger.i("当前已是最新版本");
          // 弹窗显示
          showDialog(
            context: context,
            builder: (context) {
              return lastVersionDialogBuilder(context);
            },
          );
        }
      },
    );
  }

  /// 跳转浏览器
  void jumpBrowser(String url) {
    launchUrl(Uri.parse(url));
  }

  /// 获取语言列表
  Map<String, String> getLanguagesMap() {
    final map = {
      "default" : S.current.settingViewFollowSystem,
      "zh-CN" : "简体中文",
      "en-US" : "English",
    };
    return map;
  }

  /// 设置语言
  void setLanguageByKey(dynamic select) {
    globalModel.setLocale(select);
  }

  /// 获取字体列表
  Map<String, String> getFontsMap() {
    final map = {
      "default" : S.current.settingViewFollowSystem,
      "zhuZiSWan" : S.current.settingViewFontZhuZiSWan,
    };
    return map;
  }

  /// 设置字体
  void setFontByKey(dynamic select) {
    globalModel.setFontFamily(select);
  }

  /// 获取主题列表
  Map<String, String> getThemesMap() {
    final map = {
      "default" : S.current.settingViewFollowSystem,
      "light" : S.current.settingViewThemeLight,
      "dark" : S.current.settingViewThemeDark,
    };
    return map;
  }

  /// 设置主题
  void setThemeByKey(dynamic select) {
    globalModel.setThemeMode(select);
  }
}
