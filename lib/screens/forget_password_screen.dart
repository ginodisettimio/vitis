import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vitis/utils/validator.dart';
import 'package:vitis/widgets/form_btn.dart';
import 'package:vitis/widgets/form_input.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool _isCodeSent = false;
  bool _isResendEnabled = false;
  int _countdown = 30;
  Timer? _timer;

  String _emailValue = '';
  String _codeValue = '';

  bool get _isEmailValid => Validator.isValidEmail(_emailValue);
  bool get _canSendEmail => _isEmailValid && (!_isCodeSent || _isResendEnabled);
  bool get _isCodeValid => _codeValue.trim().isNotEmpty;

  void _sendCode() {
    setState(() {
      _isCodeSent = true;
      _isResendEnabled = false;
      _countdown = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                                "Recuperar cuenta",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                "Te enviaremos un código de seguridad",
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Input Email 
                    FormInput(
                      label: "CORREO ELECTRÓNICO",
                      hint: "tu@email.com",
                      type: Type.email,
                      onChanged: (value) {
                        setState(() {
                          _emailValue = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Botón Enviar / Reenviar Código
                    Opacity(
                      opacity: _canSendEmail ? 1.0 : 0.5,
                      child: SizedBox(
                        height: 50,
                        child: FormBtn(
                          text: !_isCodeSent
                              ? "Enviar código"
                              : (_isResendEnabled
                                  ? "Reenviar código"
                                  : "Reenviar código ($_countdown s)"),
                          onPressed: () {
                            if (_canSendEmail) {
                              _sendCode();
                            }
                          },
                        ),
                      ),
                    ),

                    // Zona de Código 
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      alignment: Alignment.topCenter,
                      child: !_isCodeSent
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 24),
                                
                                Divider(color: theme.primaryColor.withValues(alpha: 0.1), thickness: 2),
                                const SizedBox(height: 24),

                                FormInput(
                                  label: "CÓDIGO DE VERIFICACIÓN",
                                  hint: "Ej. 123456",
                                  type: Type.text,
                                  onChanged: (value) {
                                    setState(() {
                                      _codeValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                
                                // Botón final de confirmación
                                Opacity(
                                  opacity: _isCodeValid ? 1.0 : 0.5,
                                  child: SizedBox(
                                    height: 50,
                                    child: FormBtn(
                                      text: "Confirmar Código",
                                      onPressed: () {
                                        if (_isCodeValid) {
                                          // TODO: Lógica de validación del código
                                          Navigator.pushNamed(context, "/changepassword");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    
                    const Spacer(),
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