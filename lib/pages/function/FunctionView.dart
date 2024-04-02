import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:schedule/route/GoRouteConfig.dart';

import '../../common/utils/ScreenAdaptor.dart';
import '../../generated/l10n.dart';
import 'FunctionViewModel.dart';

class FunctionView extends StatefulWidget {
  const FunctionView({super.key});

  @override
  State<FunctionView> createState() => _FunctionViewState();
}

class _FunctionViewState extends State<FunctionView> {
  final _screen = ScreenAdaptor();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_context) => FunctionViewModel(context: context),
      child: CustomScrollView(
        slivers: <Widget>[
          _getFunctionAreaTitle(S.of(context).functionViewFunctionAreaName),
          _getFunctionCardList(),
        ],
      ),
    );
  }

  /// 功能区域列表
  Widget _getFunctionCardList() {
    return Consumer<FunctionViewModel>(builder: (context, model, child) {
      return SliverPadding(
        padding: EdgeInsets.only(
          left: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 15.w,
          ),
          right: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 15.w,
          ),
          top: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 15.w,
          ),
        ),
        sliver: SliverAlignedGrid.count(
          crossAxisCount: _screen.byOrientationReturn(
            vertical: 5,
            horizon: 6,
          )!,
          itemCount: model.functionCardList.length,
          crossAxisSpacing: _screen.getLengthByOrientation(
            vertical: 10.w,
            horizon: 7.w,
          ),
          mainAxisSpacing: _screen.getLengthByOrientation(
            vertical: 10.w,
            horizon: 7.w,
          ),
          itemBuilder: (context, index) {
            return _getFunctionCardBtn(
              model.functionCardList[index]['title'],
              model.functionCardList[index]['icon'],
              model.functionCardList[index]['route'],
            );
          },
        ),
      );
    });
  }

  /// 获取功能区域按钮
  Widget _getFunctionCardBtn(String title, IconData icon, String route) {
    return ElevatedButton(
      onPressed: () {
        GoRouter.of(context).push(route);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _screen.getLengthByOrientation(
                vertical: 20.w,
                horizon: 15.w,
              ),
            ),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            vertical: _screen.getLengthByOrientation(
              vertical: 17.w,
              horizon: 13.w,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: _screen.getLengthByOrientation(
              vertical: 50.w,
              horizon: 40.w,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          // 间距
          SizedBox(
            height: _screen.getLengthByOrientation(
              vertical: 10.w,
              horizon: 7.w,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: _screen.getLengthByOrientation(
                vertical: 20.sp,
                horizon: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 功能区域标题
  Widget _getFunctionAreaTitle(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: _screen.getLengthByOrientation(
            vertical: 25.w,
            horizon: 5.w,
          ),
          left: _screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 15.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: _screen.getLengthByOrientation(
              vertical: 28.sp,
              horizon: 22.sp,
            ),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
