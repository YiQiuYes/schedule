abstract class LearnUserApi {
  /// 学习通登录
  /// [phone] 手机号
  /// [password] 密码
  /// return 是否登录成功
  Future<bool> userLogin({required String phone, required String password});

  /// 返回全部课程
  /// return 课程列表id
  Future<List> getAllCourse();

  /// 获取用户名
  /// return 用户名
  Future<String> getAccountInfo();

  /// 获取用户鉴权token
  /// return token
  Future<String> getPanToken();
}
