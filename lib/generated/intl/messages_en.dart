// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(className) => "Course name: ${className}";

  static String m1(room) => "Classroom: ${room}";

  static String m2(teacher) => "Teacher: ${teacher}";

  static String m3(time) => "Time: ${time}";

  static String m4(week) => "Week ${week}";

  static String m5(year, month) => "${year}/${month} Month";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_main_function": MessageLookupByLibrary.simpleMessage("function"),
        "app_main_person": MessageLookupByLibrary.simpleMessage("person"),
        "app_main_schedule": MessageLookupByLibrary.simpleMessage("schedule"),
        "login_fail": MessageLookupByLibrary.simpleMessage("Login failed"),
        "login_flushbarTitleError":
            MessageLookupByLibrary.simpleMessage("Error"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("LOGIN"),
        "login_passwordHint": MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_not_empty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "login_tile": MessageLookupByLibrary.simpleMessage("Login"),
        "login_timeout": MessageLookupByLibrary.simpleMessage("Login timeout"),
        "login_userHint": MessageLookupByLibrary.simpleMessage("Name"),
        "login_user_not_empty":
            MessageLookupByLibrary.simpleMessage("Name cannot be empty"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "schedule_course_detail":
            MessageLookupByLibrary.simpleMessage("Course details"),
        "schedule_course_name": m0,
        "schedule_course_room": m1,
        "schedule_course_teacher": m2,
        "schedule_course_time": m3,
        "schedule_course_time_tile":
            MessageLookupByLibrary.simpleMessage("1st&2nd&3rd&4th&5th"),
        "schedule_current_week": m4,
        "schedule_week_tile": MessageLookupByLibrary.simpleMessage(
            "Mon&Tues&Wed&Thur&Fri&Sat&Sun"),
        "schedule_year_and_month": m5
      };
}
