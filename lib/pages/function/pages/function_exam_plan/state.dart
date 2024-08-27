import 'package:get/get.dart';

class FunctionExamPlanState {
  // 用于存储个人考试计划数据
  RxList personExamList = [].obs;
  // 是否正在加载
  RxBool isLoading = true.obs;

  FunctionExamPlanState() {
    ///Initialize variables
  }
}
