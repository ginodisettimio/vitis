import 'package:flutter/material.dart';
import 'package:vitis/widgets/icon_barrel.dart';

enum NavSection { cuentas, inicio, ahorro, gastos }

// Barra inferior con hueco central para el FAB "Nuevo".
class AppBottomNavBar extends StatelessWidget {
  final NavSection activa;

  const AppBottomNavBar({super.key, required this.activa});

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
              icon: Icons.credit_card,
              label: 'Cuentas',
              activo: activa == NavSection.cuentas,
            ),
            _NavItem(
              icon: Icons.eco_outlined,
              label: 'Inicio',
              activo: activa == NavSection.inicio,
            ),
            const SizedBox(width: 40), // espacio para el FAB
            _NavItem(
              esBarril: true,
              label: 'Ahorro',
              activo: activa == NavSection.ahorro,
            ),
            _NavItem(
              icon: Icons.bar_chart_outlined,
              label: 'Gastos',
              activo: activa == NavSection.gastos,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData? icon; // Para íconos estándar de Material.
  final bool esBarril; // Para usar el IconoBarril dibujado a mano.
  final String label;
  final bool activo;

  const _NavItem({
    this.icon,
    this.esBarril = false,
    required this.label,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = activo
        ? theme.colorScheme.primary
        : theme.textTheme.bodyMedium?.color ?? Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        esBarril
            ? IconoBarril(color: c, size: 22)
            : Icon(icon, color: c, size: 22),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: c, fontSize: 11)),
      ],
    );
  }
}
