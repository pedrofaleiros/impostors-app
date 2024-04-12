// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:impostors/src/presentation/pages/adm_room_page.dart';

class LoadCreateRoomPage extends StatelessWidget {
  const LoadCreateRoomPage({super.key});

  static const routeName = '/load-create';

  @override
  Widget build(BuildContext context) {
    final map =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final username = map['username'];
    final password = map['password'];

    if (username != null && password != null) {
      return AdmRoomPage(
        username: username,
        password: password,
      );
    }

    return Placeholder();
  }
}
