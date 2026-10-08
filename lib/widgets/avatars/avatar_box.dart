import 'package:flutter/material.dart';

// Caja con el degradado de la marca para el avatar del usuario.
// El contenido (una inicial o un ícono) se muestra en onPrimary y escala con size.
class AvatarBox extends StatelessWidget {
  final Widget child;
  final double size;

  const AvatarBox({super.key, required this.child, this.size = 50});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.7),
            colorScheme.secondary,
          ],
        ),
        // Proporciones del avatar de 50 original: radio 16, texto 22, ícono 26.
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      alignment: Alignment.center,
      // merge (y no un TextStyle nuevo) para conservar la fuente del tema.
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: size * 0.44,
          fontWeight: FontWeight.w900,
        ),
        child: IconTheme(
          data: IconThemeData(color: colorScheme.onPrimary, size: size * 0.52),
          child: child,
        ),
      ),
    );
  }
}
