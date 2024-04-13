abstract class LearnSignApi {
  /// 普通签到
  /// return: 签到结果
  Future<String> generalSign({
    required String name,
    required String activeId,
  });

  /// 手势签到
  /// return: 签到结果
  Future<String> gestureSign({
    required String name,
    required String activeId,
    required String signCode,
  });

  /// 拍照签到
  /// return: 签到结果
  Future<String> photoSign({
    required String name,
    required String activeId,
    required String objectId,
  });

  /// 位置签到
  /// return: 签到结果
  Future<String> locationSign({
    required String name,
    required String address,
    required String activeId,
    required String lat,
    required String lon,
  });

  /// 二维码签到
  /// return: 签到结果
  Future<String> qrCodeSign({
    required String enc,
    required String name,
    required String activeId,
    required String address,
    required String lat,
    required String lon,
    required String altitude,
  });

  /// 查询签到信息
  /// return: 签到信息对象
  /// [courses] 课程列表 [{"courseId": "000", "classId": "000"}, ...]
  Future<Map> traverseCourseActivity({required List courses});

  /// 根据activeId获取签到信息
  /// [activeId] 活动id
  /// return: 签到信息对象
  Future<Map> getPPTActiveInfo({required String activeId});

  /// 预签到处理
  /// [activeId] 活动id
  /// [courseId] 课程id
  /// [classId] 班级id
  /// return: 签到结果
  Future<String> preSign(
      {required String activeId,
      required String courseId,
      required String classId});
}
