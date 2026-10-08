import 'package:flutter/material.dart';
import 'package:vitis/widgets/avatars/edit_badge.dart';

// Contenido de un paso: ícono con lápiz, título, subtítulo y un campo de texto.
class WizardStepForm extends StatelessWidget {
  final Widget icono;
  final String titulo;
  final String subtitulo;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType teclado;
  final String? prefijo;

  const WizardStepForm({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.teclado = TextInputType.text,
    this.prefijo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        EditBadge(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: icono),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitulo,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: teclado,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefijo,
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color.withValues(alpha: 0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color.withValues(alpha: 0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
