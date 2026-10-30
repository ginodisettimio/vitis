import 'package:flutter/material.dart';

// Texto para las secciones sin datos (por ejemplo, en una cuenta nueva).
class EmptyMessage extends StatelessWidget {
  final String text;

  const EmptyMessage(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
