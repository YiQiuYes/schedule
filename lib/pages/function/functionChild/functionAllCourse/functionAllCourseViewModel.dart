import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:schedule/common/utils/FlutterToastUtil.dart';
import 'package:schedule/main.dart';

import '../../../../api/schedule/QueryApi.dart';
import '../../../../api/schedule/impl/QueryApiImpl.dart';
import '../../../../generated/l10n.dart';

class FunctionAllCourseViewModel with ChangeNotifier {
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
  List<Map> _originCollegeInfo = [];

  final QueryApi _queryApi = QueryApiImpl();

  // 个人课表数据
  List<Map> _courseData = [];

  // 周次
  String _week = globalModel.semesterWeekData["currentWeek"];

  // 当前选择的学院和专业
  List<int> _collegeAndMajorIndex = [0, 0];

  /// 选择周次
  void selectWeekConfirm(Picker picker, List<int> value) {
    _week = (value[0] + 1).toString();
    getCourseData(
      pickerData[_collegeAndMajorIndex[0]]
          .children![_collegeAndMajorIndex[1]]
          .value!,
      _week,
    );
  }

  /// 选择学院和专业
  void selectCollegeAndMajorConfirm(Picker picker, List<int> value) {
    // 获取课程信息
    getCourseData(pickerData[value[0]].children![value[1]].value!, _week);
    _collegeAndMajorIndex = value;
  }

  /// 初始化
  Future<void> init() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      FlutterToastUtil.showLoading(milliseconds: 5000);
    });

    // 获取学院信息
    await _queryApi.queryCollegeInfo().then((value) {
      _originCollegeInfo = value;
      pickerData.clear();
      pickerData.addAll(value
          .map((e) => PickerItem<String>(
              value: e["collegeName"],
              children: <PickerItem<String>>[PickerItem<String>(value: "")]))
          .toList());
    });

    // 获取专业信息
    await _queryApi
        .queryMajorInfo(
            collegeId: getCollegeIdByName(pickerData[0].value!),
            semester: globalModel.semesterWeekData["semester"])
        .then((value) {
      pickerData[0].children?.clear();
      pickerData[0]
          .children
          ?.addAll(value.map((e) => PickerItem<String>(value: e)).toList());
    });

    // 获取课程信息
    await getCourseData(pickerData[0].children![0].value!, _week);

    FlutterToastUtil.cancelToast();
  }

  /// 获取adapter
  PickerDataAdapter<String> getClassPickerData() {
    return PickerDataAdapter<String>(
      data: pickerData,
      isArray: false,
    );
  }

  /// 学院专业滑动设置列表数据
  void setCollegeAndMajorPickerData(int index, Picker picker) async {
    if (pickerData[index].children!.length > 1) {
      return;
    }

    await _queryApi
        .queryMajorInfo(
            collegeId: getCollegeIdByName(pickerData[index].value!),
            semester: globalModel.semesterWeekData["semester"])
        .then((value) {
      pickerData[index].children?.clear();
      pickerData[index]
          .children
          ?.addAll(value.map((e) => PickerItem<String>(value: e)).toList());
    });
    picker.state?.update();
  }

  /// 根据名称获取学院ID
  String getCollegeIdByName(String collegeName) {
    return _originCollegeInfo.firstWhere(
        (element) => element["collegeName"] == collegeName)["collegeId"];
  }

  /// 获取周次数据
  PickerDataAdapter getWeekPickerData(BuildContext context) {
    List<PickerItem<String>> weekPickerData = List.generate(20, (index) {
      return PickerItem<String>(
        value: getTabPageWeek(S.of(context).scheduleViewCurrentWeek, index),
      );
    });
    return PickerDataAdapter<String>(
      data: weekPickerData,
      isArray: false,
    );
  }

  /// 通过索引计算是第几周
  String getTabPageWeek(String text, int index) {
    index++;
    return text.replaceAll("%%", index.toString());
  }

  /// 获取课程表数据
  Future<void> getCourseData(String majorName, String week) async {
    await _queryApi
        .queryMajorCourse(
            week: week,
            semester: globalModel.semesterWeekData["semester"],
            majorName: majorName,
            cachePolicy: CachePolicy.refresh)
        .then((value) {
      // logger.i(value);
      _courseData = value;
      notifyListeners();
    });
  }

  /// 获取课程表数据
  List<Map> get courseData => _courseData;

  /// 获取周次
  String get week => _week;

  /// 获取当前选择的学院和专业
  List<int> get collegeAndMajorIndex => _collegeAndMajorIndex;
}
