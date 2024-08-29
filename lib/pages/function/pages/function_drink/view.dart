import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';
import 'package:schedule/common/utils/screen_utils.dart';

import '../../../../common/widget/my_popup_menu/my_popup_menu.dart';
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
      floatingActionButton: settingFloatBtn(context),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }

  /// 获取设置按钮
  Widget settingFloatBtn(BuildContext context) {
    return GetBuilder<FunctionDrinkLogic>(
      builder: (logic) {
        return ExpandableFab(
          type: ExpandableFabType.fan,
          children: [
            // 设备管理
            FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(S.of(context).function_drink_device_manage),
                      content: SizedBox(
                        width:
                            ScreenUtils.length(vertical: 400.w, horizon: 300.w),
                        child: StatefulBuilder(builder: (context, setState) {
                          List<Widget> widget = [];
                          for (int i = 0;
                              i < logic.state.deviceList.length;
                              i++) {
                            widget.add(MyPopupMenuButton(
                              position: PopupMenuPosition.under,
                              offset: Offset(
                                  ScreenUtils.length(
                                      vertical: 100.w, horizon: 60.w),
                                  0),
                              itemBuilder: (BuildContext context) {
                                List<PopupMenuEntry> widget = [];
                                widget.add(
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(S
                                        .of(context)
                                        .function_drink_unfavorite),
                                  ),
                                );
                                return widget;
                              },
                              child: ListTile(
                                title: Text(
                                  logic.formatDeviceName(
                                      logic.state.deviceList[i]["name"]),
                                ),
                                trailing: const Icon(Icons.more_vert_rounded),
                              ),
                              onSelected: (select) {
                                if (select == 0) {
                                  logic.favoDevice(
                                      logic.state.deviceList[i]["id"]
                                          .toString(),
                                      true);
                                  logic.removeDeviceByName(
                                      logic.state.deviceList[i]["name"]);
                                  widget.remove(this);
                                  setState(() {});
                                }
                              },
                            ));
                          }

                          return ListView(
                            shrinkWrap: true,
                            children: widget,
                          );
                        }),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(S.of(context).pickerConfirm),
                        ),
                      ],
                    );
                  },
                );
              },
              heroTag: 'deviceManage',
              child: const Icon(Icons.web_stories_rounded),
            ),
            // 添加设备
            FloatingActionButton.small(
              onPressed: () {
                logic.scanQRCode(context);
              },
              heroTag: 'addDevice',
              child: const Icon(Icons.qr_code_scanner_rounded),
            ),
            // token管理
            FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title:
                          Text(S.of(context).function_drink_token_manage_title),
                      content: TextField(
                        controller: logic.state.tokenController,
                        decoration: InputDecoration(
                          labelText:
                              S.of(context).function_drink_token_manage_label,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(S.of(context).pickerCancel),
                        ),
                        TextButton(
                          onPressed: () {
                            logic.setToken(logic.state.tokenController.text);
                            Get.back();
                          },
                          child: Text(S.of(context).pickerConfirm),
                        ),
                      ],
                    );
                  },
                );
              },
              heroTag: 'tokenManage',
              child: const Icon(Icons.key_rounded),
            ),
          ],
        );
      },
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
