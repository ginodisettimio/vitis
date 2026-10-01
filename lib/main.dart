import 'package:flutter/material.dart';
import 'package:vitis/screens/cash_register_screen.dart';
import 'package:vitis/screens/change_password_screen.dart';
import 'package:vitis/screens/expenses_screen.dart';
import 'package:vitis/screens/movements_screen.dart';
import 'package:vitis/screens/forget_password_screen.dart';
import 'package:vitis/screens/main_shell_screen.dart';
import 'package:vitis/screens/add_new_wallet_screen.dart';
import 'package:vitis/screens/login_screen.dart';
import 'package:vitis/screens/register_screen.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/app_bottom_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.themeMode,
      builder: (context, themeMode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        title: "Vitis",
        routes: {
          "/login": (context) => LoginScreen(),
          "/register": (context) => RegisterScreen(),
          "/forgetpassword": (context) => ForgetPasswordScreen(),
          "/changepassword": (context) => ChangePasswordScreen(),
          "/addwallet": (context) => AddWalletScreen(),
          "/expenses": (context) => ExpensesScreen(),
          "/movements": (context) => MovementsScreen(),
          "/cashregister": (context) => CashRegisterScreen(),
          "/dashboard": (context) =>
              MainShellScreen(inicial: NavSection.inicio),
          "/wallets": (context) =>
              MainShellScreen(inicial: NavSection.billeteras),
          "/savings": (context) => MainShellScreen(inicial: NavSection.ahorro),
          "/settings": (context) =>
              MainShellScreen(inicial: NavSection.ajustes),
        },
      ),
    );
  }
}
