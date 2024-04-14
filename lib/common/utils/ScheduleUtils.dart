import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/main.dart';

class ScheduleUtils {
  static final _screen = ScreenAdaptor();

  /// 获取课程名称
  static String getCourseName(Map course, Map experiment) {
    if (experiment.isNotEmpty) {
      return experiment['className'] ?? '';
    }
    return course['className'] ?? '';
  }

  /// 获取课程地址
  static String getCourseAddress(Map course, Map experiment) {
    String address = course['classAddress'] ?? '';
    if (experiment.isNotEmpty) {
      address = experiment['classAddress'] ?? '';
    }
    final strLine = _screen.byOrientationReturn(vertical: "\n", horizon: "")!;

    if (address.isNotEmpty && !address.contains("楼")) {
      // 往倒数第三个位置插入“楼”
      address = "${address.substring(0, address.length - 3)}楼$strLine${address.substring(address.length - 3)}";
    } else if(address.isNotEmpty){
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
      if(str.length == 1) {
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
    final startDay = globalModel.semesterWeekData["startDay"];
    final startDayTime = DateTime.parse(formatDateString(startDay));
    // 获取距离开学第几天
    final day = (showWeek - 1) * 7 + i;
    final month = startDayTime.add(Duration(days: day));
    return "${month.month}.${month.day}";
  }
}