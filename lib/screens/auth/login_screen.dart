import 'package:flutter/material.dart';
import 'package:vitis/widgets/forms/form_btn.dart';
import 'package:vitis/widgets/forms/form_input.dart';
import 'package:vitis/widgets/icons/vitis_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _obscurePasswords = true;

  void _togglePasswordsVisibility() {
    setState(() {
      _obscurePasswords = !_obscurePasswords;
    });
  }

  bool get _isValid => _email.isNotEmpty && _password.isNotEmpty;

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
                    const Center(child: VitisLogo(width: 150, height: 150)),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Vitis",
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 32,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      "Tu billetera inteligente",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Bienvenida
                    Text("Bienvenido 👋", style: theme.textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      "Accedé a tu cuenta para continuar",
                      style: theme.textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 16),

                    // Formulario
                    FormInput(
                      label: "Usuario",
                      hint: "tu@email.com",
                      type: Type.email,
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                      enableValidation: false,
                    ),

                    const SizedBox(height: 12),

                    FormInput(
                      label: "Contraseña",
                      hint: "••••••••",
                      type: Type.password,
                      obscureText: _obscurePasswords,
                      onToggleObscure: _togglePasswordsVisibility,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      enableValidation: false,
                    ),

                    const SizedBox(height: 4),

                    // Olvidaste contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/forgetpassword"),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón Iniciar Sesión
                    Opacity(
                      opacity: _isValid ? 1.0 : 0.5,
                      child: SizedBox(
                        height: 50,
                        child: FormBtn(
                          text: "Iniciar sesión",
                          onPressed: () {
                            if (_isValid) {
                              Navigator.pushNamed(context, "/dashboard");
                            }
                          },
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿No tenés cuenta? ",
                          style: theme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, "/register"),
                          child: Text(
                            "Registrate",
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
