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
  String get navigationSchedule {
    return Intl.message(
      'schedule',
      name: 'navigationSchedule',
      desc: '',
      args: [],
    );
  }

  /// `function`
  String get navigationFunction {
    return Intl.message(
      'function',
      name: 'navigationFunction',
      desc: '',
      args: [],
    );
  }

  /// `person`
  String get navigationPerson {
    return Intl.message(
      'person',
      name: 'navigationPerson',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginViewTitle {
    return Intl.message(
      'Login',
      name: 'loginViewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Hello, welcome to use this YiQiu schedule!`
  String get loginViewGreatText {
    return Intl.message(
      'Hello, welcome to use this YiQiu schedule!',
      name: 'loginViewGreatText',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get loginViewUsername {
    return Intl.message(
      'Username',
      name: 'loginViewUsername',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginViewPassword {
    return Intl.message(
      'Password',
      name: 'loginViewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Captcha`
  String get loginViewCaptcha {
    return Intl.message(
      'Captcha',
      name: 'loginViewCaptcha',
      desc: '',
      args: [],
    );
  }

  /// `Let's start`
  String get loginViewLoginButton {
    return Intl.message(
      'Let\'s start',
      name: 'loginViewLoginButton',
      desc: '',
      args: [],
    );
  }

  /// `The username, password, and verification code cannot be empty!`
  String get loginViewTextEditNoNull {
    return Intl.message(
      'The username, password, and verification code cannot be empty!',
      name: 'loginViewTextEditNoNull',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please check your username, password, and verification code!`
  String get loginViewLoginFiled {
    return Intl.message(
      'Login failed, please check your username, password, and verification code!',
      name: 'loginViewLoginFiled',
      desc: '',
      args: [],
    );
  }

  /// `Auto login failed, please log in manually!`
  String get loginViewAutoLogin {
    return Intl.message(
      'Auto login failed, please log in manually!',
      name: 'loginViewAutoLogin',
      desc: '',
      args: [],
    );
  }

  /// `Verification code failed! Please check your network connection!`
  String get loginViewCaptchaFailed {
    return Intl.message(
      'Verification code failed! Please check your network connection!',
      name: 'loginViewCaptchaFailed',
      desc: '',
      args: [],
    );
  }

  /// `Mon&Tues&Wed&Thur&Fri&Sat&Sun`
  String get scheduleViewWeekName {
    return Intl.message(
      'Mon&Tues&Wed&Thur&Fri&Sat&Sun',
      name: 'scheduleViewWeekName',
      desc: '',
      args: [],
    );
  }

  /// `1st&2nd&3rd&4th&5th`
  String get scheduleViewCourseTimeName {
    return Intl.message(
      '1st&2nd&3rd&4th&5th',
      name: 'scheduleViewCourseTimeName',
      desc: '',
      args: [],
    );
  }

  /// `Week %%`
  String get scheduleViewCurrentWeek {
    return Intl.message(
      'Week %%',
      name: 'scheduleViewCurrentWeek',
      desc: '',
      args: [],
    );
  }

  /// `%%/&& Month`
  String get scheduleViewYearAndMonth {
    return Intl.message(
      '%%/&& Month',
      name: 'scheduleViewYearAndMonth',
      desc: '',
      args: [],
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

  /// `Setting`
  String get settingViewTitle {
    return Intl.message(
      'Setting',
      name: 'settingViewTitle',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get settingViewGroupAbout {
    return Intl.message(
      'About',
      name: 'settingViewGroupAbout',
      desc: '',
      args: [],
    );
  }

  /// `Version updates`
  String get settingViewUpdateMainTest {
    return Intl.message(
      'Version updates',
      name: 'settingViewUpdateMainTest',
      desc: '',
      args: [],
    );
  }

  /// `Current version {version}`
  String settingViewCurrentVersion(Object version) {
    return Intl.message(
      'Current version $version',
      name: 'settingViewCurrentVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Confirm`
  String get updateDialogConfirm {
    return Intl.message(
      'Confirm',
      name: 'updateDialogConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get updateDialogCancel {
    return Intl.message(
      'Cancel',
      name: 'updateDialogCancel',
      desc: '',
      args: [],
    );
  }

  /// `The current version is the latest version!`
  String get updateDialogCurrentIsLastVersion {
    return Intl.message(
      'The current version is the latest version!',
      name: 'updateDialogCurrentIsLastVersion',
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
