import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/api/other/other_api.dart';
import '../../common/manager/data_storage_manager.dart';
import '../../common/utils/flutter_toast_utils.dart';
import '../../common/utils/logger_utils.dart';
import '../../common/utils/package_info_utils.dart';
import '../../common/utils/platform_utils.dart';
import '../../common/utils/screen_utils.dart';
import '../../generated/l10n.dart';
import 'state.dart';

// 枚举方向
enum AppMainLogicAnimationMode {
  forward,
  reverse,
  refresh,
}

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();

  final storage = DataStorageManager();
  final otherApi = OtherApi();

  /// 刷新屏幕旋转状态
  void refreshOrientation() {
    state.orientation.value = ScreenUtils.getOrientation();
    update();
  }

  /// 设置导航栏索引
  void setNavigateCurrentIndex(int index) {
    state.navigateCurrentIndex.value = index;
    state.mainTabController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  /// 初始化主页面控制器
  void initMainTabController(TickerProvider vsync) {
    state.mainTabController = PageController(
      initialPage: 0,
    );
  }

  /// 获取版本更新提示
  void getVersionUpdate() {
    // 每隔1天检测一次
    if (storage.getString("lastCheckVersionTime") != null) {
      DateTime lastCheckVersionTime =
          DateTime.parse(storage.getString("lastCheckVersionTime")!);
      if (DateTime.now().difference(lastCheckVersionTime).inDays < 1) {
        return;
      }
    } else {
      storage.setString("lastCheckVersionTime", DateTime.now().toString());
    }

    otherApi.getVersionInfo().then((value) {
      if (value['tag_name'] == null) {
        return;
      }

      String version = value['tag_name'].replaceAll("v", "");
      // 如果版本相同则不提示
      if (version == PackageInfoUtils.version) {
        return;
      }

      bool isUpdate = PackageInfoUtils.compareVersion(version);
      if (isUpdate) {
        // 有新版本
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
        }

        // 弹窗显示
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
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
                    FlutterToastUtil.toastNoContent(
                        S.of(context).update_dialog_snackbar_vpn);
                    // 跳转到浏览器
                    launchUrl(Uri.parse(downloadUrl),
                        mode: LaunchMode.externalApplication);
                  },
                  child: Text(S.of(context).update_dialog_confirm),
                ),
              ],
            );
          },
        );

        // 保存检测时间
        storage.setString("lastCheckVersionTime", DateTime.now().toString());
      }
    });
  }
}
