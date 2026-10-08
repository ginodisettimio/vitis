import 'package:flutter/material.dart';
import 'package:vitis/models/user_store.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/headers/profile_header.dart';
import 'package:vitis/widgets/settings/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const TextStyle _emoji = TextStyle(fontSize: 20);

  // TODO: persistir estos valores (todavía se pierden al cerrar la app).
  bool _notificacionesActivas = false;
  bool _pinActivo = false;
  String _moneda = 'ARS';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final systemTheme = Theme.of(context).brightness;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Se redibuja cuando se editan los datos en Editar perfil.
              ListenableBuilder(
                listenable: UserStore.instancia,
                builder: (context, _) {
                  final usuario = UserStore.instancia;
                  return ProfileHeader(
                    avatar: Text(usuario.inicial),
                    name: usuario.nombre,
                    email: usuario.email,
                    onActionTap: () =>
                        Navigator.pushNamed(context, '/profilesettings'),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Text('🔔', style: _emoji),
                      title: 'Notificaciones',
                      trailingText: _notificacionesActivas
                          ? 'Activadas'
                          : 'Desactivadas',
                      onTap: () => setState(
                        () => _notificacionesActivas = !_notificacionesActivas,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Text('🔒', style: _emoji),
                      title: 'Seguridad',
                      trailingText: _pinActivo ? 'PIN activo' : 'Ninguna',
                      onTap: () => setState(() => _pinActivo = !_pinActivo),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Text('💱', style: _emoji),
                      title: 'Moneda',
                      trailingText: _moneda,
                      onTap: () => setState(
                        () => _moneda = _moneda == 'ARS' ? 'USD' : 'ARS',
                      ),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Text(
                        systemTheme == Brightness.dark ? "🌑" : "🌕",
                        style: _emoji,
                      ),
                      title: 'Tema',
                      trailingText: systemTheme == Brightness.dark
                          ? "Oscuro"
                          : "Claro",
                      onTap: () => AppTheme.changeTheme(context),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: const Text('❓', style: _emoji),
                      title: 'Ayuda y soporte',
                      onTap: () => _showSnackBar(context),
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: const Text('📋', style: _emoji),
                      title: 'Términos y privacidad',
                      onTap: () => _showSnackBar(context),
                    ),
                    const SizedBox(height: 20),
                    SettingsTile(
                      icon: const Text('🚪', style: _emoji),
                      title: 'Cerrar sesión',
                      trailingIcon: null,
                      backgroundColor: colorScheme.error.withValues(
                        alpha: 0.08,
                      ),
                      foregroundColor: colorScheme.error,
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Próximamente",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
