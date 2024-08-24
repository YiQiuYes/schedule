import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});

  final logic = Get.put(ScheduleLogic());
  final state = Get.find<ScheduleLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("SchedulePage"),
    );
  }
}
