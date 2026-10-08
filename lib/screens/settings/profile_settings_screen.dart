import 'package:flutter/material.dart';
import 'package:vitis/models/user_store.dart';
import 'package:vitis/utils/validator.dart';
import 'package:vitis/widgets/avatars/avatar_box.dart';
import 'package:vitis/widgets/avatars/edit_badge.dart';
import 'package:vitis/widgets/forms/form_btn.dart';
import 'package:vitis/widgets/forms/form_input.dart';
import 'package:vitis/widgets/headers/back_header.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final UserStore _usuario = UserStore.instancia;

  // Lo que escribió el usuario. Si un campo queda vacío, ese dato no cambia.
  String _nombre = '';
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;

  bool get _nombreModificado =>
      _nombre.trim().isNotEmpty && _nombre.trim() != _usuario.nombre;

  bool get _emailModificado =>
      _email.trim().isNotEmpty && _email.trim() != _usuario.email;

  bool get _passwordModificada => _password.isNotEmpty;

  // Hay al menos un cambio y todos los datos modificados son válidos.
  bool get _isValid {
    final hayCambios =
        _nombreModificado || _emailModificado || _passwordModificada;
    final emailValido = !_emailModificado || Validator.isValidEmail(_email);
    final passwordValida = !_passwordModificada || _password.length >= 8;
    return hayCambios && emailValido && passwordValida;
  }

  void _guardar() {
    if (!_isValid) return;

    _usuario.actualizar(
      nombre: _nombreModificado ? _nombre.trim() : null,
      email: _emailModificado ? _email.trim() : null,
    );

    if (_passwordModificada) {
      // TODO: cambiar la contraseña en el backend (no se guarda en UserStore).
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Vista previa: si se escribió un nombre nuevo, el avatar ya muestra su inicial.
    final inicial = UserStore.inicialDe(
      _nombre.trim().isNotEmpty ? _nombre : _usuario.nombre,
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
                      hint: _usuario.nombre,
                      type: Type.text,
                      onChanged: (value) => setState(() => _nombre = value),
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: 'Email',
                      hint: _usuario.email,
                      type: Type.email,
                      onChanged: (value) => setState(() => _email = value),
                    ),
                    const SizedBox(height: 16),
                    FormInput(
                      label: 'Contraseña',
                      hint: '••••••••',
                      type: Type.password,
                      obscureText: _obscurePassword,
                      onToggleObscure: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
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
