import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:schedule/common/components/alertDialogTextField/AlertDialogTextField.dart';
import 'package:schedule/common/components/myPopupMenuButton/MyPopupMenuButton.dart';
import 'package:schedule/pages/function/functionChild/function798/function798ViewModel.dart';

import '../../../../common/utils/ScreenAdaptor.dart';
import '../../../../generated/l10n.dart';

class Function798View extends StatelessWidget {
  const Function798View({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_context) {
        final model = Function798ViewModel();
        Future.delayed(const Duration(milliseconds: 500), () {
          model.init(context);
        });
        return model;
      },
      child: Scaffold(
        appBar: _getAppBar(context),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // 获取选择饮水设备按钮
              _getDeviceDrinkRowBtn(),
              // 获取喝水按钮
              Center(child: _getDrinkBtnWidget(context)),
            ],
          ),
        ),
        floatingActionButton: _getSettingFloatBtn(context),
        floatingActionButtonLocation: ExpandableFab.location,
      ),
    );
  }

  /// 获取设置按钮
  Widget _getSettingFloatBtn(BuildContext context) {
    return Consumer<Function798ViewModel>(
      builder: (context, model, child) {
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
                    return AlertDialogTextField(
                      title: S.of(context).functionViewDrinkDeviceManage,
                      content: SizedBox(
                        width: ScreenAdaptor().getLengthByOrientation(
                          vertical: 400.w,
                          horizon: 300.w,
                        ),
                        child: StatefulBuilder(builder: (context, setState) {
                          List<Widget> listTile = [];
                          for (int i = 0; i < model.deviceList.length; i++) {
                            listTile.add(
                              ListTile(
                                title: Text(
                                  model.getDeviceName(model.deviceList[i]["name"]),
                                ),
                                trailing: MyPopupMenuButton(
                                  itemBuilder: (BuildContext context) {
                                    List<PopupMenuEntry> widget = [];
                                    widget.add(
                                      PopupMenuItem(
                                        value: 0,
                                        child: Text(S
                                            .of(context)
                                            .functionViewDrinkUnfavorite),
                                      ),
                                    );
                                    return widget;
                                  },
                                  child: const Icon(Icons.more_vert_rounded),
                                  onSelected: (select) {
                                    if (select == 0) {
                                      model.favoDevice(
                                          model.deviceList[i]["id"].toString(),
                                          true);
                                      model.removeDeviceByName(
                                          model.deviceList[i]["name"]);
                                      listTile.remove(this);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            );
                          }

                          return ListView(
                            shrinkWrap: true,
                            children: listTile,
                          );
                        }),
                      ),
                      confirmText: S.of(context).pickerConfirm,
                      confirmCallback: () {
                        GoRouter.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: const Icon(Icons.web_stories_rounded),
            ),
            // 添加设备
            Consumer<Function798ViewModel>(builder: (context, model, child) {
              return FloatingActionButton.small(
                onPressed: () {
                  model.scanQRCode(context);
                },
                child: const Icon(Icons.qr_code_scanner_rounded),
              );
            }),
            // token管理
            FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialogTextField(
                      title: S.of(context).functionViewDrinkTokenManageTitle,
                      labelTextList: [
                        S.of(context).functionViewDrinkTokenManageLabel,
                      ],
                      textControllerList: [model.tokenController],
                      confirmText: S.of(context).pickerConfirm,
                      confirmCallback: () {
                        model.setToken(model.tokenController.text);
                        GoRouter.of(context).pop();
                      },
                      cancelText: S.of(context).pickerCancel,
                      cancelCallback: () {
                        GoRouter.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: const Icon(Icons.key_rounded),
            ),
          ],
        );
      },
    );
  }

  /// 获取选择饮水设备按钮
  Widget _getDeviceDrinkRowBtn() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 80.w,
          horizon: 0,
        ),
      ),
      child: Consumer<Function798ViewModel>(builder: (context, model, child) {
        List<ButtonSegment<int>> list = [];
        for (int i = 0; i < model.deviceList.length && i < 4; i++) {
          list.add(
            ButtonSegment(
              label: Text(
                model.getDeviceName(model.deviceList[i]["name"]),
                style: TextStyle(
                  fontSize: ScreenAdaptor().getLengthByOrientation(
                    vertical: 28.sp,
                    horizon: 18.sp,
                  ),
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
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: ScreenAdaptor().getLengthByOrientation(
                  vertical: 28.w,
                  horizon: 18.w,
                ),
              ),
            ),
          ),
          segments: list,
          selected: {model.choiceDevice},
          onSelectionChanged: (Set<int> newSelected) {
            if (model.drinkStatus == 1) {
              return;
            }
            model.setChoiceDevice(newSelected.first);
          },
        );
      }),
    );
  }

  /// 获取AppBar
  PreferredSizeWidget _getAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).functionViewDrink798),
    );
  }

  /// 获取喝水按钮
  Widget _getDrinkBtnWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenAdaptor().getLengthByOrientation(
          vertical: 250.w,
          horizon: 80.w,
        ),
      ),
      child: Consumer<Function798ViewModel>(builder: (context, model, child) {
        return ElevatedButton(
          onPressed: () {
            if (model.deviceList.isEmpty) {
              return;
            }

            switch (model.drinkStatus) {
              case 0:
                model.startDrink(model.deviceList[model.choiceDevice]["id"]);
                break;
              case 1:
                model.endDrink(model.deviceList[model.choiceDevice]["id"]);
                break;
            }
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(13),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
            fixedSize: MaterialStateProperty.all(
              Size(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 300.w,
                  horizon: 150.w,
                ),
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 300.w,
                  horizon: 150.w,
                ),
              ),
            ),
          ),
          child: Text(
            model.drinkStatus == 0
                ? S.of(context).functionViewDrinkBtnStatus0Tip
                : S.of(context).functionViewDrinkBtnStatus1Tip,
            style: TextStyle(
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 55.sp,
                horizon: 28.sp,
              ),
            ),
          ),
        );
      }),
    );
  }
}
