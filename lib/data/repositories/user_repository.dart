import 'package:vitis/data/mock/mock_data.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/utils/password_hasher.dart';

abstract interface class UserRepository {
  // Devuelve null si el correo o la contraseña no coinciden.
  Future<User?> login(String email, String password);

  // Devuelve null si el correo ya está registrado.
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  });

  // Devuelve false si el correo nuevo ya pertenece a otra cuenta. No cambia la
  // contraseña: para eso está changePassword.
  Future<bool> update(User user);

  Future<void> changePassword(String userId, String newPassword);
}

class MockUserRepository implements UserRepository {
  final Map<String, User> _users = {};
  Future<void>? _seeding;
  int _nextId = 1;

  // El hash de las cuentas demo se calcula en el primer uso: hashear al crear el
  // repositorio demoraría el arranque de la app.
  Future<void> _ensureSeeded() => _seeding ??= _seed();

  Future<void> _seed() async {
    // En paralelo: el primer login espera estos hashes.
    final (demoHash, secondDemoHash) = await (
      PasswordHasher.hash(demoPassword),
      PasswordHasher.hash(secondDemoPassword),
    ).wait;
    _users[demoUserId] = User(
      id: demoUserId,
      name: 'María González',
      email: demoEmail,
      password: demoHash,
    );
    _users[secondDemoUserId] = User(
      id: secondDemoUserId,
      name: 'Tomás Ríos',
      email: secondDemoEmail,
      password: secondDemoHash,
    );
  }

  User? _findByEmail(String email) {
    final normalized = User.normalizeEmail(email);
    for (final user in _users.values) {
      if (user.email == normalized) return user;
    }
    return null;
  }

  @override
  Future<User?> login(String email, String password) async {
    await _ensureSeeded();
    final user = _findByEmail(email);
    if (user == null) return null;
    return await PasswordHasher.verify(password, user.password) ? user : null;
  }

  @override
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _ensureSeeded();
    if (_findByEmail(email) != null) return null;
    final user = User(
      id: 'user-${_nextId++}',
      name: name,
      email: User.normalizeEmail(email),
      password: await PasswordHasher.hash(password),
    );
    _users[user.id!] = user;
    return user;
  }

  @override
  Future<bool> update(User user) async {
    await _ensureSeeded();
    final owner = _findByEmail(user.email);
    if (owner != null && owner.id != user.id) return false;
    _users[user.id!] = user.copyWith(
      email: User.normalizeEmail(user.email),
      password: _users[user.id!]!.password,
    );
    return true;
  }

  @override
  Future<void> changePassword(String userId, String newPassword) async {
    await _ensureSeeded();
    _users[userId] = _users[userId]!.copyWith(
      password: await PasswordHasher.hash(newPassword),
    );
  }
}
