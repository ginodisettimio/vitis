import 'package:flutter/material.dart';
import 'package:vitis/screens/main_shell_screen.dart';
import 'package:vitis/widgets/icon_barrel.dart';

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
              icon: Icons.eco_outlined,
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
              esBarril: true,
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

class _NavItem extends StatelessWidget {
  final IconData? icon; // Para íconos estándar de Material.
  final bool esBarril; // Para usar el IconoBarril dibujado a mano.
  final String label;
  final bool activo;
  final VoidCallback onTap;

  const _NavItem({
    this.icon,
    this.esBarril = false,
    required this.label,
    required this.activo,
    required this.onTap,
  });

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
            esBarril
                ? IconoBarril(color: c, size: 22)
                : Icon(icon, color: c, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: c, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
