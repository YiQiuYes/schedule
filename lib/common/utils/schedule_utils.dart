import 'package:get/get.dart';
import 'package:schedule/common/utils/screen_utils.dart';
import 'package:schedule/global_logic.dart';

class ScheduleUtils {
  /// 获取课程名称
  static String getCourseName(Map course, Map experiment) {
    if (experiment.isNotEmpty) {
      return experiment['className'] ?? '';
    }
    return course['className'] ?? '';
  }

  /// 格式化课程地址
  static String formatAddress(String address, {bool breakWord = false}) {
    if (address.isNotEmpty &&
        address.contains(RegExp(r"\d\d\d")) &&
        !address.contains("楼")) {
      // 往倒数第三个位置插入“楼”
      address =
          "${address.substring(0, address.length - 3)}楼${address.substring(address.length - 3)}";
    }

    if (breakWord) {
      // 打断字符
      String str = '';
      for (var element in address.runes) {
        str += String.fromCharCode(element);
        str += '\u200B';
      }

      address = str;
    }

    return address;
  }

  /// 获取课程地址
  static String getCourseAddress(Map course, Map experiment) {
    String address = course['classAddress'] ?? '';
    if (experiment.isNotEmpty) {
      address = experiment['classAddress'] ?? '';
    }
    final strLine = ScreenUtils.byOrientationReturn(vertical: "\n", horizon: "")!;

    if (address.isNotEmpty &&
        address.contains(RegExp(r"\d\d\d")) &&
        !address.contains("楼")) {
      // 往倒数第三个位置插入“楼”
      address =
          "${address.substring(0, address.length - 3)}楼$strLine${address.substring(address.length - 3)}";
    } else if (address.isNotEmpty && address.contains(RegExp(r"\d\d\d"))) {
      address = address.replaceAll("楼", "楼$strLine");
    }

    return address;
  }

  /// 格式化日期字符串为标准形式
  static String formatDateString(String startDay) {
    // 格式化日期格式
    List<String> semesterList = startDay.split("-");
    startDay = "";
    for (String str in semesterList) {
      if (str.length == 1) {
        startDay += "0$str-";
      } else {
        startDay += "$str-";
      }
    }
    startDay = startDay.substring(0, startDay.length - 1);
    return startDay;
  }

  /// 获取星期几对应的日期
  static String getWeekDate(int i, int showWeek) {
    final state = Get.find<GlobalLogic>().state;

    final startDay = state.semesterWeekData["startDay"];
    final startDayTime = DateTime.parse(formatDateString(startDay));
    // 获取距离开学第几天
    final day = (showWeek - 1) * 7 + i;
    final month = startDayTime.add(Duration(days: day));
    return "${month.month}.${month.day}";
  }
}
