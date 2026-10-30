import 'package:flutter/material.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/ui/screens/transactions/cash_register_screen.dart';
import 'package:vitis/ui/screens/auth/change_password_screen.dart';
import 'package:vitis/ui/screens/dashboard/expenses_screen.dart';
import 'package:vitis/ui/screens/dashboard/movements_screen.dart';
import 'package:vitis/ui/screens/auth/forget_password_screen.dart';
import 'package:vitis/ui/screens/shell/main_shell_screen.dart';
import 'package:vitis/ui/screens/wallets/add_new_wallet_screen.dart';
import 'package:vitis/ui/screens/auth/login_screen.dart';
import 'package:vitis/ui/screens/auth/register_screen.dart';
import 'package:vitis/ui/screens/settings/profile_settings_screen.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/ui/widgets/navigation/app_bottom_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // El tema es una preferencia del usuario: cambia con la sesión.
    return ListenableBuilder(
      listenable: SessionStore.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginScreen(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: SessionStore.instance.themeMode,
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
          "/profilesettings": (context) => ProfileSettingsScreen(),
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
