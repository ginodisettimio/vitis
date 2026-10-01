import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/profile_header.dart';
import 'package:vitis/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const TextStyle _emoji = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final systemTheme = Theme.of(context).brightness;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                avatar: const Text('M'),
                name: 'María González',
                email: 'maria@email.com',
                onActionTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Text('🔔', style: _emoji),
                      title: 'Notificaciones',
                      trailingText: 'Activadas',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Text('🔒', style: _emoji),
                      title: 'Seguridad',
                      trailingText: 'PIN activo',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Text('💱', style: _emoji),
                      title: 'Moneda',
                      trailingText: 'ARS',
                      onTap: () {},
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
