import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DataStorageManager {
  DataStorageManager._privateConstructor();
  static final DataStorageManager _instance =
      DataStorageManager._privateConstructor();
  factory DataStorageManager() {
    return _instance;
  }

  late SharedPreferences _preferences;
  // 初始化数组存储器
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// 根据key存储int类型
  Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  /// 根据key获取int类型
  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// 根据key存储double类型
  Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  /// 根据key获取double类型
  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// 根据key存储字符串类型
  Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  /// 根据key获取字符串类型
  String? getString(String key) {
    return _preferences.getString(key);
  }

  /// 根据key存储布尔类型
  Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  /// 根据key获取布尔类型
  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// 通用设置持久化数据
  setLocalStorage<T>(String key, T value) {
    String type = value.runtimeType.toString();

    switch (type) {
      case "String":
        setString(key, value as String);
        break;
      case "int":
        setInt(key, value as int);
        break;
      case "bool":
        setBool(key, value as bool);
        break;
      case "double":
        setDouble(key, value as double);
        break;
    }
  }

  /// 获取持久化数据
  dynamic getLocalStorage<T>(String key) {
    dynamic value = _preferences.get(key);
    return value;
  }

  /// 获取持久化数据中所有存入的key
  Set<String> getKeys() {
    return _preferences.getKeys();
  }

  /// 获取持久化数据中是否包含某个key
  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  /// 删除持久化数据中某个key
  Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// 清除所有持久化数据
  Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// 重新加载所有数据,仅重载运行时
  Future<void> reload() async {
    return await _preferences.reload();
  }

  /// 修改持久化数据中某个key的值
  Future<bool> modifyMap(String key, String mapKey, dynamic value) async {
    String? dataStr = _preferences.getString(key);
    if (dataStr != null) {
      Map<String, dynamic> map = jsonDecode(dataStr);

      map[mapKey] = value;
      return await _preferences.setString(key, jsonEncode(map));
    } else {
      Map<String, dynamic> map = {};
      map[mapKey] = value;
      return await _preferences.setString(key, jsonEncode(map));
    }
  }
}
