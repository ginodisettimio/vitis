import 'package:flutter/material.dart';
import 'package:vitis/screens/transactions/cash_register_screen.dart';
import 'package:vitis/screens/auth/change_password_screen.dart';
import 'package:vitis/screens/dashboard/expenses_screen.dart';
import 'package:vitis/screens/dashboard/movements_screen.dart';
import 'package:vitis/screens/auth/forget_password_screen.dart';
import 'package:vitis/screens/shell/main_shell_screen.dart';
import 'package:vitis/screens/wallets/add_new_wallet_screen.dart';
import 'package:vitis/screens/auth/login_screen.dart';
import 'package:vitis/screens/auth/register_screen.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/navigation/app_bottom_nav_bar.dart';

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
