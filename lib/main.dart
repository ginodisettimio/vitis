import 'package:flutter/material.dart';
import 'package:vitis/screens/change_password_screen.dart';
import 'package:vitis/screens/forget_password_screen.dart';
import 'package:vitis/screens/dashboard_screen.dart';
import 'package:vitis/screens/wallets_screen.dart';
import 'package:vitis/screens/add_new_wallet_screen.dart';
import 'package:vitis/screens/login_screen.dart';
import 'package:vitis/screens/register_screen.dart';
import 'package:vitis/utils/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // TODO: Cambiar Home si esta logueado a "Dashboard"
      home: const LoginScreen(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: "Vitis",
      routes: {
        "/login": (context) => LoginScreen(),
        "/register": (context) => RegisterScreen(),
        "/forgetpassword": (context) => ForgetPasswordScreen(),
        "/changepassword": (context) => ChangePasswordScreen(),
        "/dashboard": (context) => DashboardScreen(),
        "/wallets": (context) => MyWalletsScreen(),
        "/addwallet": (context) => AddWalletScreen(),
        "/newsaving": (context) => CrearAhorroScreen(),
        "/savings": (context) => MisAhorrosScreen(),
        
      },
    );
  }
}
