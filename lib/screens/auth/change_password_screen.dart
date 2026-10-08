import 'package:flutter/material.dart';
import 'package:vitis/widgets/forms/form_btn.dart';
import 'package:vitis/widgets/forms/form_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscurePasswords = true;

  String _password = '';
  String _confirmPassword = '';

  bool get _isValid {
    return _password.length >= 8 &&
        _confirmPassword.length >= 8 &&
        _password == _confirmPassword;
  }

  void _togglePasswordsVisibility() {
    setState(() {
      _obscurePasswords = !_obscurePasswords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: theme.primaryColor,
                              size: 18,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nueva contraseña",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "Creá una nueva contraseña segura",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Formulario Centrado
                    FormInput(
                      label: "NUEVA CONTRASEÑA",
                      hint: "Mínimo 8 caracteres",
                      type: Type.password,
                      obscureText: _obscurePasswords,
                      onToggleObscure: _togglePasswordsVisibility,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: "CONFIRMAR CONTRASEÑA",
                      hint: "Repetí tu contraseña",
                      type: Type.password,
                      obscureText: _obscurePasswords,
                      onToggleObscure: _togglePasswordsVisibility,
                      onChanged: (value) {
                        setState(() {
                          _confirmPassword = value;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // Botón Guardar
                    Opacity(
                      opacity: _isValid ? 1.0 : 0.5,
                      child: SizedBox(
                        height: 50,
                        child: FormBtn(
                          text: "Guardar",
                          onPressed: () => {
                            if (_isValid)
                              {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (route) => false,
                                ),
                              },
                          },
                        ),
                      ),
                    ),

                    // Spacer inferior (con un flex ligeramente mayor para que quede un poco más arriba que el centro exacto, mejora la estética)
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
