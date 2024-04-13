import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:schedule/pages/splash/SplashViewModel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  final _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.login();
    _viewModel.initAnimationController(this, context);
  }

  @override
  void dispose() {
    _viewModel.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Lottie.asset(
            controller: _viewModel.animationController,
            'lib/assets/lotties/splash.json',
          ),
        ),
      ),
    );
  }
}
