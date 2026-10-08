import 'package:flutter/material.dart';

class FormBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const FormBtn({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: theme.elevatedButtonTheme.style,
      child: Text(text),
    );
  }
}
