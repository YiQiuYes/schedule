import 'dart:async';

import 'package:get/get.dart';

class GlobalState {
  // 课程数据
  late RxList courseData;

  // 实验课表数据
  late RxList experimentData;

  // 学期周次数据
  RxMap<String, dynamic> semesterWeekData = {
    "semester": "2023-2024-2",
    "startDay": "2024-3-4",
    "currentWeek": "1",
  }.obs;

  // 教务系统个人账号
  RxMap<String, dynamic> scheduleUserInfo = {
    "username": "",
    "password": "",
  }.obs;

  // 惠生活798账号
  RxMap<String, dynamic> hui798UserInfo = {
    "hui798IsLogin": false,
    "username": "",
    "password": "",
  }.obs;

  // 设置数据
  RxMap<String, dynamic> settings = {
    "isLogin": false,
    "load20CountCourse": false,
    "themeMode": "default",
    "colorTheme": "#673AB7",
    "isMonetColor": false,
    "language": "zh-CN",
  }.obs;

  // 定时器刷新数据
  Timer? timer;

  GlobalState() {
    List generateCourseData =
        List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}])
            as List<List<dynamic>>;
    courseData = generateCourseData.obs;

    List generateExperimentData =
        List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}])
            as List<List<dynamic>>;
    experimentData = generateExperimentData.obs;
  }
}
