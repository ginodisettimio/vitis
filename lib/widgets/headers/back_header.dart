import 'package:flutter/material.dart';
import 'package:vitis/widgets/navigation/square_back_button.dart';

// Encabezado de pantallas que se abren encima de otra: botón atrás y título.
class BackHeader extends StatelessWidget {
  final String titulo;
  final VoidCallback? onBack;

  const BackHeader({super.key, required this.titulo, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareBackButton(onTap: onBack),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
