import 'package:flutter/material.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/utils/validator.dart';
import 'package:vitis/ui/widgets/avatars/avatar_box.dart';
import 'package:vitis/ui/widgets/avatars/edit_badge.dart';
import 'package:vitis/ui/widgets/forms/form_btn.dart';
import 'package:vitis/ui/widgets/forms/form_input.dart';
import 'package:vitis/ui/widgets/headers/back_header.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final SessionStore _session = SessionStore.instance;

  // Esta pantalla solo se abre con la sesión iniciada.
  User get _user => _session.currentUser!;

  // Lo que escribió el usuario. Si un campo queda vacío, ese dato no cambia.
  String _nombre = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _saving = false;

  bool get _nombreModificado =>
      _nombre.trim().isNotEmpty && _nombre.trim() != _user.name;

  bool get _emailModificado =>
      _email.trim().isNotEmpty && _email.trim() != _user.email;

  bool get _passwordModificada => _password.isNotEmpty;

  // Hay al menos un cambio y todos los datos modificados son válidos.
  bool get _isValid {
    final hayCambios =
        _nombreModificado || _emailModificado || _passwordModificada;
    final emailValido = !_emailModificado || Validator.isValidEmail(_email);
    final passwordValida = !_passwordModificada || _password.length >= 8;
    return hayCambios && emailValido && passwordValida;
  }

  Future<void> _guardar() async {
    if (!_isValid || _saving) return;
    setState(() => _saving = true);

    try {
      final updated = await _session.updateProfile(
        name: _nombreModificado ? _nombre.trim() : null,
        email: _emailModificado ? _email.trim() : null,
      );
      if (updated && _passwordModificada) {
        await _session.changePassword(_password);
      }
      if (!mounted) return;

      if (updated) {
        Navigator.pop(context);
      } else {
        showAppSnackBar(context, 'Ese correo ya está registrado');
      }
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vista previa: si se escribió un nombre nuevo, el avatar ya muestra su inicial.
    final inicial = User.initialOf(
      _nombre.trim().isNotEmpty ? _nombre : _user.name,
    );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BackHeader(titulo: 'Editar perfil'),
                    const SizedBox(height: 24),

                    // Avatar con lápiz
                    Center(
                      child: EditBadge(
                        child: AvatarBox(size: 96, child: Text(inicial)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Formulario: los placeholders muestran los datos actuales
                    FormInput(
                      label: 'Nombre',
                      hint: _user.name,
                      type: Type.text,
                      onChanged: (value) => setState(() => _nombre = value),
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: 'Email',
                      hint: _user.email,
                      type: Type.email,
                      onChanged: (value) => setState(() => _email = value),
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: 'Contraseña',
                      hint: '••••••••',
                      type: Type.password,
                      obscureText: _obscurePassword,
                      onToggleObscure: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      onChanged: (value) => setState(() => _password = value),
                    ),

                    const Spacer(),
                    const SizedBox(height: 24),

                    // Botón Guardar
                    Opacity(
                      opacity: _isValid ? 1.0 : 0.5,
                      child: SizedBox(
                        height: 56,
                        child: FormBtn(
                          text: 'Guardar cambios',
                          onPressed: _guardar,
                        ),
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
