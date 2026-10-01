import 'package:flutter/material.dart';
import 'package:vitis/screens/main_shell_screen.dart';
import 'package:vitis/widgets/icon_barrel.dart';
import 'package:vitis/widgets/icon_grape.dart';

// El orden del enum es el orden de las secciones en MainShellScreen.
enum NavSection {
  inicio('/dashboard'),
  billeteras('/wallets'),
  ahorro('/savings'),
  ajustes('/settings');

  final String ruta;
  const NavSection(this.ruta);

  // Sección que corresponde a una ruta, o null si la ruta no es una sección.
  static NavSection? deRuta(String ruta) {
    for (final seccion in values) {
      if (seccion.ruta == ruta) return seccion;
    }
    return null;
  }
}

// Barra inferior con hueco central para el FAB "Nuevo" (ver AppFab).
// Vive fija en MainShellScreen. También se puede poner en pantallas que se abren
// encima del contenedor (ej: ExpensesScreen) con activa en null: al tocar una
// sección, vuelve al contenedor y la selecciona.
class AppBottomNavBar extends StatelessWidget {
  final NavSection? activa;

  const AppBottomNavBar({super.key, this.activa});

  void _ir(BuildContext context, NavSection seccion) {
    if (seccion == activa) return;
    MainShellScreen.irA(context, seccion);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Theme.of(context).cardTheme.color,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              iconWidget: const IconoUva(),
              label: 'Inicio',
              activo: activa == NavSection.inicio,
              onTap: () => _ir(context, NavSection.inicio),
            ),
            _NavItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Billeteras',
              activo: activa == NavSection.billeteras,
              onTap: () => _ir(context, NavSection.billeteras),
            ),
            const SizedBox(width: 40), // espacio para el FAB
            _NavItem(
              iconWidget: const IconoBarril(),
              label: 'Ahorro',
              activo: activa == NavSection.ahorro,
              onTap: () => _ir(context, NavSection.ahorro),
            ),
            _NavItem(
              icon: Icons.settings_outlined,
              label: 'Ajustes',
              activo: activa == NavSection.ajustes,
              onTap: () => _ir(context, NavSection.ajustes),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón central "+" que se encastra en el hueco de AppBottomNavBar.
// Usar junto con floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked.
// Sin onPressed, abre la pantalla de nuevo registro (ingreso / salida).
class AppFab extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppFab({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: const CircleBorder(),
      onPressed:
          onPressed ?? () => Navigator.pushNamed(context, '/cashregister'),
      child: const Icon(Icons.add, size: 28),
    );
  }
}

// Ítem de la barra. Recibe un IconData (icon) o un widget propio (iconWidget),
// uno de los dos. El color activo/inactivo y el tamaño llegan por IconTheme:
// los widgets propios tienen que tomarlos de ahí (como IconoBarril e IconoUva).
class _NavItem extends StatelessWidget {
  static const double _iconSize = 22;

  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final bool activo;
  final VoidCallback onTap;

  const _NavItem({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.activo,
    required this.onTap,
  }) : assert(
         (icon == null) != (iconWidget == null),
         'Pasá icon o iconWidget, uno solo',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = activo
        ? theme.colorScheme.primary
        : theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(color: c, size: _iconSize),
              child: iconWidget ?? Icon(icon),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: c, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
