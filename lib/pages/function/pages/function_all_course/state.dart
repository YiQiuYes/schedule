import 'package:flutter_picker_plus/picker.dart';
import 'package:get/get.dart';
import 'package:schedule/global_logic.dart';

class FunctionAllCourseState {
  // 列表选择数据
  List<PickerItem<String>> pickerData = <PickerItem<String>>[
    PickerItem<String>(
      value: "电气与信息工程",
      children: <PickerItem<String>>[
        PickerItem<String>(value: ""),
      ],
    ),
  ];

  // 学院网络请求源信息
  List<Map> originCollegeInfo = [];

  // 个人课表数据
  RxList courseData = [].obs;

  // 周次
  RxString week = "1".obs;

  // 当前选择的学院和专业
  List<int> collegeAndMajorIndex = [0, 0];

  // 加载是否完成
  RxBool isLoad = true.obs;

  FunctionAllCourseState() {
    final globalState = Get.find<GlobalLogic>().state;
    week.value = globalState.semesterWeekData["currentWeek"];
  }
}
