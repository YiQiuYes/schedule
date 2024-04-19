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

  /// `Course details`
  String get scheduleViewCourseDetail {
    return Intl.message(
      'Course details',
      name: 'scheduleViewCourseDetail',
      desc: '',
      args: [],
    );
  }

  /// `Course name:`
  String get scheduleViewCourseName {
    return Intl.message(
      'Course name:',
      name: 'scheduleViewCourseName',
      desc: '',
      args: [],
    );
  }

  /// `Teacher:`
  String get scheduleViewCourseTeacher {
    return Intl.message(
      'Teacher:',
      name: 'scheduleViewCourseTeacher',
      desc: '',
      args: [],
    );
  }

  /// `Classroom:`
  String get scheduleViewCourseRoom {
    return Intl.message(
      'Classroom:',
      name: 'scheduleViewCourseRoom',
      desc: '',
      args: [],
    );
  }

  /// `Time:`
  String get scheduleViewCourseTime {
    return Intl.message(
      'Time:',
      name: 'scheduleViewCourseTime',
      desc: '',
      args: [],
    );
  }

  /// `Function area`
  String get functionViewFunctionAreaName {
    return Intl.message(
      'Function area',
      name: 'functionViewFunctionAreaName',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get functionViewScoreTitle {
    return Intl.message(
      'Score',
      name: 'functionViewScoreTitle',
      desc: '',
      args: [],
    );
  }

  /// `All courses`
  String get functionViewAllCourseTitle {
    return Intl.message(
      'All courses',
      name: 'functionViewAllCourseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Learn through`
  String get functionViewLearnThroughTitle {
    return Intl.message(
      'Learn through',
      name: 'functionViewLearnThroughTitle',
      desc: '',
      args: [],
    );
  }

  /// `ILife798`
  String get functionViewDrink798 {
    return Intl.message(
      'ILife798',
      name: 'functionViewDrink798',
      desc: '',
      args: [],
    );
  }

  /// `Semester`
  String get personViewSemesterTip {
    return Intl.message(
      'Semester',
      name: 'personViewSemesterTip',
      desc: '',
      args: [],
    );
  }

  /// `Start day`
  String get personViewStartDayTip {
    return Intl.message(
      'Start day',
      name: 'personViewStartDayTip',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get personViewLogout {
    return Intl.message(
      'Logout',
      name: 'personViewLogout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get personViewLogoutTip {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'personViewLogoutTip',
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
  String get settingViewUpdateMainText {
    return Intl.message(
      'Version updates',
      name: 'settingViewUpdateMainText',
      desc: '',
      args: [],
    );
  }

  /// `Current version {version}`
  String settingCurrentVersion(Object version) {
    return Intl.message(
      'Current version $version',
      name: 'settingCurrentVersion',
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

  /// `If the download fails, turn on the VPN`
  String get updateDialogToastDownloadingVPN {
    return Intl.message(
      'If the download fails, turn on the VPN',
      name: 'updateDialogToastDownloadingVPN',
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

  /// `Language`
  String get settingViewGroupLanguage {
    return Intl.message(
      'Language',
      name: 'settingViewGroupLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Switch languages`
  String get settingViewSwitchLanguageTip {
    return Intl.message(
      'Switch languages',
      name: 'settingViewSwitchLanguageTip',
      desc: '',
      args: [],
    );
  }

  /// `Follow the system`
  String get settingViewFollowSystem {
    return Intl.message(
      'Follow the system',
      name: 'settingViewFollowSystem',
      desc: '',
      args: [],
    );
  }

  /// `Author: YiQiu`
  String get settingViewAboutApplication {
    return Intl.message(
      'Author: YiQiu',
      name: 'settingViewAboutApplication',
      desc: '',
      args: [],
    );
  }

  /// `QiangZhi Schedule`
  String get settingViewAboutApplicationName {
    return Intl.message(
      'QiangZhi Schedule',
      name: 'settingViewAboutApplicationName',
      desc: '',
      args: [],
    );
  }

  /// `UI`
  String get settingViewGroupInterface {
    return Intl.message(
      'UI',
      name: 'settingViewGroupInterface',
      desc: '',
      args: [],
    );
  }

  /// `Choice of font`
  String get settingViewInterfaceFont {
    return Intl.message(
      'Choice of font',
      name: 'settingViewInterfaceFont',
      desc: '',
      args: [],
    );
  }

  /// `ZhuZiSWan`
  String get settingViewFontZhuZiSWan {
    return Intl.message(
      'ZhuZiSWan',
      name: 'settingViewFontZhuZiSWan',
      desc: '',
      args: [],
    );
  }

  /// `Select a light and shade theme`
  String get settingViewInterfaceTheme {
    return Intl.message(
      'Select a light and shade theme',
      name: 'settingViewInterfaceTheme',
      desc: '',
      args: [],
    );
  }

  /// `Select a color theme`
  String get settingViewChoiceColorTheme {
    return Intl.message(
      'Select a color theme',
      name: 'settingViewChoiceColorTheme',
      desc: '',
      args: [],
    );
  }

  /// `Personalize global color matching`
  String get settingViewChoiceColorSubTitle {
    return Intl.message(
      'Personalize global color matching',
      name: 'settingViewChoiceColorSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Light theme`
  String get settingViewThemeLight {
    return Intl.message(
      'Light theme',
      name: 'settingViewThemeLight',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get settingViewThemeDark {
    return Intl.message(
      'Dark theme',
      name: 'settingViewThemeDark',
      desc: '',
      args: [],
    );
  }

  /// `Deep purple`
  String get deepPurpleColor {
    return Intl.message(
      'Deep purple',
      name: 'deepPurpleColor',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get greenColor {
    return Intl.message(
      'Green',
      name: 'greenColor',
      desc: '',
      args: [],
    );
  }

  /// `Pink`
  String get pinkColor {
    return Intl.message(
      'Pink',
      name: 'pinkColor',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blueColor {
    return Intl.message(
      'Blue',
      name: 'blueColor',
      desc: '',
      args: [],
    );
  }

  /// `Lime`
  String get limeColor {
    return Intl.message(
      'Lime',
      name: 'limeColor',
      desc: '',
      args: [],
    );
  }

  /// `GPA:{score}`
  String functionScoreViewGPA(Object score) {
    return Intl.message(
      'GPA:$score',
      name: 'functionScoreViewGPA',
      desc: '',
      args: [score],
    );
  }

  /// `No score information`
  String get functionScoreViewEmpty {
    return Intl.message(
      'No score information',
      name: 'functionScoreViewEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get functionViewLearnThroughSignIn {
    return Intl.message(
      'Sign in',
      name: 'functionViewLearnThroughSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please check your username and password!`
  String get functionViewLearnThroughLoginError {
    return Intl.message(
      'Login failed, please check your username and password!',
      name: 'functionViewLearnThroughLoginError',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get functionViewLearnThroughLoginSuccess {
    return Intl.message(
      'Login successful!',
      name: 'functionViewLearnThroughLoginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `There are currently no check-in tasks!`
  String get functionViewLearnThroughNoActive {
    return Intl.message(
      'There are currently no check-in tasks!',
      name: 'functionViewLearnThroughNoActive',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to learn through`
  String get functionViewLearnThroughLoginTitle {
    return Intl.message(
      'Sign in to learn through',
      name: 'functionViewLearnThroughLoginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get functionViewLearnThroughLoginPhone {
    return Intl.message(
      'Phone number',
      name: 'functionViewLearnThroughLoginPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get functionViewLearnThroughLoginPassword {
    return Intl.message(
      'Password',
      name: 'functionViewLearnThroughLoginPassword',
      desc: '',
      args: [],
    );
  }

  /// `Gesture sign-in`
  String get functionViewLearnThroughGestureSignTitle {
    return Intl.message(
      'Gesture sign-in',
      name: 'functionViewLearnThroughGestureSignTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in successfully!`
  String get functionViewLearnThroughGestureSignSuccess {
    return Intl.message(
      'Sign in successfully!',
      name: 'functionViewLearnThroughGestureSignSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sign in failed!`
  String get functionViewLearnThroughGestureSignFailed {
    return Intl.message(
      'Sign in failed!',
      name: 'functionViewLearnThroughGestureSignFailed',
      desc: '',
      args: [],
    );
  }

  /// `Sign-in code sign-in`
  String get functionViewLearnThroughSignCodeTitle {
    return Intl.message(
      'Sign-in code sign-in',
      name: 'functionViewLearnThroughSignCodeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in code`
  String get functionViewLearnThroughSignCodeLabel {
    return Intl.message(
      'Sign in code',
      name: 'functionViewLearnThroughSignCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Photo sign-in`
  String get functionViewLearnThroughPhotoSign {
    return Intl.message(
      'Photo sign-in',
      name: 'functionViewLearnThroughPhotoSign',
      desc: '',
      args: [],
    );
  }

  /// `QR code sign-in`
  String get functionViewLearnThroughQRCodeSign {
    return Intl.message(
      'QR code sign-in',
      name: 'functionViewLearnThroughQRCodeSign',
      desc: '',
      args: [],
    );
  }

  /// `Jump to the camera to scan the QR code`
  String get functionViewLearnThroughQRJumpTip {
    return Intl.message(
      'Jump to the camera to scan the QR code',
      name: 'functionViewLearnThroughQRJumpTip',
      desc: '',
      args: [],
    );
  }

  /// `The current QR code is invalid!`
  String get functionViewLearnThroughQRCodeNoCurrent {
    return Intl.message(
      'The current QR code is invalid!',
      name: 'functionViewLearnThroughQRCodeNoCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Location sign-in`
  String get functionViewLearnThroughLocationSignTitle {
    return Intl.message(
      'Location sign-in',
      name: 'functionViewLearnThroughLocationSignTitle',
      desc: '',
      args: [],
    );
  }

  /// `Latitude and longitude`
  String get functionViewLearnThroughLocationSignLatitudeAndLongitude {
    return Intl.message(
      'Latitude and longitude',
      name: 'functionViewLearnThroughLocationSignLatitudeAndLongitude',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get functionViewLearnThroughLocationSignAddress {
    return Intl.message(
      'Address',
      name: 'functionViewLearnThroughLocationSignAddress',
      desc: '',
      args: [],
    );
  }

  /// `Jump to the browser`
  String get functionViewLearnThroughJumpToTheBrowser {
    return Intl.message(
      'Jump to the browser',
      name: 'functionViewLearnThroughJumpToTheBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Get latitude and longitude coordinates from Baidu Maps and fill in the input box. For example:\nCoordinates: 113.114551,27.824458\nAddress: Chongxue Building, Hunan University of Technology, No. 88, Taishan West Road, Tianyuan District, Zhuzhou City, Hunan Province`
  String get functionViewLearnThroughJumpTip {
    return Intl.message(
      'Get latitude and longitude coordinates from Baidu Maps and fill in the input box. For example:\nCoordinates: 113.114551,27.824458\nAddress: Chongxue Building, Hunan University of Technology, No. 88, Taishan West Road, Tianyuan District, Zhuzhou City, Hunan Province',
      name: 'functionViewLearnThroughJumpTip',
      desc: '',
      args: [],
    );
  }

  /// `Chongxue Building, Hunan University of Technology, No. 88, Taishan West Road, Tianyuan District, Zhuzhou City, Hunan Province (Public Teaching Building)`
  String get functionViewLearnThroughAddressHint {
    return Intl.message(
      'Chongxue Building, Hunan University of Technology, No. 88, Taishan West Road, Tianyuan District, Zhuzhou City, Hunan Province (Public Teaching Building)',
      name: 'functionViewLearnThroughAddressHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct coordinates`
  String get functionViewLearnThroughLocationError {
    return Intl.message(
      'Please enter the correct coordinates',
      name: 'functionViewLearnThroughLocationError',
      desc: '',
      args: [],
    );
  }

  /// `No photos found`
  String get functionViewLearnThroughPhotoNoFound {
    return Intl.message(
      'No photos found',
      name: 'functionViewLearnThroughPhotoNoFound',
      desc: '',
      args: [],
    );
  }

  /// `Drink`
  String get functionViewDrinkBtnStatus0Tip {
    return Intl.message(
      'Drink',
      name: 'functionViewDrinkBtnStatus0Tip',
      desc: '',
      args: [],
    );
  }

  /// `Billing`
  String get functionViewDrinkBtnStatus1Tip {
    return Intl.message(
      'Billing',
      name: 'functionViewDrinkBtnStatus1Tip',
      desc: '',
      args: [],
    );
  }

  /// `The device is turned on successfully!`
  String get functionViewDrinkBtnStartSuccess {
    return Intl.message(
      'The device is turned on successfully!',
      name: 'functionViewDrinkBtnStartSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to turn on the device!`
  String get functionViewDrinkBtnStartFail {
    return Intl.message(
      'Failed to turn on the device!',
      name: 'functionViewDrinkBtnStartFail',
      desc: '',
      args: [],
    );
  }

  /// `Settlement successful!`
  String get functionViewDrinkBtnEndSuccess {
    return Intl.message(
      'Settlement successful!',
      name: 'functionViewDrinkBtnEndSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Settlement failed!`
  String get functionViewDrinkBtnEndFail {
    return Intl.message(
      'Settlement failed!',
      name: 'functionViewDrinkBtnEndFail',
      desc: '',
      args: [],
    );
  }

  /// `Log in to Hui Life 798`
  String get functionViewDrinkLoginTitle {
    return Intl.message(
      'Log in to Hui Life 798',
      name: 'functionViewDrinkLoginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get functionViewDrinkLoginPhone {
    return Intl.message(
      'Phone number',
      name: 'functionViewDrinkLoginPhone',
      desc: '',
      args: [],
    );
  }

  /// `Photo Code`
  String get functionViewDrinkLoginPhotoCode {
    return Intl.message(
      'Photo Code',
      name: 'functionViewDrinkLoginPhotoCode',
      desc: '',
      args: [],
    );
  }

  /// `Message Code`
  String get functionViewDrinkLoginMessageCode {
    return Intl.message(
      'Message Code',
      name: 'functionViewDrinkLoginMessageCode',
      desc: '',
      args: [],
    );
  }

  /// `Obtained the SMS verification code successfully!`
  String get functionViewDrinkLoginMessageCodeSuccess {
    return Intl.message(
      'Obtained the SMS verification code successfully!',
      name: 'functionViewDrinkLoginMessageCodeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to obtain SMS verification code!`
  String get functionViewDrinkLoginMessageCodeFail {
    return Intl.message(
      'Failed to obtain SMS verification code!',
      name: 'functionViewDrinkLoginMessageCodeFail',
      desc: '',
      args: [],
    );
  }

  /// `Login success!`
  String get functionViewDrinkLoginSuccess {
    return Intl.message(
      'Login success!',
      name: 'functionViewDrinkLoginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please check if the mobile phone number or verification code is correct!`
  String get functionViewDrinkLoginFail {
    return Intl.message(
      'Please check if the mobile phone number or verification code is correct!',
      name: 'functionViewDrinkLoginFail',
      desc: '',
      args: [],
    );
  }

  /// `Unfavorite`
  String get functionViewDrinkUnfavorite {
    return Intl.message(
      'Unfavorite',
      name: 'functionViewDrinkUnfavorite',
      desc: '',
      args: [],
    );
  }

  /// `Collected successfully!`
  String get functionViewDrinkfavoriteSuccess {
    return Intl.message(
      'Collected successfully!',
      name: 'functionViewDrinkfavoriteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark failed!`
  String get functionViewDrinkfavoriteFail {
    return Intl.message(
      'Bookmark failed!',
      name: 'functionViewDrinkfavoriteFail',
      desc: '',
      args: [],
    );
  }

  /// `Device management`
  String get functionViewDrinkDeviceManage {
    return Intl.message(
      'Device management',
      name: 'functionViewDrinkDeviceManage',
      desc: '',
      args: [],
    );
  }

  /// `No QR code found`
  String get cameraViewNoFoundQRENCODE {
    return Intl.message(
      'No QR code found',
      name: 'cameraViewNoFoundQRENCODE',
      desc: '',
      args: [],
    );
  }

  /// `Camera Preview`
  String get cameraViewAppBarTitle {
    return Intl.message(
      'Camera Preview',
      name: 'cameraViewAppBarTitle',
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
