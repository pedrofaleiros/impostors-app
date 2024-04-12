import 'package:flutter/material.dart';
import 'package:impostors/src/presentation/pages/create_room_page.dart';
import 'package:impostors/src/presentation/pages/home_page.dart';
import 'package:impostors/src/presentation/pages/load_create_room_page.dart';
import 'package:impostors/src/presentation/pages/load_room_page.dart';
import 'package:impostors/src/utils/app_colors.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.routeName,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: AppColors.black,
          secondary: AppColors.secondary,
          onSecondary: AppColors.black,
          error: AppColors.primaryDark,
          onError: AppColors.white,
          background: AppColors.gray2,
          onBackground: AppColors.white,
          surface: AppColors.gray,
          onSurface: AppColors.white,
        ),
      ),
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        LoadRoomPage.routeName: (_) => const LoadRoomPage(),
        LoadCreateRoomPage.routeName: (_) => const LoadCreateRoomPage(),
        CreateRoomPage.routeName: (_) => const CreateRoomPage(),
      },
    );
  }
}
