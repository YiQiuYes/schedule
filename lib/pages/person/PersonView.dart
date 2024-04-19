import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:schedule/generated/l10n.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../common/utils/ScreenAdaptor.dart';
import 'PersonViewModel.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView>
    with AutomaticKeepAliveClientMixin {
  final _screen = ScreenAdaptor();
  final _viewModel = PersonViewModel();

  late List<Widget> _widgetList;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _widgetList = [
      // 获取app图标
      _getAppIcon(),
      // 获取学期和开始日期设置行
      _getSemesterAndStartDate(context),
      // 获取设置项
      _getSettingItem(context),
      // 获取退出登录项
      _getLogoutItem(context),
      // 底部安全间距
      _getBottomSafeArea(),
    ];
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            AnimationLimiter(
              child: SliverList.builder(
                itemCount: _widgetList.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _widgetList[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部安全间距
  Widget _getBottomSafeArea() {
    return SizedBox(
      height: ScreenAdaptor().getLengthByOrientation(
        vertical: 80.h,
        horizon: 150.h,
      ),
    );
  }

  /// 获取app图标
  Widget _getAppIcon() {
    return Container(
      margin: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 50.w,
          horizon: 30.w,
        ),
        bottom: _screen.getLengthByOrientation(
          vertical: 50.w,
          horizon: 30.w,
        ),
      ),
      child: Center(
        child: Lottie.asset(
          "lib/assets/lotties/person.json",
          width: _screen.getLengthByOrientation(
            vertical: 300.w,
            horizon: 180.w,
          ),
          height: _screen.getLengthByOrientation(
            vertical: 300.w,
            horizon: 180.w,
          ),
        ),
      ),
    );
  }

  /// 获取学期和开始日期设置行
  Widget _getSemesterAndStartDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Expanded(child: SizedBox()),
        // 学期设置
        SizedBox(
          width: _screen.getLengthByOrientation(
            vertical: 290.w,
            horizon: 150.w,
          ),
          child: TextField(
            controller: _viewModel.semesterController,
            readOnly: true,
            textAlign: TextAlign.center,
            onTap: () {
              _showSemesterList(context);
            },
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 32.sp,
                horizon: 17.sp,
              ),
            ),
            decoration: InputDecoration(
              labelText: S.of(context).personViewSemesterTip,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // 间隔
        SizedBox(
          width: _screen.getLengthByOrientation(
            vertical: 50.w,
            horizon: 140.w,
          ),
        ),
        // 开始日期设置
        SizedBox(
          width: _screen.getLengthByOrientation(
            vertical: 290.w,
            horizon: 150.w,
          ),
          child: TextField(
            controller: _viewModel.startDateController,
            readOnly: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 32.sp,
                horizon: 17.sp,
              ),
            ),
            decoration: InputDecoration(
              labelText: S.of(context).personViewStartDayTip,
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTap: () {
              _viewModel.selectStartDate(
                  context, _viewModel.startDateController);
            },
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// 学期弹出选择列表
  void _showSemesterList(BuildContext context) {
    var adapter = _viewModel.getSemesterPickerData();

    // 弹出选择器
    Picker picker = Picker(
      adapter: adapter,
      selecteds: [0],
      changeToFirst: true,
      textAlign: TextAlign.left,
      headerDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      columnPadding: EdgeInsets.only(
        left: _screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        right: _screen.getLengthByOrientation(
          vertical: 90.w,
          horizon: 20.w,
        ),
        bottom: _screen.getLengthByOrientation(
          vertical: 50.h,
          horizon: 20.h,
        ),
        top: _screen.getLengthByOrientation(
          vertical: 30.h,
          horizon: 20.h,
        ),
      ),
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: _screen.getLengthByOrientation(
          vertical: 22.sp,
          horizon: 15.sp,
        ),
      ),
      containerColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.01),
      backgroundColor: Colors.transparent,
      height: _screen.getLengthByOrientation(
        vertical: 500.w,
        horizon: 150.w,
      ),
      itemExtent: _screen.getLengthByOrientation(
        vertical: 70.w,
        horizon: 40.w,
      ),
      confirm: Padding(
        padding: EdgeInsets.only(
          right: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doConfirm(context);
          },
          child: Text(
            S.of(context).pickerConfirm,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      cancel: Padding(
        padding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 20.w,
          ),
        ),
        child: TextButton(
          onPressed: () {
            adapter.picker!.doCancel(context);
          },
          child: Text(
            S.of(context).pickerCancel,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 30.sp,
                horizon: 15.sp,
              ),
            ),
          ),
        ),
      ),
      onConfirm: _viewModel.selectSemesterConfirm,
    );
    picker.showModal(context);
  }

  /// 获取设置项
  Widget _getSettingItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 40.w,
          horizon: 25.w,
        ),
      ),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).push(GoRouteConfig.setting);
        },
        leading: Icon(
          Icons.settings_rounded,
          size: _screen.getLengthByOrientation(
            vertical: 38.w,
            horizon: 22.w,
          ),
        ),
        title: Text(
          S.of(context).settingViewTitle,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 32.sp,
              horizon: 17.sp,
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 35.w,
            horizon: 20.w,
          ),
        ),
      ),
    );
  }

  /// 获取退出登录项
  Widget _getLogoutItem(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: _screen.getLengthByOrientation(
          vertical: 40.w,
          horizon: 25.w,
        ),
      ),
      child: ListTile(
        onTap: () {
          _viewModel.logout(context);
        },
        leading: Icon(
          Icons.logout_rounded,
          size: _screen.getLengthByOrientation(
            vertical: 38.w,
            horizon: 22.w,
          ),
        ),
        title: Text(
          S.of(context).personViewLogout,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 32.sp,
              horizon: 17.sp,
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 35.w,
            horizon: 20.w,
          ),
        ),
      ),
    );
  }
}
