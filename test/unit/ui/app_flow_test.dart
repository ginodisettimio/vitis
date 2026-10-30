import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/mock/mock_data.dart';
import 'package:vitis/main.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/ui/screens/auth/login_screen.dart';
import 'package:vitis/ui/screens/dashboard/dashboard_screen.dart';
import 'package:vitis/ui/screens/dashboard/movements_screen.dart';
import 'package:vitis/ui/screens/savings/savings_screen.dart';
import 'package:vitis/ui/screens/settings/settings_screen.dart';
import 'package:vitis/ui/screens/transactions/cash_register_screen.dart';
import 'package:vitis/ui/screens/wallets/wallets_screen.dart';
import 'package:vitis/ui/widgets/navigation/app_bottom_nav_bar.dart';
import 'package:vitis/ui/screens/shell/main_shell_screen.dart';
import 'package:vitis/utils/money_formatter.dart';

void main() {
  Future<void> pumpUntilFound(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 100 && finder.evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(finder, findsWidgets);
  }

  Future<void> submitLogin(
    WidgetTester tester,
    String email,
    String password,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.enterText(find.byType(TextField).at(0), email);
    await tester.enterText(find.byType(TextField).at(1), password);
    await tester.pump();
    // En tiempo real: el hash del login corre en otro isolate y su resultado no
    // llegaría dentro del reloj de prueba.
    await tester.runAsync(() => tester.tap(find.text('Iniciar sesión')));
  }

  setUp(() {
    // Un viewport alto para que el dashboard construya todas sus secciones.
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(
      1200,
      3000,
    );
    binding.platformDispatcher.views.first.devicePixelRatio = 1;
  });

  tearDown(() => SessionStore.instance.logout());

  testWidgets('the demo login reaches the dashboard with its data', (
    tester,
  ) async {
    await submitLogin(tester, demoEmail, demoPassword);

    await pumpUntilFound(tester, find.textContaining('Hola, María'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text(formatearMonto(930401.25)), findsOneWidget);
    expect(find.text('4 bancos sincronizados'), findsOneWidget);
    expect(find.text('Viaje a Bariloche'), findsWidgets);
  });

  testWidgets('dashboard tiles open their section', (tester) async {
    await submitLogin(tester, demoEmail, demoPassword);
    await pumpUntilFound(tester, find.textContaining('Hola, María'));
    await tester.pump(const Duration(seconds: 1));

    Future<void> expectTapOpens(Finder tile, Type screen) async {
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.byType(screen), findsOneWidget);
      if (screen == MovementsScreen) {
        Navigator.pop(tester.element(find.byType(MovementsScreen)));
      } else {
        MainShellScreen.irA(
          tester.element(find.byType(MainShellScreen)),
          NavSection.inicio,
        );
      }
      await tester.pumpAndSettle();
    }

    await expectTapOpens(find.text('Viaje a Bariloche'), SavingsScreen);
    await expectTapOpens(find.text('MP'), MyWalletsScreen);
    await expectTapOpens(find.text('4 bancos sincronizados'), MyWalletsScreen);
    await expectTapOpens(find.text('Supermercado Día'), MovementsScreen);
  });

  testWidgets('a wrong password stays on the login with an error', (
    tester,
  ) async {
    await submitLogin(tester, demoEmail, 'wrong-password');

    await pumpUntilFound(tester, find.text('Correo o contraseña incorrectos'));

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(SessionStore.instance.currentUser, isNull);
  });

  testWidgets('a new account sees empty states, not demo data', (tester) async {
    await tester.runAsync(() async {
      await SessionStore.instance.register(
        name: 'Ana Pérez',
        email: 'ana.flow@x.com',
        password: 'secret123',
      );
      await SessionStore.instance.login('ana.flow@x.com', 'secret123');
    });

    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    await tester.pump();

    expect(find.textContaining('Hola, Ana'), findsOneWidget);
    expect(find.text('Todavía no creaste ningún ahorro'), findsOneWidget);
    expect(find.text('Todavía no agregaste billeteras'), findsOneWidget);
    expect(find.text('Sin gastos este mes'), findsOneWidget);
    expect(find.text('Todavía no hay movimientos'), findsOneWidget);
    expect(find.text('Viaje a Bariloche'), findsNothing);
  });

  Future<void> loginNewAccount(WidgetTester tester, String email) async {
    await tester.runAsync(() async {
      await SessionStore.instance.register(
        name: 'Ana',
        email: email,
        password: 'secret123',
      );
      await SessionStore.instance.login(email, 'secret123');
    });
  }

  testWidgets('a setting changes on screen and stays in the user', (
    tester,
  ) async {
    await loginNewAccount(tester, 'ana.settings@x.com');

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    expect(find.text('ARS'), findsOneWidget);
    // En tiempo real: el repositorio de usuarios quedó sembrado fuera del reloj
    // de prueba, igual que en submitLogin.
    await tester.runAsync(() async {
      await tester.tap(find.text('Moneda'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text('USD'), findsOneWidget);
    expect(SessionStore.instance.currentUser?.currency, 'USD');
  });

  testWidgets('a deposit cannot go past the available balance', (tester) async {
    await loginNewAccount(tester, 'ana.deposit@x.com');
    await tester.runAsync(
      () => SavingsStore.instance.add(name: 'Casa', reserved: 0, target: 1000),
    );

    await tester.pumpWidget(const MaterialApp(home: SavingsScreen()));
    await tester.tap(find.text('Casa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '10');
    await tester.pump();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Depositar'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('a cash expense cannot go past the available balance', (
    tester,
  ) async {
    await loginNewAccount(tester, 'ana.cash@x.com');

    await tester.pumpWidget(const MaterialApp(home: CashRegisterScreen()));
    await tester.enterText(find.byType(TextField), '10');
    await tester.pump();
    await tester.tap(find.text('Guardar Registro'));
    await tester.pump();

    expect(MovementsStore.instance.movements, isEmpty);
    expect(find.text('Disponible: ${formatearMonto(0)}'), findsOneWidget);
  });

  testWidgets('disconnecting a wallet asks first and keeps its movements', (
    tester,
  ) async {
    await tester.runAsync(
      () => SessionStore.instance.login(secondDemoEmail, secondDemoPassword),
    );
    final before = MovementsStore.instance.movements.length;

    await tester.pumpWidget(const MaterialApp(home: MyWalletsScreen()));
    expect(find.text('Conectado'), findsNWidgets(2));
    await tester.tap(find.byTooltip('Desconectar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('2 bancos sincronizados'), findsOneWidget);

    await tester.tap(find.byTooltip('Desconectar').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Desconectar'));
    await tester.pumpAndSettle();

    expect(find.text('1 banco sincronizado'), findsOneWidget);
    expect(MovementsStore.instance.movements, hasLength(before));
  });
}
