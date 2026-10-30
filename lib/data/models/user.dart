import 'package:flutter/widgets.dart';

// Un ajuste del usuario, por ejemplo key: 'theme', value: 'dark'.
class Preference {
  static const String theme = 'theme'; // nombre de un ThemeMode
  static const String notifications = 'notifications'; // 'true' o 'false'
  static const String pin = 'pin'; // 'true' o 'false'
  static const String currency = 'currency';

  final String key;
  final String value;

  const Preference({required this.key, required this.value});

  Map<String, Object?> toMap() => {'key': key, 'value': value};

  factory Preference.fromMap(Map<String, Object?> map) =>
      Preference(key: map['key'] as String, value: map['value'] as String);
}

class User {
  final String? id; // null hasta que se guarda en la base
  final String name;
  final String email;
  final String password; // hash de PasswordHasher, nunca el texto plano
  final List<Preference> preferences;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.preferences = const [],
  });

  // Primera palabra del nombre, para saludos ("Hola, María").
  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  String get initial => initialOf(name);

  // Primera letra del nombre en mayúscula, para el avatar.
  static String initialOf(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
  }

  // null si el usuario todavía no eligió ese ajuste.
  String? preference(String key) {
    for (final preference in preferences) {
      if (preference.key == key) return preference.value;
    }
    return null;
  }

  bool get notificationsEnabled =>
      preference(Preference.notifications) == 'true';
  bool get pinEnabled => preference(Preference.pin) == 'true';
  String get currency => preference(Preference.currency) ?? 'ARS';

  // Reemplaza la preferencia si ya existe: cada clave aparece una sola vez.
  User withPreference(String key, String value) => copyWith(
    preferences: [
      for (final preference in preferences)
        if (preference.key != key) preference,
      Preference(key: key, value: value),
    ],
  );

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    List<Preference>? preferences,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
    preferences: preferences ?? this.preferences,
  );

  // A@x.com y a@x.com son la misma cuenta.
  static String normalizeEmail(String email) => email.trim().toLowerCase();

  Map<String, Object?> toMap() => {
    'name': name,
    'email': normalizeEmail(email),
    'password': password,
    'preferences': preferences.map((p) => p.toMap()).toList(),
  };

  factory User.fromMap(String id, Map<String, Object?> map) => User(
    id: id,
    name: map['name'] as String,
    email: map['email'] as String,
    password: map['password'] as String,
    preferences: (map['preferences'] as List)
        .map((p) => Preference.fromMap(Map<String, Object?>.from(p as Map)))
        .toList(),
  );
}
