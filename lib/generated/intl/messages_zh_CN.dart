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

  static String m0(className) => "课程名称：${className}";

  static String m1(room) => "上课地点：${room}";

  static String m2(teacher) => "课程教师：${teacher}";

  static String m3(time) => "上课时间：${time}";

  static String m4(week) => "第${week}周";

  static String m5(year, month) => "${year}/${month}月";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_main_function": MessageLookupByLibrary.simpleMessage("功能"),
        "app_main_person": MessageLookupByLibrary.simpleMessage("我的"),
        "app_main_schedule": MessageLookupByLibrary.simpleMessage("课表"),
        "login_fail": MessageLookupByLibrary.simpleMessage("登录失败"),
        "login_flushbarTitleError": MessageLookupByLibrary.simpleMessage("错误"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("登录"),
        "login_passwordHint": MessageLookupByLibrary.simpleMessage("密码"),
        "login_password_not_empty":
            MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "login_tile": MessageLookupByLibrary.simpleMessage("登录"),
        "login_timeout": MessageLookupByLibrary.simpleMessage("登录超时"),
        "login_userHint": MessageLookupByLibrary.simpleMessage("用户名"),
        "login_user_not_empty": MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("确认"),
        "schedule_course_detail": MessageLookupByLibrary.simpleMessage("课程详情"),
        "schedule_course_name": m0,
        "schedule_course_room": m1,
        "schedule_course_teacher": m2,
        "schedule_course_time": m3,
        "schedule_course_time_tile":
            MessageLookupByLibrary.simpleMessage("一&二&三&四&五"),
        "schedule_current_week": m4,
        "schedule_week_tile":
            MessageLookupByLibrary.simpleMessage("周一&周二&周三&周四&周五&周六&周日"),
        "schedule_year_and_month": m5
      };
}
