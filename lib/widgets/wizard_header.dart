import 'package:flutter/material.dart';
import 'package:vitis/widgets/square_back_button.dart';

// Encabezado de un flujo por pasos: botón atrás, título y "Paso X de N".
class WizardHeader extends StatelessWidget {
  final String titulo;
  final int pasoActual;
  final int totalPasos;
  final VoidCallback onBack;

  const WizardHeader({
    super.key,
    required this.titulo,
    required this.pasoActual,
    required this.totalPasos,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SquareBackButton(onTap: onBack),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            Text(
              'Paso ${pasoActual + 1} de $totalPasos',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
