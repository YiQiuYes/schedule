import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:schedule/common/utils/logger_utils.dart';

import '../../../../common/api/hut/hut_user_api.dart';
import '../../../../generated/l10n.dart';
import '../../../../global_logic.dart';
import '../../../app_main/logic.dart';
import '../../../login/view.dart';
import '../../function_route_config.dart';
import 'state.dart';

class FunctionHotWaterLogic extends GetxController {
  final FunctionHotWaterState state = FunctionHotWaterState();
  final globalState = Get.find<GlobalLogic>().state;
  final globalLogic = Get.find<GlobalLogic>();

  final hutUserApi = HutUserApi();

  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  /// 判断是否需要跳转登录
  void checkLogin() {
    // globalLogic.setHutUserInfo("hutIsLogin", true);
    // logger.i(globalState.hutUserInfo);
    // getDeviceList();
    if (!globalState.hutUserInfo["hutIsLogin"]) {
      final appMainLogic = Get.find<AppMainLogic>().state;

      if (appMainLogic.orientation.value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.toNamed(FunctionRouteConfig.login,
              id: 2, arguments: {"type": LoginPageType.hut});
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.offNamed(FunctionRouteConfig.login,
              id: 3, arguments: {"type": LoginPageType.hut});
        });
      }
    } else {
      getDeviceList();
    }
  }

  /// 获取喝水设备列表
  Future<void> getDeviceList() async {
    // 获取设备列表
    await hutUserApi.getHotWaterDevice().then((value) async {
      // logger.i(value);
      if (value["code"] == 500) {
        // 登录hut
        if (globalState.hutUserInfo["hutIsLogin"]) {
          bool isLogin = await hutUserApi.userLogin(
              username: globalState.hutUserInfo["username"],
              password: globalState.hutUserInfo["password"]);

          // logger.i(isLogin);
          if (isLogin) {
            await hutUserApi.getHotWaterDevice().then((value) async {
              if (value["code"] != 500) {
                state.deviceList.value = value["data"];
                setChoiceDevice(state.deviceList.isNotEmpty ? 0 : -1);
                await checkHotWaterDevice();
                update();
              }
            });
            return;
          }
        }
        globalLogic.setHutUserInfo("hutIsLogin", false);
        state.deviceList.clear();
        setChoiceDevice(-1);
        state.waterStatus.value = false;
        update();
        checkLogin();
      } else {
        state.deviceList.value = value["data"];
        setChoiceDevice(state.deviceList.isNotEmpty ? 0 : -1);
        await checkHotWaterDevice();
        update();
      }
    });
  }

  /// 检查是否有未关闭的设备
  Future<void> checkHotWaterDevice() async {
    await hutUserApi.checkHotWaterDevice().then((value) {
      if (value.isNotEmpty) {
        state.waterStatus.value = true;
        state.choiceDevice.value = state.deviceList
            .indexWhere((element) => element["poscode"] == value.first);
        Get.snackbar(
          S.current.snackbar_tip,
          S.current.function_hot_water_have_device_not_off,
          backgroundColor: Theme.of(Get.context!).colorScheme.primaryContainer,
          margin: EdgeInsets.only(
            top: 30.w,
            left: 50.w,
            right: 50.w,
          ),
        );
        update();
      }
    });
  }

  /// 改变选中的设备值
  void setChoiceDevice(int device) {
    state.choiceDevice.value = device;
    update();
  }

  /// 开始洗澡
  void startWater() {
    hutUserApi
        .startHotWater(
            device: state.deviceList[state.choiceDevice.value]["poscode"])
        .then((value) {
      if (value) {
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
        state.waterStatus.value = true;
        update();
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

  /// 结束洗澡
  void endWater() {
    // logger.i(state.deviceList[state.choiceDevice.value]["poscode"]);
    hutUserApi
        .stopHotWater(
            device: state.deviceList[state.choiceDevice.value]["poscode"])
        .then((value) {
      if (value) {
        state.waterStatus.value = false;
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
}
