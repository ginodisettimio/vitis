import 'package:flutter/material.dart';

// Botón cuadrado lila con flecha. Sin onTap, cierra la pantalla actual.
class SquareBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SquareBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.chevron_left, color: primary),
      ),
    );
  }
}
