import 'package:flutter/material.dart';
import 'package:vitis/widgets/form_btn.dart';
import 'package:vitis/widgets/form_input.dart';
import 'package:vitis/widgets/vitis_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // ─── Header (Logo + Título) ──────────────────────────────────
              const Center(child: VitisLogo(width: 150, height: 150)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Vitis",
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                    fontFamily: 'Nunito',
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

              // ─── Bienvenida ──────────────────────────────────────────────
              Text("Bienvenido 👋", style: theme.textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(
                "Accedé a tu cuenta para continuar",
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 16),

              // ─── Formulario ──────────────────────────────────────────────
              const FormInput(
                label: "Usuario",
                hint: "tu@email.com",
                type: Type.email,
              ),
              const SizedBox(height: 12),
              const FormInput(
                label: "Contraseña",
                hint: "••••••••",
                type: Type.password,
              ),

              const SizedBox(height: 4),

              // ─── Olvidaste contraseña ────────────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                  child: TextButton(
                    onPressed: () {},
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

              // ─── Botón Iniciar Sesión ────────────────────────────────────
              SizedBox(
                height: 50,
                child: FormBtn(
                  text: "Iniciar sesión",
                  onPressed: () {},
                ),
              ),

              // ─── Espaciador flexible ─────────────────────────────────────
              const Spacer(),

              // ─── Footer (Registrate) ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tenés cuenta? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navegar a registro
                    },
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
    );
  }
}