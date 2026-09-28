import 'package:flutter/material.dart';

enum Type {
  email,
  password,
  text,
  number,
}

class FormInput extends StatefulWidget {
  final String label;
  final String hint;
  final Type type;
  
  // El estado y la acción son controlados estrictamente por el padre
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  
  const FormInput({
    required this.label,
    required this.hint,
    required this.type,
    this.obscureText = false, // Por defecto falso para email y text
    this.onToggleObscure,
    super.key,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  String _currentValue = '';

  String? get _errorText {
    if (_currentValue.isEmpty) return null;

    if (widget.type == Type.email) {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(_currentValue)) {
        return 'Formato de correo inválido';
      }
    }

    if (widget.type == Type.password) {
      if (_currentValue.length < 8) {
        return 'Debe tener al menos 8 caracteres';
      }
    }

    return null; 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isObscure = widget.type == Type.password ? widget.obscureText : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w700, 
            color: theme.colorScheme.onSurface,
            letterSpacing: 1.2, 
          ),
        ),
        
        const SizedBox(height: 6), 
        
        TextField(
          obscureText: isObscure, 
          autocorrect: widget.type != Type.password,
          enableSuggestions: widget.type != Type.password,
          keyboardType: switch (widget.type) {
            Type.email => TextInputType.emailAddress,
            Type.text => TextInputType.text,
            Type.number => TextInputType.number,
            Type.password => TextInputType.visiblePassword,
          },
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: _errorText, 
            suffixIcon: widget.type == Type.password
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: theme.textTheme.bodyMedium?.color, 
                      ),
                      // Disparamos la función directamente sin mutar estado local
                      onPressed: widget.onToggleObscure,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}