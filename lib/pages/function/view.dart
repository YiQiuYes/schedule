import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class FunctionPage extends StatelessWidget {
  FunctionPage({super.key});

  final logic = Get.put(FunctionLogic());
  final state = Get.find<FunctionLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("FunctionPage"),
    );
  }
}
