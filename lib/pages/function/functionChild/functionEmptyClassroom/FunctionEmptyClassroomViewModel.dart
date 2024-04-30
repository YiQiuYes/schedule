import 'dart:convert';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule/api/schedule/impl/QueryApiImpl.dart';
import 'package:schedule/common/manager/DataStorageManager.dart';
import 'package:schedule/common/utils/LoggerUtils.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';
import 'package:schedule/main.dart';

import '../../../../api/schedule/QueryApi.dart';
import '../../../../common/utils/FlutterToastUtil.dart';
import '../../../../generated/l10n.dart';

class FunctionEmptyClassroomViewModel with ChangeNotifier {
  final QueryApi _queryApi = QueryApiImpl();
  final _storage = DataStorageManager();
  // 第几节课索引
  int _lessonIndex = 0;
  // 教学楼和校区
  List<Map> _buildingInfo = [];
  // 空教室列表
  List _emptyClassroomList = [];
  // 选择的教学楼
  Map _selectedBuilding = {
    "buildingId": "",
    "campusId": "",
    "buildingName": "",
  };

  /// 初始化
  void init() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      FlutterToastUtil.showLoading(milliseconds: 10000);
    });

    // 计算当前属于第几节课
    const time = [
      "09:45",
      "11:40",
      "15:40",
      "17:40",
      "20:40",
    ];

    final now = DateTime.now();
    final currentHourAndMinute =
        "${now.hour < 10 ? "0${now.hour}" : now.hour}:${now.minute}";
    for (int i = 0; i < time.length; i++) {
      _lessonIndex = i;
      if (currentHourAndMinute.compareTo(time[i]) < 0) {
        notifyListeners();
        break;
      }
    }

    // 读取选择的教学楼
    String? selectedBuildingStr = _storage.getString("selectedBuilding");
    if (selectedBuildingStr != null) {
      Map<String, dynamic> map = jsonDecode(selectedBuildingStr);
      map.forEach((key, value) {
        _selectedBuilding[key] = value;
      });
    } else {
      // 获取教学楼信息
      _buildingInfo = await _queryApi.queryBuildingInfo();
      _selectedBuilding = {
        "buildingId": _buildingInfo[0]["buildingList"][0]["buildingId"],
        "campusId": _buildingInfo[0]["campusId"],
        "buildingName": _buildingInfo[0]["buildingList"][0]["buildingName"],
      };
      _storage.setString("selectedBuilding", jsonEncode(_selectedBuilding));
    }

    // 获取教学楼信息
    _buildingInfo = await _queryApi.queryBuildingInfo();

    // 获取空教室列表
    await queryEmptyClassroomData(
      _selectedBuilding["buildingId"],
      _selectedBuilding["campusId"],
    );

    FlutterToastUtil.cancelToast();
    notifyListeners();
  }

  /// 查询空教室
  Future<void> queryEmptyClassroomData(
    String buildingId,
    String campusId,
  ) async {
    _emptyClassroomList = await _queryApi.queryEmptyClassroom(
      semester: globalModel.semesterWeekData["semester"],
      buildingId: _selectedBuilding["buildingId"],
      campusId: _selectedBuilding["campusId"],
      // 星期几
      week: DateTime.now().weekday,
      lesson: _lessonIndex + 1,
      weekly: globalModel.semesterWeekData["currentWeek"],
    );
    // 排序
    _emptyClassroomList.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }

  /// 修改当前选择的教学楼
  void changeSelectedBuilding(
      String buildingId, String campusId, String buildingName) {
    _selectedBuilding = {
      "buildingId": buildingId,
      "campusId": campusId,
      "buildingName": buildingName,
    };
    _storage.setString("selectedBuilding", jsonEncode(_selectedBuilding));
  }

  /// 获取第几节课文本
  String getLessonText(BuildContext context, int index) {
    return S.of(context).functionEmptyClassroomViewWhatLesson(index + 1);
  }

  /// 点击选择第几节课
  void choiceLesson(BuildContext context) {
    final screen = ScreenAdaptor();

    List<String> pickerData = [];
    for (int i = 0; i < 5; i++) {
      pickerData.add(getLessonText(context, i));
    }

    var adapter = PickerDataAdapter<String>(pickerData: pickerData);

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [_lessonIndex],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: screen.getLengthByOrientation(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: screen.getLengthByOrientation(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: screen.getLengthByOrientation(
        vertical: 500.w,
        horizon: 150.w,
      ),
      itemExtent: screen.getLengthByOrientation(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) async {
        _lessonIndex = value[0];

        FlutterToastUtil.showLoading(milliseconds: 10000);
        await queryEmptyClassroomData(
          _selectedBuilding["buildingId"],
          _selectedBuilding["campusId"],
        );
        FlutterToastUtil.cancelToast();
        notifyListeners();
      },
    );
    picker.showModal(context);
  }

  /// 根据教学楼名称获取教学楼id和校区id
  Map<String, String> getBuildingIdAndCampusId(String buildingName) {
    for (Map campus in _buildingInfo) {
      for (Map building in campus["buildingList"]) {
        if (building["buildingName"] == buildingName) {
          return {
            "buildingId": building["buildingId"],
            "campusId": campus["campusId"],
          };
        }
      }
    }
    return {};
  }

  /// 点击选择教学楼
  void choiceBuilding(BuildContext context) {
    final screen = ScreenAdaptor();

    List<String> pickerData = [];
    for (Map campus in _buildingInfo) {
      for (Map building in campus["buildingList"]) {
        pickerData.add(building["buildingName"]);
      }
    }

    int index = pickerData.indexOf(_selectedBuilding["buildingName"]);

    var adapter = PickerDataAdapter<String>(pickerData: pickerData);
    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [index],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: screen.getLengthByOrientation(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: screen.getLengthByOrientation(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: screen.getLengthByOrientation(
        vertical: 500.w,
        horizon: 150.w,
      ),
      itemExtent: screen.getLengthByOrientation(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) async {
        FlutterToastUtil.showLoading(milliseconds: 10000);
        String name = picker.getSelectedValues()[0];
        final ids = getBuildingIdAndCampusId(name);
        changeSelectedBuilding(ids["buildingId"]!, ids["campusId"]!, name);
        await queryEmptyClassroomData(
          _selectedBuilding["buildingId"],
          _selectedBuilding["campusId"],
        );
        FlutterToastUtil.cancelToast();
        notifyListeners();
      },
    );
    picker.showModal(context);
  }

  int get lessonIndex => _lessonIndex;
  List get emptyClassroomList => _emptyClassroomList;
  Map get selectedBuilding => _selectedBuilding;
}
