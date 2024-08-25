// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `schedule`
  String get app_main_schedule {
    return Intl.message(
      'schedule',
      name: 'app_main_schedule',
      desc: '',
      args: [],
    );
  }

  /// `function`
  String get app_main_function {
    return Intl.message(
      'function',
      name: 'app_main_function',
      desc: '',
      args: [],
    );
  }

  /// `person`
  String get app_main_person {
    return Intl.message(
      'person',
      name: 'app_main_person',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_tile {
    return Intl.message(
      'Login',
      name: 'login_tile',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get login_userHint {
    return Intl.message(
      'Name',
      name: 'login_userHint',
      desc: '',
      args: [],
    );
  }

  /// `Name cannot be empty`
  String get login_user_not_empty {
    return Intl.message(
      'Name cannot be empty',
      name: 'login_user_not_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get login_passwordHint {
    return Intl.message(
      'Password',
      name: 'login_passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get login_password_not_empty {
    return Intl.message(
      'Password cannot be empty',
      name: 'login_password_not_empty',
      desc: '',
      args: [],
    );
  }

  /// `LOGIN`
  String get login_loginButton {
    return Intl.message(
      'LOGIN',
      name: 'login_loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get login_flushbarTitleError {
    return Intl.message(
      'Error',
      name: 'login_flushbarTitleError',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get login_fail {
    return Intl.message(
      'Login failed',
      name: 'login_fail',
      desc: '',
      args: [],
    );
  }

  /// `Login timeout`
  String get login_timeout {
    return Intl.message(
      'Login timeout',
      name: 'login_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Mon&Tues&Wed&Thur&Fri&Sat&Sun`
  String get schedule_week_tile {
    return Intl.message(
      'Mon&Tues&Wed&Thur&Fri&Sat&Sun',
      name: 'schedule_week_tile',
      desc: '',
      args: [],
    );
  }

  /// `1st&2nd&3rd&4th&5th`
  String get schedule_course_time_tile {
    return Intl.message(
      '1st&2nd&3rd&4th&5th',
      name: 'schedule_course_time_tile',
      desc: '',
      args: [],
    );
  }

  /// `Week {week}`
  String schedule_current_week(Object week) {
    return Intl.message(
      'Week $week',
      name: 'schedule_current_week',
      desc: '',
      args: [week],
    );
  }

  /// `{year}/{month} Month`
  String schedule_year_and_month(Object year, Object month) {
    return Intl.message(
      '$year/$month Month',
      name: 'schedule_year_and_month',
      desc: '',
      args: [year, month],
    );
  }

  /// `Course details`
  String get schedule_course_detail {
    return Intl.message(
      'Course details',
      name: 'schedule_course_detail',
      desc: '',
      args: [],
    );
  }

  /// `Course name: {className}`
  String schedule_course_name(Object className) {
    return Intl.message(
      'Course name: $className',
      name: 'schedule_course_name',
      desc: '',
      args: [className],
    );
  }

  /// `Teacher: {teacher}`
  String schedule_course_teacher(Object teacher) {
    return Intl.message(
      'Teacher: $teacher',
      name: 'schedule_course_teacher',
      desc: '',
      args: [teacher],
    );
  }

  /// `Classroom: {room}`
  String schedule_course_room(Object room) {
    return Intl.message(
      'Classroom: $room',
      name: 'schedule_course_room',
      desc: '',
      args: [room],
    );
  }

  /// `Time: {time}`
  String schedule_course_time(Object time) {
    return Intl.message(
      'Time: $time',
      name: 'schedule_course_time',
      desc: '',
      args: [time],
    );
  }

  /// `Confirm`
  String get pickerConfirm {
    return Intl.message(
      'Confirm',
      name: 'pickerConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get pickerCancel {
    return Intl.message(
      'Cancel',
      name: 'pickerCancel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
