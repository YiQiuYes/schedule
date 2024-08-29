import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:schedule/global_logic.dart';

import '../../../common/utils/screen_utils.dart';
import '../../../generated/l10n.dart';
import 'logic.dart';

class ColorThemePage extends StatelessWidget {
  ColorThemePage({super.key});

  final logic = Get.put(ColorThemeLogic());
  final state = Get.find<ColorThemeLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: CustomScrollView(
        slivers: [
          // 获取SliverList
          sliverListWidget(context),
        ],
      ),
    );
  }

  /// 获取SliverAppBar
  PreferredSizeWidget appBarWidget(BuildContext context) {
    return AppBar(title: Text(S.of(context).setting_choice_color_theme));
  }

  /// 获取SliverList
  Widget sliverListWidget(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      sliver: GetBuilder<ColorThemeLogic>(builder: (logic) {
        return SliverAlignedGrid(
          mainAxisSpacing: ScreenUtils.length(vertical: 15.w, horizon: 10.w),
          crossAxisSpacing: ScreenUtils.length(vertical: 15.w, horizon: 10.w),
          itemCount: logic.colorList.length,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                ScreenUtils.byOrientationReturn(vertical: 3, horizon: 2)!,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                logic.setColorTheme(logic.colorList[index]);
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Container(
                height: ScreenUtils.length(vertical: 300.w, horizon: 150.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ScreenUtils.length(vertical: 15.w, horizon: 10.w),
                  ),
                  color: ColorScheme.fromSeed(
                    seedColor: logic.state.colorMap[logic.colorList[index]]
                        ?["color"] as Color,
                    brightness: Theme.of(context).brightness,
                  ).secondaryContainer,
                  border: Border.all(
                    color: ColorScheme.fromSeed(
                      seedColor: logic.state.colorMap[logic.colorList[index]]
                          ?["color"] as Color,
                      brightness: Theme.of(context).brightness,
                    ).primary,
                    width: ScreenUtils.length(vertical: 1.w, horizon: 0.7.w),
                  ),
                ),
                child: themeBoxWidget(context, index),
              ),
            );
          },
        );
      }),
    );
  }

  /// 获取主题颜色盒子
  Widget themeBoxWidget(BuildContext context, int index) {
    return Column(
      children: [
        // 颜色标题
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtils.length(vertical: 20.w, horizon: 10.w),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtils.length(vertical: 10.w, horizon: 5.w),
            horizontal: ScreenUtils.length(vertical: 15.w, horizon: 10.w),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ScreenUtils.length(vertical: 15.w, horizon: 8.w),
            ),
            color: ColorScheme.fromSeed(
              seedColor: logic.state.colorMap[logic.colorList[index]]?["color"]
                  as Color,
              brightness: Theme.of(context).brightness,
            ).primary.withOpacity(0.8),
          ),
          child: Text(
            logic.state.colorMap[logic.colorList[index]]?["name"] as String,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorScheme.fromSeed(
                seedColor: logic.state.colorMap[logic.colorList[index]]
                    ?["color"] as Color,
                brightness: Theme.of(context).brightness,
              ).onPrimary,
              fontSize: ScreenUtils.length(vertical: 19.sp, horizon: 10.sp),
            ),
          ),
        ),
        // 气泡块
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              top: ScreenUtils.length(vertical: 30.w, horizon: 12.w),
              left: ScreenUtils.length(vertical: 25.w, horizon: 10.w),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ScreenUtils.length(vertical: 15.w, horizon: 15.w),
              ),
              color: ColorScheme.fromSeed(
                seedColor: logic.state.colorMap[logic.colorList[index]]
                    ?["color"] as Color,
                brightness: Theme.of(context).brightness,
              ).secondary,
            ),
            width: ScreenUtils.length(vertical: 120.w, horizon: 60.w),
            height: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(
              top: ScreenUtils.length(vertical: 30.w, horizon: 8.w),
              right: ScreenUtils.length(vertical: 15.w, horizon: 10.w),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ScreenUtils.length(vertical: 15.w, horizon: 15.w),
              ),
              color: ColorScheme.fromSeed(
                seedColor: logic.state.colorMap[logic.colorList[index]]
                    ?["color"] as Color,
                brightness: Theme.of(context).brightness,
              ).secondary,
            ),
            width: ScreenUtils.length(vertical: 120.w, horizon: 60.w),
            height: ScreenUtils.length(vertical: 25.w, horizon: 15.w),
          ),
        ),
        // 选中
        GetBuilder<GlobalLogic>(builder: (globalLogic) {
          return AnimatedOpacity(
            opacity: globalLogic.state.settings["colorTheme"] ==
                    logic.state.colorMap[logic.colorList[index]]?["hex"]
                ? 1.0
                : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtils.length(vertical: 40.w, horizon: 15.w),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ScreenUtils.length(vertical: 30.w, horizon: 19.w),
                  ),
                  color: ColorScheme.fromSeed(
                    seedColor: logic.state.colorMap[logic.colorList[index]]
                        ?["color"] as Color,
                    brightness: Theme.of(context).brightness,
                  ).primary,
                ),
                width: ScreenUtils.length(vertical: 60.w, horizon: 28.w),
                height: ScreenUtils.length(vertical: 60.w, horizon: 28.w),
                child: Icon(
                  Icons.check_rounded,
                  color: ColorScheme.fromSeed(
                    seedColor: logic.state.colorMap[logic.colorList[index]]
                        ?["color"] as Color,
                    brightness: Theme.of(context).brightness,
                  ).onPrimary,
                  size: ScreenUtils.length(vertical: 30.w, horizon: 20.w),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
