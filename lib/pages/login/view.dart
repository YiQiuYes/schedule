import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../generated/l10n.dart';
import '../app_main/logic.dart';
import 'logic.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logic = Get.put(LoginLogic());
  final state = Get.find<LoginLogic>().state;

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: S.of(context).login_tile,
      logo: 'lib/assets/images/logo.png',
      theme: LoginTheme(
        titleStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        cardInitialHeight: ScreenUtils.length(vertical: 20.w, horizon: 45.w),
      ),
      hideForgotPasswordButton: true,
      onLogin: (data) {
        return logic.loginEducationalSystem(data);
      },
      messages: LoginMessages(
        userHint: S.of(context).login_userHint,
        passwordHint: S.of(context).login_passwordHint,
        loginButton: S.of(context).login_loginButton,
        flushbarTitleError: S.of(context).login_flushbarTitleError,
      ),
      onRecoverPassword: (_) => Future.value(),
      userType: LoginUserType.name,
      userValidator: logic.userValidator,
      passwordValidator: logic.passwordValidator,
      onSubmitAnimationCompleted: () {
        final logic = Get.find<AppMainLogic>();
        logic.animationByOrientation(AppMainLogicAnimationMode.forward);
        Get.back(id: 1);
      },
    );
  }
}
