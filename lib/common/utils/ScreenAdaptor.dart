import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaptor {
  ScreenAdaptor._privateConstructor();
  static final ScreenAdaptor _instance = ScreenAdaptor._privateConstructor();
  factory ScreenAdaptor() {
    return _instance;
  }

  // 屏幕适配工具
  final ScreenUtil _screenUtil = ScreenUtil();

  /// 适配屏幕所需的长度
  double getLengthByOrientation({
    required double vertical,
    required double horizon,
  }) {
    return _screenUtil.orientation.index == 0 ? vertical : horizon;
  }

  /// 传入当前参数获取相对应的宽度
  double getOrientationWidth(double width) {
    return width / _screenUtil.screenWidth;
  }

  /// 获取横屏还是竖屏
  /// true: 竖屏  false: 横屏
  bool getOrientation() {
    return _screenUtil.orientation.index == 0 ? true : false;
  }

  /// 横竖屏返回指定内容
  T? byOrientationReturn<T>({T? vertical, T? horizon}) {
    return _screenUtil.orientation.index == 0 ? vertical : horizon;
  }
}
