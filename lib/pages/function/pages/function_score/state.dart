import 'package:get/get.dart';

class FunctionScoreState {
  // 用于存储个人成绩数据
  RxList personScoreList = [].obs;

  // 当前选择的学期索引
  RxInt currentSemesterIndex = 0.obs;
  // 是否正在加载
  RxBool isLoading = true.obs;

  FunctionScoreState() {}
}
