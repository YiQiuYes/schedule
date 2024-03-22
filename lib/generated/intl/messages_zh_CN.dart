// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(version) => "当前版本 ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "loginViewAutoLogin":
            MessageLookupByLibrary.simpleMessage("自动登录失败，请手动登录！"),
        "loginViewCaptcha": MessageLookupByLibrary.simpleMessage("验证码"),
        "loginViewCaptchaFailed":
            MessageLookupByLibrary.simpleMessage("验证码获取失败！请检查网络连接！"),
        "loginViewGreatText":
            MessageLookupByLibrary.simpleMessage("你好，欢迎使用易秋课表！"),
        "loginViewLoginButton": MessageLookupByLibrary.simpleMessage("点击登录"),
        "loginViewLoginFiled":
            MessageLookupByLibrary.simpleMessage("登录失败！请检查用户名、密码、验证码是否正确！"),
        "loginViewPassword": MessageLookupByLibrary.simpleMessage("密码"),
        "loginViewTextEditNoNull":
            MessageLookupByLibrary.simpleMessage("用户名、密码、验证码不能为空！"),
        "loginViewTitle": MessageLookupByLibrary.simpleMessage("登录"),
        "loginViewUsername": MessageLookupByLibrary.simpleMessage("用户名"),
        "navigationFunction": MessageLookupByLibrary.simpleMessage("功能"),
        "navigationPerson": MessageLookupByLibrary.simpleMessage("我的"),
        "navigationSchedule": MessageLookupByLibrary.simpleMessage("课表"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("确认"),
        "scheduleViewCourseTimeName":
            MessageLookupByLibrary.simpleMessage("一&二&三&四&五"),
        "scheduleViewCurrentWeek": MessageLookupByLibrary.simpleMessage("第%%周"),
        "scheduleViewWeekName":
            MessageLookupByLibrary.simpleMessage("周一&周二&周三&周四&周五&周六&周日"),
        "scheduleViewYearAndMonth":
            MessageLookupByLibrary.simpleMessage("%%/&&月"),
        "settingViewCurrentVersion": m0,
        "settingViewGroupAbout": MessageLookupByLibrary.simpleMessage("关于"),
        "settingViewTitle": MessageLookupByLibrary.simpleMessage("设置"),
        "settingViewUpdateMainTest":
            MessageLookupByLibrary.simpleMessage("版本更新"),
        "updateDialogCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "updateDialogConfirm": MessageLookupByLibrary.simpleMessage("确认"),
        "updateDialogCurrentIsLastVersion":
            MessageLookupByLibrary.simpleMessage("当前已是最新版本！")
      };
}
