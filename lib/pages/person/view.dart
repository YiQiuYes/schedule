import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PersonPage extends StatelessWidget {
  PersonPage({super.key});

  final logic = Get.put(PersonLogic());
  final state = Get.find<PersonLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("PersonPage"),
    );
  }
}
