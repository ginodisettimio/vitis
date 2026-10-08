import 'package:flutter/widgets.dart';

// Datos del usuario compartidos por toda la app (Ajustes, Editar perfil, etc.).
// Las pantallas la escuchan con ListenableBuilder para redibujarse cuando cambia.
class UserStore extends ChangeNotifier {
  UserStore._();

  static final UserStore instancia = UserStore._();

  // TODO: persistir los cambios (todavía se pierden al cerrar la app).
  String _nombre = 'María González';
  String _email = 'maria@email.com';

  String get nombre => _nombre;
  String get email => _email;
  String get inicial => inicialDe(_nombre);

  // Primera palabra del nombre, para saludos ("Hola, María").
  String get primerNombre => _nombre.trim().split(RegExp(r'\s+')).first;

  // Primera letra del nombre en mayúscula, para el avatar.
  static String inicialDe(String nombre) {
    final limpio = nombre.trim();
    return limpio.isEmpty ? '?' : limpio.characters.first.toUpperCase();
  }

  // Solo cambia los datos que se pasan; los que quedan en null no se tocan.
  void actualizar({String? nombre, String? email}) {
    if (nombre != null) _nombre = nombre;
    if (email != null) _email = email;
    notifyListeners();
  }
}
