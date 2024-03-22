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

  static String m0(version) => "Current version ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "loginViewAutoLogin": MessageLookupByLibrary.simpleMessage(
            "Auto login failed, please log in manually!"),
        "loginViewCaptcha": MessageLookupByLibrary.simpleMessage("Captcha"),
        "loginViewCaptchaFailed": MessageLookupByLibrary.simpleMessage(
            "Verification code failed! Please check your network connection!"),
        "loginViewGreatText": MessageLookupByLibrary.simpleMessage(
            "Hello, welcome to use this YiQiu schedule!"),
        "loginViewLoginButton":
            MessageLookupByLibrary.simpleMessage("Let\'s start"),
        "loginViewLoginFiled": MessageLookupByLibrary.simpleMessage(
            "Login failed, please check your username, password, and verification code!"),
        "loginViewPassword": MessageLookupByLibrary.simpleMessage("Password"),
        "loginViewTextEditNoNull": MessageLookupByLibrary.simpleMessage(
            "The username, password, and verification code cannot be empty!"),
        "loginViewTitle": MessageLookupByLibrary.simpleMessage("Login"),
        "loginViewUsername": MessageLookupByLibrary.simpleMessage("Username"),
        "navigationFunction": MessageLookupByLibrary.simpleMessage("function"),
        "navigationPerson": MessageLookupByLibrary.simpleMessage("person"),
        "navigationSchedule": MessageLookupByLibrary.simpleMessage("schedule"),
        "pickerCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "pickerConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "scheduleViewCourseTimeName":
            MessageLookupByLibrary.simpleMessage("1st&2nd&3rd&4th&5th"),
        "scheduleViewCurrentWeek":
            MessageLookupByLibrary.simpleMessage("Week %%"),
        "scheduleViewWeekName": MessageLookupByLibrary.simpleMessage(
            "Mon&Tues&Wed&Thur&Fri&Sat&Sun"),
        "scheduleViewYearAndMonth":
            MessageLookupByLibrary.simpleMessage("%%/&& Month"),
        "settingViewCurrentVersion": m0,
        "settingViewGroupAbout": MessageLookupByLibrary.simpleMessage("About"),
        "settingViewTitle": MessageLookupByLibrary.simpleMessage("Setting"),
        "settingViewUpdateMainTest":
            MessageLookupByLibrary.simpleMessage("Version updates"),
        "updateDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "updateDialogConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "updateDialogCurrentIsLastVersion":
            MessageLookupByLibrary.simpleMessage(
                "The current version is the latest version!")
      };
}
