import 'dart:async';

import 'package:get/get.dart';

class GlobalState {
  // 课程数据
  RxList courseData =
      List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}]).obs;

  // 实验课表数据
  RxList experimentData =
      List.generate(20, (index) => [for (int i = 0; i < 35; i++) {}]).obs;

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

  // 设置数据
  RxMap<String, dynamic> settings = {
    "isLogin": false,
    "load20CountCourse": false,
  }.obs;

  // 定时器刷新数据
  Timer? timer;

  GlobalState() {}
}
