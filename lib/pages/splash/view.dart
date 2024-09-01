import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'logic.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final logic = Get.put(SplashLogic());
  final state = Get.find<SplashLogic>().state;

  @override
  void initState() {
    super.initState();

    logic.autoLoginEducationalSystem();
    logic.initAnimationController(this, context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Lottie.asset(
          controller: state.animationController,
          'lib/assets/lotties/splash.json',
        ),
      ),
    );
  }
}

