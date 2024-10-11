import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/manager/data_storage_manager.dart';
import 'package:schedule/global_logic.dart';

import '../../../../common/api/schedule/v2/schedule_query_api_v2.dart';
import '../../../../common/utils/screen_utils.dart';
import '../../../../generated/l10n.dart';
import 'state.dart';

class FunctionEmptyClassroomLogic extends GetxController {
  final FunctionEmptyClassroomState state = FunctionEmptyClassroomState();
  final globalState = Get.find<GlobalLogic>().state;

  final storage = DataStorageManager();
  final queryApi = ScheduleQueryApiV2();

  /// 初始化
  void init() async {
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
      state.lessonIndex.value = i;
      if (currentHourAndMinute.compareTo(time[i]) < 0) {
        update();
        break;
      }
    }

    // 读取选择的教学楼
    String? selectedBuildingStr = storage.getString("selectedBuilding");
    if (selectedBuildingStr != null) {
      Map<String, dynamic> map = jsonDecode(selectedBuildingStr);
      map.forEach((key, value) {
        state.selectedBuilding[key] = value;
      });
    } else {
      // 获取教学楼信息
      state.buildingInfo.value = await queryApi.queryBuildingInfo();
      state.selectedBuilding = {
        "buildingId": state.buildingInfo[0]["buildingList"][0]["buildingId"],
        "campusId": state.buildingInfo[0]["campusId"],
        "buildingName": state.buildingInfo[0]["buildingList"][0]
            ["buildingName"],
      };
      storage.setString("selectedBuilding", jsonEncode(state.selectedBuilding));
    }

    // 获取教学楼信息
    state.buildingInfo.value = await queryApi.queryBuildingInfo();

    // 获取空教室列表
    await queryEmptyClassroomData();

    update();
  }

  /// 查询空教室
  Future<void> queryEmptyClassroomData() async {
    state.emptyClassroomList.value = await queryApi.queryEmptyClassroom(
      semester: globalState.semesterWeekData["semester"],
      buildingId: state.selectedBuilding["buildingId"],
      campusId: state.selectedBuilding["campusId"],
      // 星期几
      week: DateTime.now().weekday,
      lesson: state.lessonIndex.value + 1,
      weekly: globalState.semesterWeekData["currentWeek"],
    );
    // 排序
    state.emptyClassroomList.sort((a, b) => a.compareTo(b));
    update();
  }

  /// 修改当前选择的教学楼
  void changeSelectedBuilding(
      String buildingId, String campusId, String buildingName) {
    state.selectedBuilding = {
      "buildingId": buildingId,
      "campusId": campusId,
      "buildingName": buildingName,
    };
    storage.setString("selectedBuilding", jsonEncode(state.selectedBuilding));
  }

  /// 获取第几节课文本
  String getLessonText(BuildContext context, int index) {
    return S.of(context).function_empty_classroom_what_lesson(index + 1);
  }

  /// 点击选择第几节课
  void choiceLesson(BuildContext context) {
    List<String> pickerData = [];
    for (int i = 0; i < 5; i++) {
      pickerData.add(getLessonText(context, i));
    }

    var adapter = PickerDataAdapter<String>(pickerData: pickerData);

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [state.lessonIndex.value],
      changeToFirst: true,
      textAlign: TextAlign.left,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
      ),
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 350.w, horizon: 130.w),
      itemExtent: ScreenUtils.length(vertical: 70.w, horizon: 40.w),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) async {
        state.lessonIndex.value = value[0];

        await queryEmptyClassroomData();

        update();
      },
    );
    picker.showModal(context);
  }

  /// 根据教学楼名称获取教学楼id和校区id
  Map<String, String> getBuildingIdAndCampusId(String buildingName) {
    for (Map campus in state.buildingInfo) {
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
    List<String> pickerData = [];
    for (Map campus in state.buildingInfo) {
      for (Map building in campus["buildingList"]) {
        pickerData.add(building["buildingName"]);
      }
    }

    int index = pickerData.indexOf(state.selectedBuilding["buildingName"]);

    var adapter = PickerDataAdapter<String>(pickerData: pickerData);
    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [index],
      changeToFirst: true,
      textAlign: TextAlign.left,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
      ),
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        right: ScreenUtils.length(vertical: 90.w, horizon: 20.w),
        bottom: ScreenUtils.length(vertical: 50.h, horizon: 20.h),
        top: ScreenUtils.length(vertical: 30.h, horizon: 20.h),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: ScreenUtils.length(vertical: 350.w, horizon: 130.w),
      itemExtent: ScreenUtils.length(vertical: 70.w, horizon: 40.w),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: ScreenUtils.length(vertical: 20.w, horizon: 20.w),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtils.length(
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
              fontSize: ScreenUtils.length(vertical: 22.sp, horizon: 15.sp),
            ),
          ),
        ),
      ),
      onConfirm: (Picker picker, List value) async {
        String name = picker.getSelectedValues()[0];
        final ids = getBuildingIdAndCampusId(name);
        changeSelectedBuilding(ids["buildingId"]!, ids["campusId"]!, name);
        await queryEmptyClassroomData();
        update();
      },
    );
    picker.showModal(context);
  }
}
