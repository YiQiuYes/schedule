import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:schedule/GlobalModel.dart';
import 'package:schedule/common/utils/AppTheme.dart';

import '../../common/utils/ScreenAdaptor.dart';
import '../../generated/l10n.dart';
import 'ColorThemeViewModel.dart';

class ColorThemeView extends StatelessWidget {
  const ColorThemeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ColorThemeViewModel(),
      child: Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 获取SliverAppBar
                _getSliverAppBar(context),
              ];
            },
            body: CustomScrollView(
              slivers: [
                // 获取SliverList
                _getSliverList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 获取SliverAppBar
  Widget _getSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: ScreenAdaptor().getLengthByOrientation(
        vertical: 160.h,
        horizon: 170.h,
      ),
      pinned: true,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          S.of(context).settingViewChoiceColorTheme,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: ScreenAdaptor().getLengthByOrientation(
              vertical: 38.sp,
              horizon: 20.sp,
            ),
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  /// 获取SliverList
  Widget _getSliverList(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.w,
      ),
      sliver: Consumer<ColorThemeViewModel>(builder: (context, model, child) {
        return AnimationLimiter(
          child: SliverAlignedGrid(
            mainAxisSpacing: ScreenAdaptor().getLengthByOrientation(
              vertical: 15.w,
              horizon: 10.w,
            ),
            crossAxisSpacing: ScreenAdaptor().getLengthByOrientation(
              vertical: 15.w,
              horizon: 10.w,
            ),
            itemCount: model.colorList.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  model.setColorTheme(model.colorList[index]);
                },
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        height: ScreenAdaptor().getLengthByOrientation(
                          vertical: 300.w,
                          horizon: 170.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ScreenAdaptor().getLengthByOrientation(
                              vertical: 15.w,
                              horizon: 10.w,
                            ),
                          ),
                          color: ColorScheme.fromSeed(
                            seedColor: model.colorMap[model.colorList[index]]
                                ?["color"],
                            brightness: AppTheme.brightnessMode(context),
                          ).secondaryContainer,
                          border: Border.all(
                            color: ColorScheme.fromSeed(
                              seedColor: model.colorMap[model.colorList[index]]
                                  ?["color"],
                              brightness: AppTheme.brightnessMode(context),
                            ).primary,
                            width: ScreenAdaptor().getLengthByOrientation(
                              vertical: 1.w,
                              horizon: 0.7.w,
                            ),
                          ),
                        ),
                        child: _getThemeBox(context, index, model),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  /// 获取主题颜色盒子
  Widget _getThemeBox(
      BuildContext context, int index, ColorThemeViewModel model) {
    return Column(
      children: [
        // 颜色标题
        Container(
          margin: EdgeInsets.only(
            top: ScreenAdaptor().getLengthByOrientation(
              vertical: 20.w,
              horizon: 10.w,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenAdaptor().getLengthByOrientation(
              vertical: 10.w,
              horizon: 5.w,
            ),
            horizontal: ScreenAdaptor().getLengthByOrientation(
              vertical: 15.w,
              horizon: 10.w,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              ScreenAdaptor().getLengthByOrientation(
                vertical: 15.w,
                horizon: 8.w,
              ),
            ),
            color: ColorScheme.fromSeed(
              seedColor: model.colorMap[model.colorList[index]]?["color"],
              brightness: AppTheme.brightnessMode(context),
            ).primary.withOpacity(0.8),
          ),
          child: Text(
            model.colorMap[model.colorList[index]]?["name"],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorScheme.fromSeed(
                seedColor: model.colorMap[model.colorList[index]]?["color"],
                brightness: AppTheme.brightnessMode(context),
              ).onPrimary,
              fontSize: ScreenAdaptor().getLengthByOrientation(
                vertical: 19.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
        // 气泡块
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(
              top: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 12.w,
              ),
              left: ScreenAdaptor().getLengthByOrientation(
                vertical: 15.w,
                horizon: 13.w,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 15.w,
                  horizon: 15.w,
                ),
              ),
              color: ColorScheme.fromSeed(
                seedColor: model.colorMap[model.colorList[index]]?["color"],
                brightness: AppTheme.brightnessMode(context),
              ).secondary,
            ),
            width: ScreenAdaptor().getLengthByOrientation(
              vertical: 120.w,
              horizon: 100.w,
            ),
            height: ScreenAdaptor().getLengthByOrientation(
              vertical: 25.w,
              horizon: 25.w,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(
              top: ScreenAdaptor().getLengthByOrientation(
                vertical: 30.w,
                horizon: 8.w,
              ),
              right: ScreenAdaptor().getLengthByOrientation(
                vertical: 15.w,
                horizon: 13.w,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ScreenAdaptor().getLengthByOrientation(
                  vertical: 15.w,
                  horizon: 15.w,
                ),
              ),
              color: ColorScheme.fromSeed(
                seedColor: model.colorMap[model.colorList[index]]?["color"],
                brightness: AppTheme.brightnessMode(context),
              ).secondary,
            ),
            width: ScreenAdaptor().getLengthByOrientation(
              vertical: 120.w,
              horizon: 100.w,
            ),
            height: ScreenAdaptor().getLengthByOrientation(
              vertical: 25.w,
              horizon: 25.w,
            ),
          ),
        ),
        // 选中
        Consumer<GlobalModel>(builder: (context, globalModel, child) {
          return AnimatedOpacity(
            opacity: globalModel.settings["colorTheme"] ==
                    model.colorMap[model.colorList[index]]?["hex"]
                ? 1.0
                : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenAdaptor().getLengthByOrientation(
                    vertical: 40.w,
                    horizon: 10.w,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ScreenAdaptor().getLengthByOrientation(
                      vertical: 30.w,
                      horizon: 19.w,
                    ),
                  ),
                  color: ColorScheme.fromSeed(
                    seedColor: model.colorMap[model.colorList[index]]?["color"],
                    brightness: AppTheme.brightnessMode(context),
                  ).primary,
                ),
                width: ScreenAdaptor().getLengthByOrientation(
                  vertical: 60.w,
                  horizon: 38.w,
                ),
                height: ScreenAdaptor().getLengthByOrientation(
                  vertical: 60.w,
                  horizon: 38.w,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: ColorScheme.fromSeed(
                    seedColor: model.colorMap[model.colorList[index]]?["color"],
                    brightness: AppTheme.brightnessMode(context),
                  ).onPrimary,
                  size: ScreenAdaptor().getLengthByOrientation(
                    vertical: 30.w,
                    horizon: 20.w,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
