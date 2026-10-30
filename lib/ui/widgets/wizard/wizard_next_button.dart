import 'package:flutter/material.dart';

// Botón principal de ancho completo. Con onPressed en null se muestra deshabilitado.
class WizardNextButton extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const WizardNextButton({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        // Parte del estilo del tema y solo ajusta el estado deshabilitado.
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.4),
          disabledForegroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ).merge(theme.elevatedButtonTheme.style),
        child: Text(texto),
      ),
    );
  }
}
