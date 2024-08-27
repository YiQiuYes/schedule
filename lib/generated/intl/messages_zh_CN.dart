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

  static String m0(lesson) => "第${lesson}节课";

  static String m1(score) => "绩点：${score}";

  static String m2(time) => "考试时间：${time}";

  static String m3(className) => "课程名称：${className}";

  static String m4(room) => "上课地点：${room}";

  static String m5(teacher) => "课程教师：${teacher}";

  static String m6(time) => "上课时间：${time}";

  static String m7(week) => "第${week}周";

  static String m8(year, month) => "${year}/${month}月";

  static String m9(version) => "当前版本 ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_main_function": MessageLookupByLibrary.simpleMessage("功能"),
        "app_main_person": MessageLookupByLibrary.simpleMessage("我的"),
        "app_main_schedule": MessageLookupByLibrary.simpleMessage("课表"),
        "function_all_course_loading":
            MessageLookupByLibrary.simpleMessage("正在加载..."),
        "function_all_course_title":
            MessageLookupByLibrary.simpleMessage("全校课表"),
        "function_area_name": MessageLookupByLibrary.simpleMessage("功能区域"),
        "function_drink": MessageLookupByLibrary.simpleMessage("慧生活798"),
        "function_empty_classroom": MessageLookupByLibrary.simpleMessage("空教室"),
        "function_empty_classroom_what_lesson": m0,
        "function_exam_plan": MessageLookupByLibrary.simpleMessage("考试计划"),
        "function_exam_plan_empty":
            MessageLookupByLibrary.simpleMessage("暂无考试安排"),
        "function_life_assistant_area_name":
            MessageLookupByLibrary.simpleMessage("生活助手"),
        "function_score_empty": MessageLookupByLibrary.simpleMessage("暂无成绩"),
        "function_score_gpa": m1,
        "function_score_title": MessageLookupByLibrary.simpleMessage("成绩查询"),
        "function_social_exams": MessageLookupByLibrary.simpleMessage("社会考试"),
        "function_social_exams_time": m2,
        "function_teacher_no_data":
            MessageLookupByLibrary.simpleMessage("暂无教师数据"),
        "function_teacher_search_hint":
            MessageLookupByLibrary.simpleMessage("教师姓名"),
        "function_teacher_title": MessageLookupByLibrary.simpleMessage("教师课表"),
        "login_fail": MessageLookupByLibrary.simpleMessage("登录失败"),
        "login_flushbarTitleError": MessageLookupByLibrary.simpleMessage("错误"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("登录"),
        "login_passwordHint": MessageLookupByLibrary.simpleMessage("密码"),
        "login_password_not_empty":
            MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "login_statue": MessageLookupByLibrary.simpleMessage("登录状态"),
        "login_tile": MessageLookupByLibrary.simpleMessage("登录"),
        "login_timeout": MessageLookupByLibrary.simpleMessage("登录超时"),
        "login_userHint": MessageLookupByLibrary.simpleMessage("用户名"),
        "login_user_not_empty": MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "person_contact": MessageLookupByLibrary.simpleMessage("加入交流"),
        "person_join_qq_group": MessageLookupByLibrary.simpleMessage("加入QQ群"),
        "person_join_qq_group_tip":
            MessageLookupByLibrary.simpleMessage("QQ群号：161324332"),
        "person_logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "person_logout_tip": MessageLookupByLibrary.simpleMessage("确定退出登录？"),
        "person_semester_tip": MessageLookupByLibrary.simpleMessage("学期"),
        "person_start_day_tip": MessageLookupByLibrary.simpleMessage("开始日期"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("确认"),
        "schedule_course_detail": MessageLookupByLibrary.simpleMessage("课程详情"),
        "schedule_course_name": m3,
        "schedule_course_room": m4,
        "schedule_course_teacher": m5,
        "schedule_course_time": m6,
        "schedule_course_time_tile":
            MessageLookupByLibrary.simpleMessage("一&二&三&四&五"),
        "schedule_current_week": m7,
        "schedule_week_tile":
            MessageLookupByLibrary.simpleMessage("周一&周二&周三&周四&周五&周六&周日"),
        "schedule_year_and_month": m8,
        "setting_about_application":
            MessageLookupByLibrary.simpleMessage("作者：易秋"),
        "setting_about_application_name":
            MessageLookupByLibrary.simpleMessage("强智课表"),
        "setting_current_version": m9,
        "setting_group_about": MessageLookupByLibrary.simpleMessage("关于"),
        "setting_title": MessageLookupByLibrary.simpleMessage("设置"),
        "setting_update_main_text":
            MessageLookupByLibrary.simpleMessage("版本更新"),
        "snackbar_tip": MessageLookupByLibrary.simpleMessage("提示"),
        "update_dialog_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "update_dialog_confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "update_dialog_current_is_last_version":
            MessageLookupByLibrary.simpleMessage("当前已是最新版本！"),
        "update_dialog_snackbar_vpn":
            MessageLookupByLibrary.simpleMessage("如果遇到下载失败请开启VPN"),
        "update_dialog_version_fail":
            MessageLookupByLibrary.simpleMessage("版本获取失败！")
      };
}
