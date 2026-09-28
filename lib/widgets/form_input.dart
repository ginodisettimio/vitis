import 'package:flutter/material.dart';
import 'package:vitis/utils/validator.dart';

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
  
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  
  final ValueChanged<String>? onChanged;
  
  const FormInput({
    required this.label,
    required this.hint,
    required this.type,
    this.obscureText = false, 
    this.onToggleObscure,
    this.onChanged, 
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
      if (!Validator.isValidEmail(_currentValue)){
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

            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
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