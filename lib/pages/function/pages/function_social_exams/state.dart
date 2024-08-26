import 'package:get/get.dart';

class FunctionSocialExamsState {
  // 用于存储个人成绩数据
  RxList personScoreList = [].obs;
  // 是否正在加载
  RxBool isLoading = true.obs;

  FunctionSocialExamsState() {
    ///Initialize variables
  }
}
