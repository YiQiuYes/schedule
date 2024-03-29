import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/AppTheme.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/manager/FileManager.dart';
import 'package:schedule/common/utils/PackageInfoUtils.dart';
import 'package:schedule/common/manager/RequestManager.dart';
import 'package:schedule/common/utils/PlatFormUtils.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/route/GoRouteConfig.dart';
import 'package:window_manager/window_manager.dart';

import 'common/utils/LoggerUtils.dart';

// 全局数据
final globalModel = GlobalModel();

Future<void> main() async {
  // 首先注册组件
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化数据存储读取器
  await DataStorageManager().init();

  // 初始化窗口管理器
  await PlatformUtils.initForDesktop();

  // 初始化文件管理器
  await FileManager().fileManagerInit();

  // 初始化网络请求管理
  await RequestManager().persistCookieJarInit();

  // 初始化版本信息
  await PackageInfoUtils.packageInfoInit();

  // 状态栏和底部小白条沉浸
  AppTheme.statusBarAndBottomBarImmersed();

  // 全局数据初始化
  globalModel.init();

  runApp(ChangeNotifierProvider.value(
    value: globalModel,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    if (PlatformUtils.isWindows ||
        PlatformUtils.isLinux ||
        PlatformUtils.isMacOS) {
      windowManager.addListener(this);
    }
  }

  @override
  void onWindowMove() async {
    super.onWindowMove();
    if (PlatformUtils.isWindows ||
        PlatformUtils.isLinux ||
        PlatformUtils.isMacOS) {
      Offset offset = await windowManager.getPosition();
      await DataStorageManager().setString("windowsOffsetPosition",
          jsonEncode({"x": offset.dx, "y": offset.dy}));
    }
  }

  @override
  void onWindowResize() async {
    super.onWindowResize();
    if (PlatformUtils.isWindows ||
        PlatformUtils.isLinux ||
        PlatformUtils.isMacOS) {
      Offset offset = await windowManager.getPosition();
      await DataStorageManager().setString("windowsOffsetPosition",
          jsonEncode({"x": offset.dx, "y": offset.dy}));

      Size size = await windowManager.getSize();
      await DataStorageManager().setString(
          "windowsSize",
          jsonEncode({
            "width": size.width,
            "height": size.height,
          }));
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(720, 1080),
      splitScreenMode: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return Consumer<GlobalModel>(builder: (context, model, child) {
          return MaterialApp.router(
            title: 'schedule',
            builder: FToastBuilder(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'ZhuZiSWan',
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              fontFamily: 'ZhuZiSWan',
              brightness: Brightness.dark,
            ),
            routerConfig: GoRouteConfig.router,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: model.getLocale(),
            localeResolutionCallback:
                (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
              // logger.i(deviceLocale);
              String language = model.settings["language"];
              if (language == "default") {
                if (model.settings["deviceLocale"] == "default") {
                  model.setDeviceLocale(
                      "${deviceLocale?.languageCode}-${deviceLocale?.countryCode}");
                }
                return deviceLocale;
              } else {
                return Locale(language.split("-")[0], language.split("-")[1]);
              }
            },
          );
        });
      },
    );
  }
}
