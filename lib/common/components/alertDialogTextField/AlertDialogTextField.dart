import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule/common/utils/ScreenAdaptor.dart';

class AlertDialogTextField extends StatelessWidget {
  const AlertDialogTextField(
      {super.key,
      this.textControllerList,
      this.labelTextList,
      this.hintTextList,
      this.title,
      this.confirmCallback,
      this.confirmText,
      this.cancelCallback,
      this.cancelText,
      this.content});

  final List<TextEditingController>? textControllerList;
  final List<String>? labelTextList;
  final List<String>? hintTextList;
  final String? title;
  final Function? confirmCallback;
  final String? confirmText;
  final Function? cancelCallback;
  final String? cancelText;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenAdaptor();

    // 断言
    assert(!(labelTextList != null && content != null));
    // 断言labelTextList和textControllerList长度相等
    if (labelTextList != null) {
      assert(textControllerList != null);
      assert(labelTextList!.length == textControllerList!.length);
    }

    List<Widget> listWidget = [];
    if (labelTextList != null) {
      for (var i = 0; i < labelTextList!.length; i++) {
        listWidget.addAll([
          getCustomTextFiled(
            context,
            controller: textControllerList![i],
            labelText: labelTextList![i],
            hintText: hintTextList != null ? hintTextList![i] : null,
          ),
          SizedBox(
            height: screen.getLengthByOrientation(
              vertical: 20.w,
              horizon: 13.w,
            ),
          ),
        ]);
      }
      listWidget.removeLast();
    }

    return AlertDialog(
      title: title == null ? null : Text(title!),
      content: content ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: listWidget,
          ),
      actions: [
        Visibility(
          visible: confirmText != null,
          child: TextButton(
            onPressed: () async {
              confirmCallback?.call();
            },
            child: Text(confirmText ?? ""),
          ),
        ),
        Visibility(
          visible: cancelText != null,
          child: TextButton(
            onPressed: () {
              cancelCallback?.call();
            },
            child: Text(cancelText ?? ""),
          ),
        ),
      ],
    );
  }

  static getCustomTextFiled(BuildContext context,
      {TextEditingController? controller,
      String? labelText,
      String? hintText}) {
    final screen = ScreenAdaptor();
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        // 内容边距
        contentPadding: EdgeInsets.only(
          left: screen.getLengthByOrientation(
            vertical: 20.w,
            horizon: 13.w,
          ),
          top: screen.getLengthByOrientation(
            vertical: 18.w,
            horizon: 10.w,
          ),
          bottom: screen.getLengthByOrientation(
            vertical: 18.w,
            horizon: 10.w,
          ),
        ),
        //设置输入框可编辑时的边框样式
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            screen.getLengthByOrientation(
              vertical: 20.w,
              horizon: 17.w,
            ),
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            screen.getLengthByOrientation(
              vertical: 20.w,
              horizon: 17.w,
            ),
          ),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}
