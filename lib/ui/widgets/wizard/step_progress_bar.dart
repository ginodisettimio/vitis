import 'package:flutter/material.dart';

// Barra segmentada: un tramo por paso, pintados hasta el paso actual.
class StepProgressBar extends StatelessWidget {
  final int pasoActual;
  final int totalPasos;

  const StepProgressBar({
    super.key,
    required this.pasoActual,
    required this.totalPasos,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: List.generate(totalPasos, (i) {
        final activo = i <= pasoActual;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i == totalPasos - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: activo ? primary : primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
