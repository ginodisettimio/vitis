import 'package:flutter/material.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/ui/widgets/headers/profile_header.dart';
import 'package:vitis/ui/widgets/settings/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  static const TextStyle _emoji = TextStyle(fontSize: 20);

  const SettingsScreen({super.key});

  Future<void> _setPreference(
    BuildContext context,
    String key,
    String value,
  ) async {
    try {
      await SessionStore.instance.setPreference(key, value);
    } catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

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
                listenable: SessionStore.instance,
                builder: (context, _) {
                  // Al cerrar sesión se redibuja una vez antes de salir de la pantalla.
                  final user = SessionStore.instance.currentUser;
                  if (user == null) return const SizedBox.shrink();
                  return ProfileHeader(
                    avatar: Text(user.initial),
                    name: user.name,
                    email: user.email,
                    onActionTap: () =>
                        Navigator.pushNamed(context, '/profilesettings'),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    ListenableBuilder(
                      listenable: SessionStore.instance,
                      builder: (context, _) {
                        final user = SessionStore.instance.currentUser;
                        if (user == null) return const SizedBox.shrink();
                        return Column(
                          children: [
                            SettingsTile(
                              icon: Text('🔔', style: _emoji),
                              title: 'Notificaciones',
                              trailingText: user.notificationsEnabled
                                  ? 'Activadas'
                                  : 'Desactivadas',
                              onTap: () => _setPreference(
                                context,
                                Preference.notifications,
                                (!user.notificationsEnabled).toString(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SettingsTile(
                              icon: Text('🔒', style: _emoji),
                              title: 'Seguridad',
                              trailingText: user.pinEnabled
                                  ? 'PIN activo'
                                  : 'Ninguna',
                              onTap: () => _setPreference(
                                context,
                                Preference.pin,
                                (!user.pinEnabled).toString(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SettingsTile(
                              icon: Text('💱', style: _emoji),
                              title: 'Moneda',
                              trailingText: user.currency,
                              onTap: () => _setPreference(
                                context,
                                Preference.currency,
                                user.currency == 'ARS' ? 'USD' : 'ARS',
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
                              onTap: () => _setPreference(
                                context,
                                Preference.theme,
                                systemTheme == Brightness.dark
                                    ? ThemeMode.light.name
                                    : ThemeMode.dark.name,
                              ),
                            ),
                          ],
                        );
                      },
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
                      onTap: () {
                        SessionStore.instance.logout();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      },
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
  showAppSnackBar(
    context,
    "Próximamente",
    duration: const Duration(seconds: 1),
  );
}
