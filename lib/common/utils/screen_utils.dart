import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  // 屏幕适配工具
  static final ScreenUtil _screenUtil = ScreenUtil();

  /// 适配屏幕所需的长度
  static double length({
    required double vertical,
    required double horizon,
  }) {
    return _screenUtil.orientation.index == 0 ? vertical : horizon;
  }

  /// 获取横屏还是竖屏
  /// true: 竖屏  false: 横屏
  static bool getOrientation() {
    return _screenUtil.orientation.index == 0 ? true : false;
  }

  /// 横竖屏返回指定内容
  static T? byOrientationReturn<T>({T? vertical, T? horizon}) {
    return _screenUtil.orientation.index == 0 ? vertical : horizon;
  }

  /// 当前设备宽度 dp
  static double get screenWidth => _screenUtil.screenWidth;

  ///当前设备高度 dp
  static double get screenHeight => _screenUtil.screenHeight;
}
