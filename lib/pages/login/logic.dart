import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/schedule/schedule_user_api.dart';
import 'package:schedule/pages/app_main/app_main_route_config.dart';
import 'package:schedule/pages/login/view.dart';

import '../../generated/l10n.dart';
import '../../global_logic.dart';
import 'state.dart';

class LoginLogic extends GetxController {
  final LoginState state = LoginState();
  final globalLogic = Get.find<GlobalLogic>();
  final globalState = Get.find<GlobalLogic>().state;

  ScheduleUserApi userApi = ScheduleUserApi();

  Future<String?>? onLogin (LoginPageType type, LoginData data) async {
    switch (type) {
      case LoginPageType.schedule:
        return loginEducationalSystem(data);
      default:
        return loginEducationalSystem(data);
    }
  }

  /// 登录教务系统
  Future<String?>? loginEducationalSystem(LoginData data) async {
    // 开始登录并超时时间为10s
    final loginStatus = await userApi.loginEducationalSystem(
      userAccount: data.name,
      userPassword: data.password,
    );

    switch (loginStatus) {
      case ScheduleUserStatus.loginTimeOut:
        return S.current.login_timeout;
      case ScheduleUserStatus.success:
        // 保存用户信息
        await globalLogic.setScheduleUserInfo("username", data.name);
        await globalLogic.setScheduleUserInfo("password", data.password);

        return null;
      case ScheduleUserStatus.fail:
        return S.current.login_fail;
    }
  }

  /// 用户名输入框验证
  String? userValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.login_user_not_empty;
    }
    return null;
  }

  /// 密码输入框验证
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.login_password_not_empty;
    }
    return null;
  }

  Future<void> onSubmitAnimationCompleted() async {
    // 储存登录成功
    await globalLogic.setIsLogin(true);
    Get.offAllNamed(AppMainRouteConfig.main, id: 1);
  }
}
