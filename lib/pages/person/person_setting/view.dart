import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class PersonSettingPage extends StatelessWidget {
  PersonSettingPage({super.key});

  final logic = Get.put(PersonSettingLogic());
  final state = Get.find<PersonSettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PersonSettingPage'),
      ),
    );
  }
}
