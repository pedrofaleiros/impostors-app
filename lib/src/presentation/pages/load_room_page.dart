// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:impostors/src/presentation/pages/room_page.dart';

class LoadRoomPage extends StatelessWidget {
  const LoadRoomPage({super.key});

  static const routeName = '/load';

  @override
  Widget build(BuildContext context) {
    final map =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final username = map['username'];
    final roomCode = map['roomCode'];
    final password = map['password'];

    if (username != null && roomCode != null && password != null) {
      return RoomPage(
        username: username,
        roomCode: roomCode,
        password: password,
      );
    }

    return Placeholder();
  }
}
