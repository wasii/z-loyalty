import 'package:flutter/material.dart';
import 'package:loyalty_program/components/constants.dart';
import 'package:loyalty_program/network/user_pref_services.dart';
import 'package:loyalty_program/pages/authentication/login/login_page.dart';
import 'package:loyalty_program/models/user_model.dart';
import 'package:loyalty_program/pages/application/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UserModel? user = await UserPrefsService.getUser();
  bool isRemembered = await UserPrefsService.isRemembered();
  runApp(MyApp(user: user, isRemembered: isRemembered));
}

class MyApp extends StatelessWidget {
  final UserModel? user;
  final bool isRemembered;

  const MyApp({super.key, required this.user, required this.isRemembered});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ziewnic Loyalty Program',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        useMaterial3: false,
      ),
      home: (user != null && isRemembered)
          ? const HomeScreen()
          : const LoginPage(),
    );
  }
}
