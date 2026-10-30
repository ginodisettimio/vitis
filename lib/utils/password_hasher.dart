import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

// Hash de contraseñas con PBKDF2-HMAC-SHA256.
// Formato guardado: pbkdf2$<iterations>$<salt>$<hash>, con salt y hash en base64.
class PasswordHasher {
  PasswordHasher._();

  // Por debajo de las 600.000 de OWASP a propósito: priorizamos la velocidad del
  // login. Cada hash guarda sus iteraciones, así que se pueden subir sin migrar.
  static const int defaultIterations = 20000;
  static const int _saltBytes = 16;

  static Future<String> hash(
    String password, {
    int iterations = defaultIterations,
  }) async {
    final random = Random.secure();
    final salt = List.generate(_saltBytes, (_) => random.nextInt(256));
    final hash = await _deriveInBackground(password, salt, iterations);
    return 'pbkdf2\$$iterations\$${base64Encode(salt)}\$${base64Encode(hash)}';
  }

  // Devuelve false también si lo guardado no tiene el formato esperado.
  static Future<bool> verify(String password, String stored) async {
    final parts = stored.split(r'$');
    if (parts.length != 4 || parts[0] != 'pbkdf2') return false;
    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations <= 0) return false;

    final List<int> salt;
    final List<int> expected;
    try {
      salt = base64Decode(parts[2]);
      expected = base64Decode(parts[3]);
    } on FormatException {
      return false;
    }

    final hash = await _deriveInBackground(password, salt, iterations);
    return _equalInConstantTime(hash, expected);
  }

  // Tantas iteraciones en el hilo principal trabarían la UI.
  static Future<List<int>> _deriveInBackground(
    String password,
    List<int> salt,
    int iterations,
  ) => compute(_derive, (password, salt, iterations));

  static bool _equalInConstantTime(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var difference = 0;
    for (var i = 0; i < a.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}

Future<List<int>> _derive((String, List<int>, int) args) async {
  final (password, salt, iterations) = args;
  final key = await Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKeyFromPassword(password: password, nonce: salt);
  return key.extractBytes();
}
