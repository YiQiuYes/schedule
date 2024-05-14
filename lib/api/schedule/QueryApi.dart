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

  /// 查询个人社会成绩
  /// - [cachePolicy] : 缓存策略
  Future<List<Map<String, dynamic>>> queryPersonSocialExams(
      {CachePolicy? cachePolicy});

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

  /// 获取校区和楼栋信息
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryBuildingInfo({
    CachePolicy? cachePolicy,
  });

  /// 获取空教室
  /// - [semester] : 学期
  /// - [buildingId] : 教学楼ID
  /// - [campusId] : 校区ID
  /// - [week] : 星期几
  /// - [lesson] : 第几节课
  /// - [weekly] : 周次
  /// - [cachePolicy] : 缓存策略
  Future<List> queryEmptyClassroom({
    required String semester,
    required String buildingId,
    required String campusId,
    required int week,
    required int lesson,
    required String weekly,
    CachePolicy? cachePolicy,
  });

  /// 获取教师课表
  /// - [teacherName] : 教师姓名
  /// - [semester] : 学期
  /// - [cachePolicy] : 缓存策略
  Future<List<Map>> queryTeacherCourse({
    required String teacherName,
    required String semester,
    CachePolicy? cachePolicy,
  });
}
