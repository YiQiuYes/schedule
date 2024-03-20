import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';

class FlutterToastUtil {
  static final fToast = FToast();

  static void toastNoContent(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
    );
  }

  static void errorToast(String text, {int milliseconds = 2000}) {
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
    fToast.showToast(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 30.w,
            horizon: 15.w,
          ),
        ),
        child: Container(
          color: Colors.redAccent,
          padding: EdgeInsets.symmetric(
              horizontal: ScreenAdaptor().getLengthByOrientation(
                vertical: 25.w,
                horizon: 18.w,
              ),
              vertical: ScreenAdaptor().getLengthByOrientation(
                vertical: 18.w,
                horizon: 10.w,
              )),
          child: Text(
            text,
          ),
        ),
      ),
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }

  static void okToast(String text, {int milliseconds = 2000}) {
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
    fToast.showToast(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ScreenAdaptor().getLengthByOrientation(
            vertical: 30.w,
            horizon: 15.w,
          ),
        ),
        child: Container(
          color: Colors.green,
          padding: EdgeInsets.symmetric(
              horizontal: ScreenAdaptor().getLengthByOrientation(
                vertical: 25.w,
                horizon: 18.w,
              ),
              vertical: ScreenAdaptor().getLengthByOrientation(
                vertical: 18.w,
                horizon: 10.w,
              )),
          child: Text(
            text,
          ),
        ),
      ),
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }

  static void showLoading({int milliseconds = 2000}) {
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();

    fToast.showToast(
      child: Lottie.asset(
        "lib/assets/lotties/loading.json",
        width: ScreenAdaptor().getLengthByOrientation(
          vertical: 500.w,
          horizon: 250.w,
        ),
        height: ScreenAdaptor().getLengthByOrientation(
          vertical: 500.w,
          horizon: 250.w,
        ),
      ),
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(milliseconds: milliseconds),
    );
  }
}
