// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impostors/src/presentation/pages/create_room_page.dart';
import 'package:impostors/src/presentation/pages/load_room_page.dart';
import 'package:impostors/src/presentation/widgets/impostor_icon.dart';
import 'package:impostors/src/presentation/widgets/show_message_snack_bar.dart';
import 'package:impostors/src/utils/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _showPassword = false;

  Future<void> _joinRoom() async {
    // Valida código
    if (_codeController.text.length != 4) {
      showMessageSnackBar(context: context, message: 'Código inválido.');
      return;
    }
    // Valida senha
    if (_passwordController.text.length != 6) {
      showMessageSnackBar(context: context, message: 'Senha inválida.');
      return;
    }

    // Dialog nome de usuario
    await _showDialog().then((pressed) {
      if (pressed == null || !pressed) return;

      FocusScope.of(context).requestFocus(FocusNode());

      final username = _usernameController.text.trimRight();
      if (username.length < 2 || username.length > 32) {
        showMessageSnackBar(
          context: context,
          message: 'Nome de usuário inválido.',
        );
        return;
      }

      Navigator.pushNamed(
        context,
        LoadRoomPage.routeName,
        arguments: {
          "username": username,
          "roomCode": _codeController.text,
          "password": _passwordController.text,
        },
      );
    });
  }

  Future<bool?> _showDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: Text('Digite seu nome para continuar'),
          content: _usernameTextField(),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Entrar',
                style: TextStyle(
                  color: AppColors.secondaryLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _icon(),
                  _card(),
                  SizedBox(height: 8),
                  _buttonsRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.phone_iphone,
              color: AppColors.secondary,
            ),
            label: Text(
              'Jogar localmente',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, CreateRoomPage.routeName);
            },
            icon: Icon(Icons.group_add),
            label: Text(
              'Criar uma sala',
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Entrar em uma sala',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 32),
            _codeTextField(),
            SizedBox(height: 8),
            _passwordTextField(),
            SizedBox(height: 16),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: AppColors.secondaryDark,
        onPressed: _joinRoom,
        child: Text(
          'Entrar',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _codeTextField() {
    return TextField(
      inputFormatters: [LengthLimitingTextInputFormatter(4)],
      onChanged: (value) {
        if (value.length == 4) {
          setState(() => _showPassword = true);
          FocusScope.of(context).nextFocus();
        }
      },
      controller: _codeController,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: 18),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.groups),
        suffixIcon: Icon(Icons.groups, color: Colors.transparent),
        hintText: 'Código',
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

  Widget _passwordTextField() {
    return AnimatedOpacity(
      opacity: _showPassword ? 1 : 0.25,
      duration: Duration(milliseconds: 300),
      child: TextField(
        inputFormatters: [LengthLimitingTextInputFormatter(6)],
        onChanged: (value) async {
          if (value.length == 6) {
            FocusScope.of(context).requestFocus(FocusNode());
            // await _joinRoom();
          }
        },
        onSubmitted: (value) async => await _joinRoom(),
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
      ),
    );
  }

  Widget _usernameTextField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: 'Nome de usuário',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _icon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ImpostorIcon(size: 96),
    );
  }
}
