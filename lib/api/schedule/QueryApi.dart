import 'dart:typed_data';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

abstract class QueryApi {
  /// 获取随机图片
  Future<Uint8List> getRandomTwoDimensionalSpace();

  /// 查询个人成绩
  /// - [semester] : 学期
  /// - [retake] : 是否显示补重成绩
  /// - [cachePolicy] : 缓存策略
  Future<List<Map<String, dynamic>>> queryPersonScore(
      {required String semester,
        bool retake = false,
        CachePolicy? cachePolicy});

  /// 查询个人课程
  /// - [week] : 周次
  /// - [semester] : 学期
  Future<List> queryPersonCourse(
      {required String week,
        required String semester,
        CachePolicy? cachePolicy});

  /// 查询个人实验课程
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryPersonExperimentCourse(
      {required String week,
        required String semester,
        CachePolicy? cachePolicy});

  /// 获取学院信息
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryCollegeInfo({
    CachePolicy? cachePolicy,
  });

  /// 获取专业信息
  Future<List<String>> queryMajorInfo({
    required String collegeId,
    required String semester,
    CachePolicy? cachePolicy,
  });

  /// 获取班级课表
  /// - [week] : 周次
  /// - [semester] : 学期
  /// - [majorName] : 专业名称
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryMajorCourse(
      {required String week,
        required String semester,
        required String majorName,
        CachePolicy? cachePolicy});
}