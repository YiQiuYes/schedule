import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../../generated/l10n.dart';
import 'logic.dart';

class FunctionDrinkPage extends StatelessWidget {
  FunctionDrinkPage({super.key});

  final logic = Get.put(FunctionDrinkLogic());
  final state = Get.find<FunctionDrinkLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.init();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).function_drink),
      ),
      body: listViewWidget(context),
    );
  }

  /// ListView widget
  Widget listViewWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 20.w, horizon: 10.w),
      ),
      child: GetBuilder<FunctionDrinkLogic>(builder: (logic) {
        return ListView.builder(
          itemCount: logic.state.deviceList.length,
          itemBuilder: (context, index) {
            return deviceCardWidget(context, logic, index);
          },
        );
      }),
    );
  }

  /// Device card widget
  Widget deviceCardWidget(
    BuildContext context,
    FunctionDrinkLogic state,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtils.length(vertical: 50.w, horizon: 40.w),
        right: ScreenUtils.length(vertical: 50.w, horizon: 40.w),
        bottom: ScreenUtils.length(vertical: 50.w, horizon: 5.w),
      ),
      child: Card(
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
                top: ScreenUtils.length(vertical: 50.w, horizon: 20.w),
                bottom: ScreenUtils.length(vertical: 50.w, horizon: 20.w),
              ),
              child: Text(
                logic.formatDeviceName(logic.state.deviceList[index]["name"]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: ScreenUtils.length(vertical: 50.w, horizon: 30.w),
              ),
              child: Switch(
                value: logic.state.choiceDevice.value == index,
                onChanged: (value) {
                  // 如果当前设备不是选中设备，不执行操作
                  if (logic.state.choiceDevice.value != -1 &&
                      logic.state.choiceDevice.value != index) {
                    return;
                  }

                  if (value) {
                    logic.startDrink(index);
                  } else {
                    logic.endDrink(index);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
