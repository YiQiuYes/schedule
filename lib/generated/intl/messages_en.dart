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

  static String m0(lesson) => "Lesson ${lesson}";

  static String m1(score) => "GPA:${score}";

  static String m2(time) => "Time:${time}";

  static String m3(className) => "Course name: ${className}";

  static String m4(room) => "Classroom: ${room}";

  static String m5(teacher) => "Teacher: ${teacher}";

  static String m6(time) => "Time: ${time}";

  static String m7(week) => "Week ${week}";

  static String m8(year, month) => "${year}/${month} Month";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "app_main_function": MessageLookupByLibrary.simpleMessage("function"),
        "app_main_person": MessageLookupByLibrary.simpleMessage("person"),
        "app_main_schedule": MessageLookupByLibrary.simpleMessage("schedule"),
        "function_all_course_loading":
            MessageLookupByLibrary.simpleMessage("Loading..."),
        "function_all_course_title":
            MessageLookupByLibrary.simpleMessage("All courses"),
        "function_area_name":
            MessageLookupByLibrary.simpleMessage("Function area"),
        "function_drink": MessageLookupByLibrary.simpleMessage("ILife"),
        "function_empty_classroom":
            MessageLookupByLibrary.simpleMessage("Empty classroom"),
        "function_empty_classroom_what_lesson": m0,
        "function_exam_plan":
            MessageLookupByLibrary.simpleMessage("Exam schedule"),
        "function_exam_plan_empty":
            MessageLookupByLibrary.simpleMessage("No exam information"),
        "function_life_assistant_area_name":
            MessageLookupByLibrary.simpleMessage("Life assistant"),
        "function_score_empty":
            MessageLookupByLibrary.simpleMessage("No score information"),
        "function_score_gpa": m1,
        "function_score_title": MessageLookupByLibrary.simpleMessage("Score"),
        "function_social_exams":
            MessageLookupByLibrary.simpleMessage("Social exams"),
        "function_social_exams_time": m2,
        "function_teacher_no_data":
            MessageLookupByLibrary.simpleMessage("No teacher information"),
        "function_teacher_search_hint":
            MessageLookupByLibrary.simpleMessage("Teacher name"),
        "function_teacher_title":
            MessageLookupByLibrary.simpleMessage("Teacher schedule"),
        "login_fail": MessageLookupByLibrary.simpleMessage("Login failed"),
        "login_flushbarTitleError":
            MessageLookupByLibrary.simpleMessage("Error"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("LOGIN"),
        "login_passwordHint": MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_not_empty":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "login_statue": MessageLookupByLibrary.simpleMessage("Login status"),
        "login_tile": MessageLookupByLibrary.simpleMessage("Login"),
        "login_timeout": MessageLookupByLibrary.simpleMessage("Login timeout"),
        "login_userHint": MessageLookupByLibrary.simpleMessage("Name"),
        "login_user_not_empty":
            MessageLookupByLibrary.simpleMessage("Name cannot be empty"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "schedule_course_detail":
            MessageLookupByLibrary.simpleMessage("Course details"),
        "schedule_course_name": m3,
        "schedule_course_room": m4,
        "schedule_course_teacher": m5,
        "schedule_course_time": m6,
        "schedule_course_time_tile":
            MessageLookupByLibrary.simpleMessage("1st&2nd&3rd&4th&5th"),
        "schedule_current_week": m7,
        "schedule_week_tile": MessageLookupByLibrary.simpleMessage(
            "Mon&Tues&Wed&Thur&Fri&Sat&Sun"),
        "schedule_year_and_month": m8
      };
}
