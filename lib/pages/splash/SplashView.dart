import 'package:flutter/material.dart';
import 'package:schedule/pages/splash/SplashViewModel.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    GoRouteConfig.setContext = context;
    // 跳转主页面
    _viewModel.navigateToSchedule(context, 2500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Image.asset(
          'lib/assets/images/splash.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
