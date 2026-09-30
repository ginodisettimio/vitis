import 'package:flutter/material.dart';

// Botón de ancho completo con borde y un "+" delante del texto.
class OutlinedAddButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const OutlinedAddButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: primary, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(color: primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
