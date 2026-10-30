import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitis/data/states/credentials_store.dart';
import 'package:vitis/data/models/wallet.dart';

class MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockStorage storage;
  late CredentialsStore store;

  setUp(() {
    storage = MockStorage();
    store = CredentialsStore.withStorage(storage);
  });

  test('save and read return the same credentials', () async {
    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    await store.save(
      'w1',
      const WalletCredentials(apiKey: 'key', accessToken: 'token'),
    );

    final stored =
        verify(
              () => storage.write(
                key: 'wallet.w1',
                value: captureAny(named: 'value'),
              ),
            ).captured.single
            as String;

    when(() => storage.read(key: 'wallet.w1')).thenAnswer((_) async => stored);

    final read = await store.read('w1');
    expect(read?.apiKey, 'key');
    expect(read?.accessToken, 'token');
  });

  test('read returns null when the wallet has no credentials', () async {
    when(() => storage.read(key: 'wallet.w9')).thenAnswer((_) async => null);

    expect(await store.read('w9'), isNull);
  });

  test('delete removes the key of that wallet', () async {
    when(() => storage.delete(key: 'wallet.w1')).thenAnswer((_) async {});

    await store.delete('w1');

    verify(() => storage.delete(key: 'wallet.w1')).called(1);
  });
}
