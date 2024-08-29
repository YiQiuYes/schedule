import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_user_api.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import '../../common/utils/screen_utils.dart';
import '../../generated/l10n.dart';
import '../../global_logic.dart';
import 'state.dart';

// 枚举方向
enum AppMainLogicAnimationMode {
  forward,
  reverse,
  refresh,
}

class AppMainLogic extends GetxController {
  final AppMainState state = AppMainState();
  final globalState = Get.find<GlobalLogic>().state;
  final globalLogic = Get.find<GlobalLogic>();

  final userApi = ScheduleUserApi();

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

  /// 自动登录教务系统
  void autoLoginEducationalSystem(BuildContext context) {
    // 获取用户信息
    final username = globalState.scheduleUserInfo["username"];
    final password = globalState.scheduleUserInfo["password"];
    // 开始登录并超时时间为10s
    if (username == null ||
        password == null ||
        username.isEmpty ||
        password.isEmpty) {
      return;
    }

    // 采用延迟解决过早登录刷新cookie导致后面请求失效问题
    Future.delayed(const Duration(seconds: 2), () {
      userApi
          .loginEducationalSystem(userAccount: username, userPassword: password)
          .then((loginStatus) {
        switch (loginStatus) {
          case ScheduleUserStatus.loginTimeOut:
            Get.snackbar(
              S.current.login_statue,
              S.current.login_timeout,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              margin: EdgeInsets.only(
                top: 30.w,
                left: 50.w,
                right: 50.w,
              ),
            );
            break;
          case ScheduleUserStatus.success:
            // 储存登录成功
            globalLogic.setIsLogin(true);
            break;
          case ScheduleUserStatus.fail:
            Get.snackbar(
              S.current.login_statue,
              S.current.login_fail,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              margin: EdgeInsets.only(
                top: 30.w,
                left: 50.w,
                right: 50.w,
              ),
            );
            break;
        }
      });
    });
  }
}
