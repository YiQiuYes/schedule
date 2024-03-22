import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/pages/login/LoginViewModel.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _screen = ScreenAdaptor();
  final _loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();
    // 页面初始化
    _loginViewModel.loginViewModelInit();
    // 自动登录
    _loginViewModel.autoLogin(context);
  }

  @override
  void dispose() {
    _loginViewModel.usernameController.dispose();
    _loginViewModel.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _loginViewModel,
      child: Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 登录文本
              _getLoginText(),
              // 欢迎文本
              _getWelcomeText(),
              // 登录表单
              _getLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取登录表单
  Widget _getLoginForm() {
    return Padding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 40.w,
          horizon: 20.w,
        ),
      ),
      child: Column(
        children: [
          // 用户名输入框
          SizedBox(
            width: _screen.getLengthByOrientation(
              vertical: 400.w,
              horizon: 200.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 100.w,
              horizon: 40.w,
            ),
            child: TextField(
              maxLines: 1,
              controller: _loginViewModel.usernameController,
              style: TextStyle(
                fontSize: _screen.getLengthByOrientation(
                  vertical: 30.sp,
                  horizon: 12.sp,
                ),
              ),
              decoration: InputDecoration(
                // 必须设置为true，fillColor才有效
                filled: true,
                // 内容边距
                contentPadding: EdgeInsets.only(
                  left: _screen.getLengthByOrientation(
                    vertical: 20.w,
                    horizon: 13.w,
                  ),
                  top: _screen.getLengthByOrientation(
                    vertical: 18.w,
                    horizon: 10.w,
                  ),
                  bottom: _screen.getLengthByOrientation(
                    vertical: 18.w,
                    horizon: 10.w,
                  ),
                ),
                hintText: S.of(context).loginViewUsername,
                //设置输入框可编辑时的边框样式
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    _screen.getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 17.w,
                    ),
                  ),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    _screen.getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 17.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 间距
          SizedBox(
            height: _screen.getLengthByOrientation(
              vertical: 40.w,
              horizon: 20.w,
            ),
          ),
          // 密码输入框
          SizedBox(
            width: _screen.getLengthByOrientation(
              vertical: 400.w,
              horizon: 200.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 100.w,
              horizon: 40.w,
            ),
            child: Consumer<LoginViewModel>(builder: (context, model, child) {
              return TextField(
                maxLines: 1,
                controller: _loginViewModel.passwordController,
                // 密码隐藏
                obscureText: model.obscureText,
                style: TextStyle(
                  fontSize: _screen.getLengthByOrientation(
                    vertical: 30.sp,
                    horizon: 12.sp,
                  ),
                ),
                decoration: InputDecoration(
                  // 必须设置为true，fillColor才有效
                  filled: true,
                  // 相当于高度包裹的意思，必须设置为true
                  isCollapsed: false,
                  isDense: true,
                  // 内容边距
                  contentPadding: EdgeInsets.only(
                    left: _screen.getLengthByOrientation(
                      vertical: 20.w,
                      horizon: 13.w,
                    ),
                    top: _screen.getLengthByOrientation(
                      vertical: 18.w,
                      horizon: 10.w,
                    ),
                    bottom: _screen.getLengthByOrientation(
                      vertical: 18.w,
                      horizon: 10.w,
                    ),
                  ),
                  hintText: S.of(context).loginViewPassword,
                  //设置输入框可编辑时的边框样式
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      _screen.getLengthByOrientation(
                        vertical: 20.w,
                        horizon: 17.w,
                      ),
                    ),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      _screen.getLengthByOrientation(
                        vertical: 20.w,
                        horizon: 17.w,
                      ),
                    ),
                  ),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: model.changeObscureText,
                    icon: const Icon(Icons.remove_red_eye_rounded),
                  ),
                ),
              );
            }),
          ),
          // 间距
          SizedBox(
            height: _screen.getLengthByOrientation(
              vertical: 40.w,
              horizon: 20.w,
            ),
          ),
          // 验证码输入框
          SizedBox(
            width: _screen.getLengthByOrientation(
              vertical: 400.w,
              horizon: 200.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 100.w,
              horizon: 40.w,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 验证码输入框
                SizedBox(
                  width: _screen.getLengthByOrientation(
                    vertical: 243.w,
                    horizon: 135.w,
                  ),
                  child: TextField(
                    controller: _loginViewModel.captchaController,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: _screen.getLengthByOrientation(
                        vertical: 30.sp,
                        horizon: 12.sp,
                      ),
                    ),
                    decoration: InputDecoration(
                      // 必须设置为true，fillColor才有效
                      filled: true,
                      // 相当于高度包裹的意思，必须设置为true
                      // isCollapsed: true,
                      // 内容边距
                      contentPadding: EdgeInsets.only(
                        left: _screen.getLengthByOrientation(
                          vertical: 20.w,
                          horizon: 13.w,
                        ),
                        top: _screen.getLengthByOrientation(
                          vertical: 18.w,
                          horizon: 10.w,
                        ),
                        bottom: _screen.getLengthByOrientation(
                          vertical: 18.w,
                          horizon: 10.w,
                        ),
                      ),
                      hintText: S.of(context).loginViewCaptcha,
                      //设置输入框可编辑时的边框样式
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          _screen.getLengthByOrientation(
                            vertical: 20.w,
                            horizon: 17.w,
                          ),
                        ),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          _screen.getLengthByOrientation(
                            vertical: 20.w,
                            horizon: 17.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 间距
                SizedBox(
                  width: _screen.getLengthByOrientation(
                    vertical: 17.w,
                    horizon: 10.w,
                  ),
                ),
                // 验证码图片
                Consumer<LoginViewModel>(builder: (context, model, child) {
                  return FutureBuilder(
                    future: model.captchaData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data!.isNotEmpty) {
                        return InkWell(
                          onTap: () {
                            model.changeCaptcha(isTimer: false);
                          },
                          child: SizedBox(
                            width: _screen.getLengthByOrientation(
                              vertical: 130.w,
                              horizon: 55.w,
                            ),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  );
                }),
              ],
            ),
          ),
          // 间距
          SizedBox(
            height: _screen.getLengthByOrientation(
              vertical: 60.w,
              horizon: 20.w,
            ),
          ),
          // 登录按钮
          SizedBox(
            width: _screen.getLengthByOrientation(
              vertical: 400.w,
              horizon: 200.w,
            ),
            height: _screen.getLengthByOrientation(
              vertical: 100.w,
              horizon: 40.w,
            ),
            child: Consumer<LoginViewModel>(builder: (context, model, child) {
              return ElevatedButton(
                onPressed: () => model.login(context),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(
                      _screen.getLengthByOrientation(
                        vertical: 600.w,
                        horizon: 200.w,
                      ),
                      _screen.getLengthByOrientation(
                        vertical: 60.w,
                        horizon: 35.w,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  S.of(context).loginViewLoginButton,
                  style: TextStyle(
                    fontSize: _screen.getLengthByOrientation(
                      vertical: 30.sp,
                      horizon: 12.sp,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 获取欢迎文本
  Widget _getWelcomeText() {
    return Padding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 40.w,
          horizon: 20.w,
        ),
      ),
      child: Center(
        child: Text(
          S.of(context).loginViewGreatText,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 35.sp,
              horizon: 15.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// 获取登录文本
  Widget _getLoginText() {
    return Padding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 190.w,
          horizon: 20.w,
        ),
      ),
      child: Center(
        child: Text(
          S.of(context).loginViewTitle,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 55.sp,
              horizon: 25.sp,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
