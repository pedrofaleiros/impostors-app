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

class AdmRoomPage extends StatefulWidget {
  const AdmRoomPage({
    super.key,
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  State<AdmRoomPage> createState() => _AdmRoomPageState();
}

class _AdmRoomPageState extends State<AdmRoomPage> {
  late IO.Socket _socket;

  List<User> _users = [];
  String? _admId;
  int? _impostors;
  String? _roomCode;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void _setImpostors(int num) {
    _socket.emit(SC.SET_IMPOSTORS, {
      "roomCode": _roomCode,
      "num": num,
    });
  }

  void connectToServer() {
    _socket = IO.io(SC.SOCKET_URL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect(
      (data) => _socket.emit(SC.CREATE_ROOM, {
        'username': widget.username,
        'password': widget.password,
      }),
    );

    _socket.on(
      SC.ADM_DATA,
      (data) {
        try {
          setState(() {
            _roomCode = data['roomCode'];
          });
        } catch (e) {}
      },
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
        backgroundColor: AppColors.secondaryLight,
        foregroundColor: AppColors.gray,
        centerTitle: true,
        title:
            _roomCode == null ? Container() : Text("Sala ${_roomCode ?? ""}"),
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

  Widget _impostorsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _removeImpostorButton(),
          Expanded(child: Container()),
          for (int i = 0; i < (_impostors ?? 1); i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ImpostorIcon(
                size: 48,
                color: AppColors.primary,
              ),
            ),
          Expanded(child: Container()),
          _addImpostorButton(),
        ],
      ),
    );
  }

  Widget _addImpostorButton() {
    return IconButton(
      onPressed: () {
        if (_impostors != null && _impostors! < 3) {
          _setImpostors(_impostors! + 1);
        }
      },
      icon: Icon(Icons.add),
    );
  }

  Widget _removeImpostorButton() {
    return IconButton(
      onPressed: () {
        if (_impostors != null && _impostors! > 1) {
          _setImpostors(_impostors! - 1);
        }
      },
      icon: Icon(Icons.remove),
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
