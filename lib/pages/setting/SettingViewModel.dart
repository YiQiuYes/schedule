import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schedule/api/OtherApi.dart';
import 'package:schedule/api/UserApi.dart';
import 'package:schedule/common/manager/RequestManager.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/PackageInfoUtils.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingViewModel with ChangeNotifier {
  final _otherApi = OtherApi();

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

        String version = value['tag_name'].replaceAll("v", "");
        List<String> netSplit = version.split(".");
        List<String> localSplit = PackageInfoUtils.version.split(".");
        bool isUpdate = false;
        for (int i = 0; i < netSplit.length; i++) {
          if (int.parse(netSplit[i]) > int.parse(localSplit[i])) {
            isUpdate = true;
            break;
          } else if (int.parse(netSplit[i]) < int.parse(localSplit[i])) {
            break;
          }
        }

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
              if (url.contains("apk")) {
                downloadUrl = url;
                break;
              }
            }
          } else if (PlatformUtils.isIOS) {
            for (String url in downloadUrls) {
              if (url.contains("ipa")) {
                downloadUrl = url;
                break;
              }
            }
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
}
