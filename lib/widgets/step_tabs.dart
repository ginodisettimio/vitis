import 'package:flutter/material.dart';

// Nombres de los pasos, resaltando el actual.
class StepTabs extends StatelessWidget {
  final List<String> pasos;
  final int pasoActual;

  const StepTabs({
    super.key,
    required this.pasos,
    required this.pasoActual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(pasos.length, (i) {
        final activo = i == pasoActual;
        return Text(
          pasos[i],
          style: theme.textTheme.bodyMedium?.copyWith(
            color: activo ? theme.colorScheme.primary : null,
            fontWeight: activo ? FontWeight.w800 : FontWeight.normal,
            fontSize: 13,
          ),
        );
      }),
    );
  }
}
