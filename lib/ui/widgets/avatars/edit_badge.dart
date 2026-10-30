import 'package:flutter/material.dart';

// Superpone un lápiz en la esquina inferior derecha de child, para indicar
// que se puede editar (avatar del perfil, ícono de cada paso del wizard).
class EditBadge extends StatelessWidget {
  final Widget child;

  const EditBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Icon(Icons.edit, size: 14, color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
