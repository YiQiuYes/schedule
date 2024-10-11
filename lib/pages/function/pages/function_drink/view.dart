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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).function_drink),
      ),
      body: Column(
        children: [
          // 获取选择饮水设备按钮
          deviceDrinkRowBtnWidget(),
          Center(
            child: deviceDrinkBtnWidget(context),
          ),
        ],
      ),
      floatingActionButton: settingFloatBtn(context),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }

  /// 获取选择饮水设备按钮
  Widget deviceDrinkRowBtnWidget() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(vertical: 80.w, horizon: 0),
      ),
      child: GetBuilder<FunctionDrinkLogic>(builder: (logic) {
        List<ButtonSegment<int>> list = [];
        for (int i = 0; i < logic.state.deviceList.length && i < 4; i++) {
          list.add(
            ButtonSegment(
              label: Text(
                logic.formatDeviceName(logic.state.deviceList[i]["name"]),
                style: TextStyle(
                  fontSize: ScreenUtils.length(vertical: 28.sp, horizon: 18.sp),
                ),
              ),
              value: i,
            ),
          );
        }

        // 如果列表为空默认
        if (list.isEmpty) {
          return const SizedBox();
        }

        return SegmentedButton(
          showSelectedIcon: false,
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: ScreenUtils.length(vertical: 28.w, horizon: 18.w),
              ),
            ),
          ),
          segments: list,
          selected: {logic.state.choiceDevice.value},
          onSelectionChanged: (Set<int> newSelected) {
            if (logic.state.drinkStatus.value) {
              return;
            }
            logic.setChoiceDevice(newSelected.first);
          },
        );
      }),
    );
  }

  /// 获取饮水按钮
  Widget deviceDrinkBtnWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtils.length(
          vertical: 250.w,
          horizon: 80.w,
        ),
      ),
      child: GetBuilder<FunctionDrinkLogic>(builder: (logic) {
        return ElevatedButton(
          onPressed: () {
            if (logic.state.choiceDevice.value == -1) {
              return;
            }

            if (logic.state.drinkStatus.value) {
              logic.endDrink();
            } else {
              logic.startDrink();
            }
          },
          style: ButtonStyle(
            elevation: WidgetStateProperty.all(13),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            fixedSize: WidgetStateProperty.all(
              Size(
                ScreenUtils.length(vertical: 300.w, horizon: 150.w),
                ScreenUtils.length(vertical: 300.w, horizon: 150.w),
              ),
            ),
          ),
          child: Text(
            logic.state.drinkStatus.value
                ? S.of(context).function_drink_btn_status_disable
                : S.of(context).function_drink_btn_status_enable,
            style: TextStyle(
              fontSize: ScreenUtils.length(vertical: 55.sp, horizon: 28.sp),
            ),
          ),
        );
      }),
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
}
