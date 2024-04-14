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

  static bool compareVersion(String version) {
    List<String> netSplit = version.split(".");
    List<String> localSplit = PackageInfoUtils.version.split(".");
    bool isUpdate = false;
    for (int i = 0; i < netSplit.length; i++) {
      if (int.parse(netSplit[i]) > int.parse(localSplit[i])) {
        isUpdate = true;
        break;
      } else if (int.parse(netSplit[i]) < int.parse(localSplit[i])) {
        break;
      }
    }
    return isUpdate;
  }

  static bool compareTwoVersion(String newVersion, String oldVersion) {
    List<String> netSplit = newVersion.split(".");
    List<String> localSplit = oldVersion.split(".");
    bool isUpdate = false;
    for (int i = 0; i < netSplit.length; i++) {
      if (int.parse(netSplit[i]) > int.parse(localSplit[i])) {
        isUpdate = true;
        break;
      } else if (int.parse(netSplit[i]) < int.parse(localSplit[i])) {
        break;
      }
    }
    return isUpdate;
  }


  static get packageInfo => _into;

  static get version => _into.version;

  static get appName => _into.appName;

  static get buildNumber => _into.buildNumber;

  static get packageName => _into.packageName;
}