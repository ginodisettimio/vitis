import 'package:flutter/material.dart';
import 'package:vitis/screens/dashboard/dashboard_screen.dart';
import 'package:vitis/screens/savings/savings_screen.dart';
import 'package:vitis/screens/settings/settings_screen.dart';
import 'package:vitis/screens/wallets/wallets_screen.dart';
import 'package:vitis/widgets/navigation/app_bottom_nav_bar.dart';

// Pantalla contenedora: una sola barra inferior y un solo FAB fijos, y en el
// medio cambia la sección. IndexedStack mantiene vivas las cuatro secciones,
// así que cada una conserva su estado (scroll, ahorro desplegado, etc.).
class MainShellScreen extends StatefulWidget {
  final NavSection inicial;

  const MainShellScreen({super.key, this.inicial = NavSection.inicio});

  // Cambia de sección desde cualquier lugar de la app. Si hay pantallas
  // abiertas encima del contenedor (ej: ExpensesScreen), las cierra primero.
  static void irA(BuildContext context, NavSection seccion) {
    final shell = context.findAncestorStateOfType<_MainShellScreenState>() ??
        _MainShellScreenState._activa;

    if (shell == null) {
      // No hay contenedor abierto: se abre uno en esa sección.
      Navigator.pushNamed(context, seccion.ruta);
      return;
    }

    final rutaShell = ModalRoute.of(shell.context);
    if (rutaShell != null) {
      Navigator.of(context).popUntil((route) => route == rutaShell);
    }
    shell._seleccionar(seccion);
  }

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  // Último contenedor abierto, para poder llegar a él desde rutas apiladas encima.
  static _MainShellScreenState? _activa;

  static const List<Widget> _secciones = [
    DashboardScreen(),
    MyWalletsScreen(),
    SavingsScreen(),
    SettingsScreen(),
  ];

  late NavSection _actual = widget.inicial;

  @override
  void initState() {
    super.initState();
    _activa = this;
  }

  @override
  void dispose() {
    if (_activa == this) _activa = null;
    super.dispose();
  }

  void _seleccionar(NavSection seccion) {
    if (seccion == _actual) return;
    setState(() => _actual = seccion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El orden de _secciones sigue el orden del enum NavSection.
      body: IndexedStack(index: _actual.index, children: _secciones),
      floatingActionButton: const AppFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNavBar(activa: _actual),
    );
  }
}
