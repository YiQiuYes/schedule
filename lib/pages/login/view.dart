import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../generated/l10n.dart';
import 'logic.dart';

enum LoginPageType {
  schedule,
  hui798,
  hut,
}

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
    final type = logic.getPageType(context);
    logic.init(type);

    return Scaffold(
      appBar: appBarWidget(context),
      extendBodyBehindAppBar: true,
      body: FlutterLogin(
        title: S.of(context).login_tile,
        logo: 'lib/assets/images/logo.png',
        theme: LoginTheme(
          titleStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          cardInitialHeight: ScreenUtils.length(vertical: 280.w, horizon: 60.w),
          pageColorLight: Theme.of(context).colorScheme.surfaceContainer,
          pageColorDark: Theme.of(context).colorScheme.surfaceContainer,
          cardTheme:
              CardTheme(color: Theme.of(context).colorScheme.primaryContainer),
        ),
        hideForgotPasswordButton: true,
        hideCaptchaTextField: logic.hideCaptchaTextField(type),
        onLogin: (data) {
          return logic.onLogin(type, data);
        },
        messages: LoginMessages(
          userHint: S.of(context).login_user_hint,
          passwordHint: S.of(context).login_password_hint,
          loginButton: S.of(context).login_login_button,
          flushbarTitleError: S.of(context).login_flushbar_title_error,
          captchaHint: S.of(context).login_captcha_hint,
          messageCodeHint: S.of(context).login_message_code_hint,
        ),
        changeTextFieldCallback: logic.changeTextFieldCallback,
        onRecoverPassword: (_) => Future.value(),
        userType: LoginUserType.name,
        userValidator: logic.userValidator,
        passwordValidator: logic.passwordValidator,
        hidePasswordTextField: logic.hidePasswordTextField(type),
        captchaValidator: logic.captchaValidator,
        captchaTextRatio: logic.captchaTextRatio(type),
        captchaWidget: captchaImageWidget(),
        messageCodeTextRatio: logic.messageCodeTextRatio(type),
        hideMessageCodeTextField: logic.hideMessageCodeTextField(type),
        messageCodeValidator: logic.messageCodeValidator,
        messageCodeWidget: sendMessageBtnWidget(context),
        onSubmitAnimationCompleted: () {
          logic.onSubmitAnimationCompleted(type);
        },
      ),
    );
  }

  /// 获取appBar
  PreferredSizeWidget? appBarWidget(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).login_tile),
      backgroundColor: Colors.transparent,
    );
  }

  /// 发送短信验证码按钮
  Widget sendMessageBtnWidget(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        logic.onSendCaptchaDrink();
      },
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: ScreenUtils.length(vertical: 22.w, horizon: 8.w),
            vertical: 0,
          ),
        ),
      ),
      child: GetBuilder<LoginLogic>(
        builder: (logic) {
          return Text(logic.state.time.value == 0
              ? S.of(context).login_send_message_code
              : logic.state.time.value.toString());
        },
      ),
    );
  }

  /// 验证码图片
  Widget captchaImageWidget() {
    return GetBuilder<LoginLogic>(builder: (logic) {
      return FutureBuilder(
        future: logic.state.captchaData.value,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data!.isNotEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                  ScreenUtils.length(vertical: 14.w, horizon: 4.w)),
              child: InkWell(
                onTap: () {
                  logic.getDrinkPhotoCaptchaData();
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Image.memory(
                  snapshot.data!,
                  height: ScreenUtils.length(vertical: 48.h, horizon: 25.w),
                  width: ScreenUtils.length(vertical: 140.w, horizon: 53.w),
                  fit: BoxFit.fill,
                ),
              ),
            );
          }
          return SizedBox(
            width: ScreenUtils.length(vertical:140.w, horizon: 53.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    });
  }
}
