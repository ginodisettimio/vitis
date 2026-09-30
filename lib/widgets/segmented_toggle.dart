import 'package:flutter/material.dart';

class SegmentedOption<T> {
  final T valor;
  final String texto;
  final Color color;

  const SegmentedOption({
    required this.valor,
    required this.texto,
    required this.color,
  });
}

// Switch segmentado: la opción elegida se pinta con su propio color.
class SegmentedToggle<T> extends StatelessWidget {
  final List<SegmentedOption<T>> opciones;
  final T seleccionado;
  final ValueChanged<T> onChanged;

  const SegmentedToggle({
    super.key,
    required this.opciones,
    required this.seleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (final opcion in opciones)
            _Opcion(
              texto: opcion.texto,
              color: opcion.color,
              activa: opcion.valor == seleccionado,
              onTap: () => onChanged(opcion.valor),
            ),
        ],
      ),
    );
  }
}

class _Opcion extends StatelessWidget {
  final String texto;
  final Color color;
  final bool activa;
  final VoidCallback onTap;

  const _Opcion({
    required this.texto,
    required this.color,
    required this.activa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: activa ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            texto,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: activa ? Colors.white : null,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
