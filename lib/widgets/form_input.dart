import 'package:flutter/material.dart';

enum Type {
  email,
  password,
  text,
}

class FormInput extends StatefulWidget {
  final String label;
  final String hint;
  final Type type;
  
  const FormInput({
    required this.label,
    required this.hint,
    required this.type,
    super.key,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late bool _obscureText;
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == Type.password;
  }

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w700, 
            color: theme.textTheme.displayLarge?.color ?? const Color(0xFF2D1B69),
            letterSpacing: 1.2, 
          ),
        ),
        
        const SizedBox(height: 6), 
        
        TextField(
          obscureText: _obscureText, 
          autocorrect: widget.type != Type.password,
          enableSuggestions: widget.type != Type.password,
          keyboardType: switch (widget.type) {
            Type.email => TextInputType.emailAddress,
            Type.text => TextInputType.text,
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
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                )
                : null,
          ),
        ),
      ],
    );
  }
}