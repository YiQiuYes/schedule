import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/common/AlertDialogTextField.dart';
import 'package:schedule/main.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../generated/l10n.dart';

class PersonViewModel with ChangeNotifier {
  // 学期输入框控制器
  final TextEditingController semesterController = TextEditingController();
  // 开始日期输入框控制器
  final TextEditingController startDateController = TextEditingController();

  /// 初始化
  void init() {
    // 初始化学期和开始日期
    semesterController.text = globalModel.semesterWeekData["semester"];
    startDateController.text = globalModel.semesterWeekData["startDay"];
  }

  /// 日期选择器
  Future<void> selectStartDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month}-${picked.day}";
      globalModel.setStartDate(controller.text);
      globalModel.refreshData();
    }
  }

  /// 获取学期列表数据
  PickerDataAdapter<String> getSemesterPickerData() {
    DateTime now = DateTime.now();

    List<String> pickerData = [];

    for (int i = 0; i < 5; i++) {
      // 判断为上半学期还是下班学期
      late int whereSemester;
      if (now.month >= 2 && now.month <= 8) {
        whereSemester = 1;
      } else {
        whereSemester = 0;
      }

      // 计算学期
      if (whereSemester == 1) {
        // 下半学期
        pickerData.add("${now.year - 1}-${now.year}-2");
        pickerData.add("${now.year - 1}-${now.year}-1");
        now = now.subtract(const Duration(days: 365));
      } else {
        // 上半学期
        pickerData.add("${now.year - 1}-${now.year}-1");
        pickerData.add("${now.year - 2}-${now.year - 1}-2");
        now = now.subtract(const Duration(days: 365));
      }
    }

    return PickerDataAdapter<String>(
      pickerData: pickerData,
      isArray: false,
    );
  }

  /// 选择学期类别确认逻辑
  void selectSemesterConfirm(Picker picker, List value) {
    String select = picker.getSelectedValues()[0];
    semesterController.text = select;
    globalModel.setSemester(select);
    globalModel.refreshData();
    globalModel.getPersonCourseData(
      week: globalModel.semesterWeekData["currentWeek"],
      semester: select,
    );
  }

  /// 退出登录
  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialogTextField(
        title: S.of(context).personViewLogout,
        content: Text(S.of(context).personViewLogoutTip),
        confirmText: S.of(context).pickerConfirm,
        cancelText: S.of(context).pickerCancel,
        cancelCallback: () {
          GoRouter.of(context).pop();
        },
        confirmCallback: () {
          globalModel.setUserInfoData("username", "");
          globalModel.setUserInfoData("password", "");
          globalModel.setIsLogin(false);
          globalModel.setLoad20CountCourse(false);
          GoRouter.of(context).go(GoRouteConfig.login);
        },
      ),
    );
  }
}
