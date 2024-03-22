import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    _viewModel.getRandomHomeImg();
    // 跳转主页面
    _viewModel.navigateToSchedule(context, 2500);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child:
              Consumer<SplashViewModel>(builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.splashImg,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
                  }

                  return const SizedBox();
                });
          }),
        ),
      ),
    );
  }
}
