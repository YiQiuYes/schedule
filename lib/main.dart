import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/AppTheme.dart';
import 'package:schedule/common/utils/DataStorageManager.dart';
import 'package:schedule/common/utils/FileManager.dart';
import 'package:schedule/common/utils/RequestManager.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/route/GoRouteConfig.dart';

// 全局数据
final globalModel = GlobalModel();

Future<void> main() async {
  // 首先注册组件
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化数据存储读取器
  await DataStorageManager().init();

  // 初始化文件管理器
  await FileManager().fileManagerInit();

  // 初始化网络请求管理
  await RequestManager().persistCookieJarInit();

  // 全局数据初始化
  globalModel.init();

  runApp(ChangeNotifierProvider.value(
    value: globalModel,
    child: const MyApp(),
  ));

  // 状态栏和底部小白条沉浸
  AppTheme.statusBarAndBottomBarImmersed();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(720, 1080),
        splitScreenMode: true,
        ensureScreenSize: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Schedule',
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
            localeResolutionCallback:
                (Locale? deviceLocale, Iterable<Locale> supportedLocales) {
              // 如果语言是英语
              if (deviceLocale?.languageCode == 'en') {
                DataStorageManager().setString("LanguageCode", "en");
                //注意大小写，返回美国英语
                return const Locale('en', 'US');
              } else if (deviceLocale?.languageCode == 'zh') {
                DataStorageManager().setString("LanguageCode", "zh");
                //注意大小写，返回中文
                return const Locale('zh', 'CN');
              } else {
                return deviceLocale;
              }
            },
          );
        });
  }
}
