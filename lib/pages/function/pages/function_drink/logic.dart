import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/api/drink/drink_api.dart';
import 'package:schedule/global_logic.dart';
import 'package:schedule/pages/camera/view.dart';
import 'package:schedule/pages/login/view.dart';

import '../../../../generated/l10n.dart';
import '../../../app_main/logic.dart';
import '../../function_route_config.dart';
import 'state.dart';

class FunctionDrinkLogic extends GetxController {
  final FunctionDrinkState state = FunctionDrinkState();
  final globalState = Get.find<GlobalLogic>().state;
  final globalLogic = Get.find<GlobalLogic>();

  final drinkApi = DrinkApi();

  @override
  onInit() {
    super.onInit();
    checkLogin();
    // 获取token
    drinkApi.getToken().then((value) {
      state.tokenController.text = value;
    });
  }

  @override
  void dispose() {
    state.deviceStatusTimer?.cancel();
    state.tokenController.dispose();
    super.dispose();
  }

  /// 判断是否需要跳转登录
  void checkLogin() {
    if (!globalState.hui798UserInfo["hui798IsLogin"]) {
      final appMainLogic = Get.find<AppMainLogic>().state;

      if (appMainLogic.orientation.value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.toNamed(FunctionRouteConfig.login,
              id: 2, arguments: {"type": LoginPageType.hui798});
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.offNamed(FunctionRouteConfig.login,
              id: 3, arguments: {"type": LoginPageType.hui798});
        });
      }
    } else {
      getDeviceList();
    }
  }

  /// 获取喝水设备列表
  Future<void> getDeviceList() async {
    // 获取设备列表
    await drinkApi.deviceList().then((value) {
      if (value[0]["name"] == "Account failure") {
        globalLogic.setHui798UserInfo("hui798IsLogin", false);
        state.deviceList.clear();
        setChoiceDevice(-1);
        state.drinkStatus.value = false;
        update();
        checkLogin();
      } else {
        state.deviceList.value = value;
        setChoiceDevice(state.deviceList.isNotEmpty ? 0 : -1);
        update();
      }
    });
  }

  /// 收藏或取消收藏设备
  Future<bool> favoDevice(String id, bool isUnFavo) async {
    return await drinkApi.favoDevice(id: id, isUnFavo: isUnFavo).then((value) {
      if (value) {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_favorite_success,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      } else {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_favorite_fail,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      }
      return value;
    });
  }

  /// 格式化设备名称
  String formatDeviceName(String name) {
    if (name.contains("栋")) {
      return name.replaceAll("栋", "-");
    } else {
      return name;
    }
  }

  /// 改变选中的设备值
  void setChoiceDevice(int device) {
    state.choiceDevice.value = device;
    update();
  }

  /// 开始喝水
  void startDrink() {
    drinkApi
        .startDrink(id: state.deviceList[state.choiceDevice.value]["id"])
        .then((value) {
      if (value) {
        // 使用count增加容错
        int count = 0;
        state.drinkStatus.value = true;
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_switch_start_success,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
        state.deviceStatusTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          bool isAvailable = await drinkApi.isAvailableDevice(
              id: state.deviceList[state.choiceDevice.value]["id"]);
          // logger.i(isAvailable);
          if (isAvailable && count > 3) {
            // state.choiceDevice.value = -1;
            state.drinkStatus.value = false;
            state.deviceStatusTimer?.cancel();
            update();
          } else if (isAvailable) {
            count++;
          }
        });
      } else {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_switch_start_fail,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      }
      update();
    });
  }

  /// 结束喝水
  void endDrink() {
    drinkApi
        .endDrink(id: state.deviceList[state.choiceDevice.value]["id"])
        .then((value) {
      if (value) {
        state.deviceStatusTimer?.cancel();
        state.drinkStatus.value = false;
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_switch_end_success,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      } else {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_switch_end_fail,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      }
      update();
    });
  }

  /// 删除相对应的device
  void removeDeviceByName(String name) {
    state.deviceList.removeWhere((element) => element["name"] == name);
    update();
  }

  /// 扫描二维码逻辑
  void scanQRCode(BuildContext context) async {
    final appMainLogic = Get.find<AppMainLogic>().state;

    // ignore: prefer_typing_uninitialized_variables
    var result;

    if (appMainLogic.orientation.value) {
      result = await Get.toNamed(FunctionRouteConfig.camera, id: 2, arguments: {
        "type": CameraPageType.qrCode,
        "appBarTitle": S.of(context).function_drink_device_qr_code,
      });
    } else {
      result = await Get.toNamed(FunctionRouteConfig.camera, id: 3, arguments: {
        "type": CameraPageType.qrCode,
        "appBarTitle": S.of(context).function_drink_device_qr_code,
      });
    }

    if (result != null) {
      String enc = (result as Map)["enc"];
      enc = enc.split("/").last;

      // 添加到喜好
      bool isFavo = await favoDevice(enc, false);
      if (isFavo) {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_favorite_success,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
        // 获取设备列表
        getDeviceList();
      } else {
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_drink_favorite_fail,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
      }
    }
  }

  /// 设置token
  void setToken(String token) {
    drinkApi.setToken(token: token).then((value) async {
      await globalLogic.setHui798UserInfo("hui798IsLogin", true);
      await getDeviceList();
      update();
    });
  }
}
