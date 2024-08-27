import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/picker.dart';
import 'package:get/get.dart';
import 'package:schedule/global_logic.dart';
import 'package:schedule/pages/app_main/app_main_route_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/utils/platform_utils.dart';
import '../../generated/l10n.dart';
import 'state.dart';

class PersonLogic extends GetxController {
  final PersonState state = PersonState();
  final globalLogic = Get.find<GlobalLogic>();
  final globalState = Get.find<GlobalLogic>().state;

  @override
  void dispose() {
    state.semesterController.dispose();
    state.startDateController.dispose();
    super.dispose();
  }

  /// 初始化
  void init() {
    // 初始化学期和开始日期
    state.semesterController.text = globalState.semesterWeekData["semester"];
    state.startDateController.text = globalState.semesterWeekData["startDay"];
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
      await globalLogic.setStartDate(controller.text);
      globalLogic.refreshData();
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
    state.semesterController.text = select;
    globalLogic.setSemester(select);
    globalLogic.refreshData();
    globalLogic.getPersonCourseData(
      week: globalState.semesterWeekData["currentWeek"],
      semester: select,
    );
  }

  /// 退出登录
  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).person_logout),
        content: Text(S.of(context).person_logout_tip),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(S.of(context).pickerCancel),
          ),
          TextButton(
            onPressed: () async {
              await globalLogic.setScheduleUserInfo("username", "");
              await globalLogic.setScheduleUserInfo("password", "");
              Get.back();
              Get.offAllNamed(AppMainRouteConfig.login, id: 1);
              await globalLogic.setIsLogin(false);
              await globalLogic.setLoad20CountCourse(false);
            },
            child: Text(S.of(context).pickerConfirm),
          ),
        ],
      ),
    );
  }

  /// 加入交流群
  void joinQQGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).person_join_qq_group),
        content: Text(S.of(context).person_join_qq_group_tip),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(S.of(context).pickerCancel),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              if (PlatformUtils.isAndroid || PlatformUtils.isAndroid) {
                launchUrl(
                  Uri.parse(
                      "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=161324332&card_type=group&source=qrcode"),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                launchUrl(
                  Uri.parse(
                      "https://qm.qq.com/cgi-bin/qm/qr?k=GMRIQg1MaMrDM_g7yShEjzK2fLAwf5Lg&jump_from=webapi&authKey=CGtV/q3yj4GX34mX5KcQsSDwD9bULknUAj4NSAhaDnzRqKBp0Uv1KWvzU3nJuYoR"),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: Text(S.of(context).pickerConfirm),
          ),
        ],
      ),
    );
  }
}
