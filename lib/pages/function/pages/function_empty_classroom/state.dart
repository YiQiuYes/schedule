import 'package:get/get.dart';

class FunctionEmptyClassroomState {
  // 第几节课索引
  RxInt lessonIndex = 0.obs;
  // 教学楼和校区
  RxList buildingInfo = [].obs;
  // 空教室列表
  RxList emptyClassroomList = [].obs;
  // 选择的教学楼
  Map selectedBuilding = {
    "buildingId": "",
    "campusId": "",
    "buildingName": "",
  };

  FunctionEmptyClassroomState() {
    ///Initialize variables
  }
}
