import 'package:flutter/material.dart';

// Para un fallo inesperado al guardar o cargar: el detalle queda en el log.
void showErrorSnackBar(BuildContext context, Object error) {
  debugPrint('$error');
  showAppSnackBar(context, 'Algo salió mal. Intentá de nuevo.');
}

void showAppSnackBar(
  BuildContext context,
  String text, {
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: Theme.of(context).textTheme.titleMedium),
      backgroundColor: Theme.of(context).colorScheme.surface,
      duration: duration,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
