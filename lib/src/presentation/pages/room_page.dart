// ignore_for_file: avoid_print, prefer_const_constructors, library_prefixes, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:impostors/src/presentation/widgets/impostor_icon.dart';
import 'package:impostors/src/presentation/widgets/show_message_snack_bar.dart';
import 'package:impostors/src/utils/app_colors.dart';
import 'package:impostors/src/utils/socket_constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class User {
  final String id;
  final String username;

  User({required this.id, required this.username});
}

class RoomPage extends StatefulWidget {
  const RoomPage({
    super.key,
    required this.username,
    required this.roomCode,
    required this.password,
  });

  final String username;
  final String roomCode;
  final String password;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late IO.Socket _socket;

  List<User> _users = [];
  String? _admId;
  int? _impostors;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    _socket = IO.io(SC.SOCKET_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect(
      (data) => _socket.emit(SC.JOIN_ROOM, {
        'username': widget.username,
        'roomCode': widget.roomCode,
        'password': widget.password,
      }),
    );

    _socket.on(
      SC.ROOM_DATA,
      (data) {
        try {
          setState(() {
            _admId = data['admId'];
            _impostors = data['impostors'];
          });
        } catch (e) {}
      },
    );

    _socket.on(
      SC.ROOM_PLAYERS,
      (data) {
        try {
          final dataList = data['players'] as List<dynamic>;
          final list = <User>[];

          for (var el in dataList) {
            list.add(User(id: el['id'], username: el['username']));
          }

          setState(() => _users = list);
        } catch (e) {}
      },
    );

    _socket.on(
      SC.ERROR,
      (data) {
        showMessageSnackBar(
          context: context,
          message: data ?? "Erro ao conectar",
        ).then((value) => Navigator.pop(context));
      },
    );
  }

  @override
  void dispose() {
    _socket.clearListeners();
    _socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sala ${widget.roomCode}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ..._usersMap(),
                ],
              ),
              _impostorsRow(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _impostorsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < (_impostors ?? 1); i++)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ImpostorIcon(
                size: 48,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }

  Iterable<Widget> _usersMap() {
    return _users.map(
      (e) {
        final isAdm = _admId != null && e.id == _admId;
        final isYou = widget.username == e.username;

        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isAdm
                    ? AppColors.secondaryLight
                    : isYou
                        ? AppColors.primaryLight
                        : AppColors.white,
                width: isAdm ? 2 : 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  "${e.username} ${isYou ? '(Você)' : ''}",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
