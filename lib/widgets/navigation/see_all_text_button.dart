import 'package:flutter/material.dart';
import 'package:vitis/screens/shell/main_shell_screen.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/navigation/app_bottom_nav_bar.dart';

class SeeAllTextButton extends StatelessWidget {
  final String route;

  const SeeAllTextButton({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Si la ruta es una sección de la barra, se cambia de sección en el contenedor.
        final seccion = NavSection.deRuta(route);
        if (seccion != null) {
          MainShellScreen.irA(context, seccion);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppTheme.primary,
      ),
      child: const Text(
        'Ver todo',
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
