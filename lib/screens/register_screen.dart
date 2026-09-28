import 'package:flutter/material.dart';
import 'package:vitis/widgets/form_btn.dart';
import 'package:vitis/widgets/form_input.dart';
import 'package:vitis/widgets/vitis_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePasswords = true;

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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // Header (Botón atrás + Textos)
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Crear cuenta",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "Completá tus datos para comenzar",
                              style: theme.textTheme.bodyMedium, 
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Logo
                    const Center(child: VitisLogo(width: 130, height: 130)),
                    const SizedBox(height: 24),

                    // Formulario 
                    const FormInput(
                      label: "NOMBRE COMPLETO",
                      hint: "María González",
                      type: Type.text,
                    ),
                    const SizedBox(height: 16),
                    const FormInput(
                      label: "CORREO ELECTRÓNICO",
                      hint: "tu@email.com",
                      type: Type.email,
                    ),
                    const SizedBox(height: 16),
                    
                    // Contraseñas
                    FormInput(
                      label: "CONTRASEÑA",
                      hint: "Mínimo 8 caracteres",
                      type: .password,
                      onToggleObscure: _togglePasswordsVisibility,
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: "CONFIRMAR CONTRASEÑA",
                      hint: "Repetí tu contraseña",
                      type: .password,
                      onToggleObscure: _togglePasswordsVisibility,
                    ),

                    const SizedBox(height: 32),

                    // ─── Botón Crear Cuenta ────────────────────────────────────
                    SizedBox(
                      height: 50,
                      child: FormBtn(
                        text: "Crear cuenta",
                        onPressed: () {
                          // TODO: Lógica de registro
                        },
                      ),
                    ),

                    const Spacer(),

                    // Footer (Iniciar sesión) 
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿Ya tenés cuenta? ",
                            style: theme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); 
                            },
                            child: Text(
                              "Iniciá sesión",
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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