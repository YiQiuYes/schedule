import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule/generated/l10n.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            GoRouter.of(context).push(GoRouteConfig.setting);
          },
          leading: const Icon(Icons.settings_rounded),
          title: Text(S.of(context).settingViewTitle),
        ),
      ],
    );
  }
}
