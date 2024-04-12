// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impostors/src/presentation/pages/load_create_room_page.dart';
import 'package:impostors/src/presentation/widgets/show_message_snack_bar.dart';
import 'package:impostors/src/utils/app_colors.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  static const routeName = '/create';

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _createRoom() async {
    // Valida username
    final username = _usernameController.text.trimRight();
    if (username.length < 2 || username.length > 32) {
      showMessageSnackBar(context: context, message: 'Username inválido.');
      return;
    }
    // Valida senha
    if (_passwordController.text.length != 6) {
      showMessageSnackBar(context: context, message: 'Senha inválida.');
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.pushNamed(
      context,
      LoadCreateRoomPage.routeName,
      arguments: {
        "username": username,
        "password": _passwordController.text,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Criar uma sala'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _card(),
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _usernameTextField(),
          SizedBox(height: 8),
          _passwordTextField(),
          SizedBox(height: 16),
          _button(),
        ],
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: _createRoom,
        child: Text(
          'Criar',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(6)],
      onChanged: (value) async {
        if (value.length == 6) {
          FocusScope.of(context).requestFocus(FocusNode());
          // await _joinRoom();
        }
      },
      onSubmitted: null,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      style: TextStyle(fontSize: 18),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline),
        suffixIcon: Icon(Icons.lock_outline, color: Colors.transparent),
        hintText: 'Senha',
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.white,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _usernameTextField() {
    return TextField(
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
      controller: _usernameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        prefixIcon: Icon(Icons.person),
        suffixIcon: Icon(Icons.person, color: Colors.transparent),
        hintText: 'Nome de usuário',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}
