import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/route/GoRouteConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/schedule/OtherApi.dart';
import '../../api/schedule/UserApi.dart';
import '../../api/schedule/impl/OtherApiImpl.dart';
import '../../api/schedule/impl/UserApiImpl.dart';
import '../../common/utils/FlutterToastUtil.dart';
import '../../common/utils/PackageInfoUtils.dart';
import '../../common/utils/PlatFormUtils.dart';
import '../../generated/l10n.dart';
import '../../main.dart';

class SplashViewModel with ChangeNotifier {
  // 动画控制器
  late AnimationController animationController;

  final UserApi _userApi = UserApiImpl();
  final OtherApi _otherApi = OtherApiImpl();

  /// 初始化动画控制器
  void initAnimationController(TickerProvider vsync, BuildContext context) {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // logger.i("success");
        navigateToSchedule(context);
      }
    });
    animationController.forward();
  }

  /// 跳转主页面
  /// [context] 上下文
  /// [milliseconds] 延迟时间
  void navigateToSchedule(BuildContext context) {
    GoRouter.of(context).replace(GoRouteConfig.appMain);
  }

  /// 登录
  void login() {
    _userApi.autoLoginEducationalSystem(
        userAccount: globalModel.userInfoData["username"],
        userPassword: globalModel.userInfoData["password"]);
  }

  /// 获取版本更新提示
  void getVersionUpdate() {
    _otherApi.getVersionInfo().then((value) {
      String version = value['tag_name'].replaceAll("v", "");
      bool isUpdate = PackageInfoUtils.compareTwoVersion(
        version,
        globalModel.settings["version"],
      );

      if (isUpdate) {
        globalModel.setVersion(version);
        // logger.i("有新版本");

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
          context: GoRouteConfig.context,
          barrierDismissible: false,
          builder: (context) {
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
                    FlutterToastUtil.toastNoContent(
                        S.of(context).updateDialogToastDownloadingVPN);
                    // 跳转到浏览器
                    launchUrl(Uri.parse(downloadUrl));
                  },
                  child: Text(S.of(context).updateDialogConfirm),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
