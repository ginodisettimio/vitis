import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Monto grande con prefijo (ej: -$ / +$) y subrayado del color indicado.
class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final String prefijo;
  final Color color;
  final ValueChanged<String>? onChanged;
  final String label;

  const AmountInput({
    super.key,
    required this.controller,
    required this.prefijo,
    required this.color,
    this.onChanged,
    this.label = 'MONTO',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estiloMonto = theme.textTheme.displayLarge?.copyWith(fontSize: 44);
    final subrayado = UnderlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
    );

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              prefijo,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                textAlign: TextAlign.center,
                style: estiloMonto,
                cursorColor: color,
                decoration: InputDecoration(
                  hintText: '0,00',
                  hintStyle: estiloMonto?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  ),
                  // Sin el relleno de inputDecorationTheme: solo el subrayado.
                  filled: false,
                  contentPadding: const EdgeInsets.only(bottom: 4),
                  border: subrayado,
                  enabledBorder: subrayado,
                  focusedBorder: subrayado,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
