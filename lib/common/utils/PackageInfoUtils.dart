import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoUtils {
  PackageInfoUtils._privateConstructor();
  static final PackageInfoUtils _instance = PackageInfoUtils._privateConstructor();
  factory PackageInfoUtils() {
    return _instance;
  }

  static late PackageInfo _into;

  static Future<void> packageInfoInit() async {
    _into = await PackageInfo.fromPlatform();
  }

  static get packageInfo => _into;

  static get version => _into.version;

  static get appName => _into.appName;

  static get buildNumber => _into.buildNumber;

  static get packageName => _into.packageName;
}