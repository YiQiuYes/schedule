import 'package:flutter/material.dart';
import 'package:schedule/route/GoRouteConfig.dart';

class PersonView extends StatefulWidget {
  const PersonView({super.key});

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  @override
  void initState() {
    super.initState();
    GoRouteConfig.setContext = context;
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("页面功能正在开发中"));;
  }
}
