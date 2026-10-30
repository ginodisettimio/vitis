import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/utils/password_hasher.dart';

void main() {
  // Pocas iteraciones para que el test sea rápido.
  const iterations = 1000;

  test('verifies the right password and rejects the wrong one', () async {
    final hash = await PasswordHasher.hash('secret123', iterations: iterations);

    expect(await PasswordHasher.verify('secret123', hash), isTrue);
    expect(await PasswordHasher.verify('secret124', hash), isFalse);
  });

  test('two hashes of the same password differ by salt', () async {
    final a = await PasswordHasher.hash('same', iterations: iterations);
    final b = await PasswordHasher.hash('same', iterations: iterations);

    expect(a, isNot(b));
    expect(await PasswordHasher.verify('same', a), isTrue);
    expect(await PasswordHasher.verify('same', b), isTrue);
  });

  test(
    'the hash does not contain the password and stores iterations',
    () async {
      final hash = await PasswordHasher.hash(
        'secret123',
        iterations: iterations,
      );

      expect(hash, isNot(contains('secret123')));
      expect(hash, startsWith('pbkdf2\$$iterations\$'));
    },
  );

  test('uses 20,000 iterations by default', () async {
    final hash = await PasswordHasher.hash('secret123');

    expect(hash, startsWith(r'pbkdf2$20000$'));
    expect(await PasswordHasher.verify('secret123', hash), isTrue);
  });

  test('a hash made with other iterations still verifies', () async {
    final hash = await PasswordHasher.hash('secret123', iterations: 2000);

    expect(await PasswordHasher.verify('secret123', hash), isTrue);
  });

  test('a stored value with an invalid format does not verify', () async {
    for (final invalid in [
      '',
      'secret123',
      r'pbkdf2$abc$AAAA$AAAA',
      r'pbkdf2$0$AAAA$AAAA',
      r'pbkdf2$1000$not-base64!$AAAA',
      r'md5$1000$AAAA$AAAA',
    ]) {
      expect(await PasswordHasher.verify('secret123', invalid), isFalse);
    }
  });
}
