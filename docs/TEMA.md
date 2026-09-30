# Guía del tema de Vitis

La app define un tema claro y uno oscuro en [`lib/utils/app_theme.dart`](../lib/utils/app_theme.dart), y `MaterialApp` elige cuál usar según el dispositivo (`themeMode: ThemeMode.system`). Para que una pantalla cambie sola entre claro y oscuro, **los colores y estilos tienen que salir del contexto** (`Theme.of(context)`), no de constantes fijas.

## La regla

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  // ...
}
```

Obtené `theme` una sola vez al principio de `build` y usalo para todo lo que dependa del modo claro/oscuro.

| ❌ Evitar | ✅ Usar |
|---|---|
| `color: AppTheme.textDark` | `color: theme.colorScheme.onSurface` |
| `color: AppTheme.textGrey` | `style: theme.textTheme.bodyMedium` |
| `color: Colors.white` (fondo de tarjeta) | `color: theme.cardTheme.color` |
| `backgroundColor: AppTheme.bgLight` | Nada: el `Scaffold` ya lo toma del tema |
| `fillColor: AppTheme.inputLight` | Nada: `TextField` ya usa `inputDecorationTheme` |
| `ElevatedButton.styleFrom(backgroundColor: ...)` | Nada: `ElevatedButton` ya usa `elevatedButtonTheme` |

## Qué usar para cada cosa

### Textos

| Uso | Estilo | Ejemplo en login |
|---|---|---|
| Título grande de marca | `theme.textTheme.displayLarge` | "Vitis" |
| Título de sección | `theme.textTheme.titleLarge` | "Bienvenido 👋" |
| Texto principal (nombres, montos, etiquetas) | `theme.textTheme.bodyLarge` | — |
| Texto secundario (descripciones, ayudas) | `theme.textTheme.bodyMedium` | "Accedé a tu cuenta para continuar" |

Si necesitás otro tamaño o peso, partí del estilo del tema con `copyWith` en lugar de crear un `TextStyle` desde cero. Así se conserva el color correcto en cada modo:

```dart
Text(
  "Vitis",
  style: theme.textTheme.displayLarge?.copyWith(fontSize: 32),
)
```

> Solo esos cuatro estilos (`displayLarge`, `titleLarge`, `bodyLarge`, `bodyMedium`) están personalizados. Los demás (`titleMedium`, `bodySmall`, etc.) caen en los valores por defecto de Material y no tienen los colores de Vitis.

### Colores

| Uso | Token |
|---|---|
| Color de acento / marca (links, íconos activos) | `theme.colorScheme.primary` o `theme.primaryColor` |
| Variantes del acento | `theme.colorScheme.secondary`, `theme.colorScheme.tertiary` |
| Texto o ícono sobre fondo normal | `theme.colorScheme.onSurface` |
| Texto o ícono sobre el color primario | `theme.colorScheme.onPrimary` |
| Fondo de tarjetas | `theme.cardTheme.color` (o `theme.colorScheme.surface`) |
| Fondo de pantalla | `theme.scaffoldBackgroundColor` (el `Scaffold` lo aplica solo) |
| Errores / acciones destructivas | `theme.colorScheme.error` |

Ejemplo del login (link "¿Olvidaste tu contraseña?"):

```dart
Text(
  "¿Olvidaste tu contraseña?",
  style: TextStyle(
    color: theme.primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  ),
)
```

Para fondos suaves derivados de un color del tema, usá transparencia sobre el token:

```dart
color: theme.colorScheme.primary.withValues(alpha: 0.12)
color: theme.colorScheme.error.withValues(alpha: 0.08)
```

### Tarjetas

El tema define color, radio (24) y borde de las tarjetas en `cardTheme`. La forma más simple es usar el widget `Card`. Si necesitás un `Container`, leé los valores del tema:

```dart
final shape = theme.cardTheme.shape as RoundedRectangleBorder?;

Container(
  decoration: BoxDecoration(
    color: theme.cardTheme.color,
    borderRadius: shape?.borderRadius,
    border: shape != null ? Border.fromBorderSide(shape.side) : null,
  ),
)
```

### Inputs y botones

No hace falta pasarles estilos: `TextField` toma `inputDecorationTheme` y `ElevatedButton` toma `elevatedButtonTheme`. Usá los widgets compartidos, que ya lo resuelven:

- [`FormInput`](../lib/widgets/form_input.dart) para campos de formulario.
- [`FormBtn`](../lib/widgets/form_btn.dart) para el botón principal.

## Cuándo sí usar `AppTheme` directamente

Algunos colores son iguales en ambos modos y no dependen del tema. Estos se pueden usar como constantes:

- `AppTheme.primary` y sus variantes, cuando el color de marca es fijo (ej: una tarjeta morada con texto blanco).
- `AppTheme.success` / `AppTheme.successLight` para montos positivos.
- `AppTheme.bankColors` para los colores de cada banco.
- `AppTheme.pieColors` para gráficos.

Si un valor cambia entre claro y oscuro pero no tiene token en el tema (por ejemplo, `inputLight` vs `inputDark`), elegilo según el brillo:

```dart
final isDark = theme.brightness == Brightness.dark;
final fondo = isDark ? AppTheme.inputDark : AppTheme.inputLight;
```

Si vas a necesitar ese valor en varias pantallas, es mejor agregarlo al `ThemeData` en `app_theme.dart` que repetir el `if`.

## Tipografía

Los dos temas definen `fontFamily: 'Nunito'`, así que todos los textos de la app usan Nunito sin tener que indicarlo. No hace falta pasar `fontFamily` en los `TextStyle`; alcanza con elegir el peso (`fontWeight`), que usa los archivos de Nunito declarados en `pubspec.yaml` (400 a 900).

## Cómo probar

Cambiá el modo oscuro del emulador o dispositivo con la app abierta: la pantalla tiene que cambiar sin reiniciar. Si algún texto queda invisible (oscuro sobre oscuro) o alguna tarjeta queda blanca en modo oscuro, hay un color fijo que hay que reemplazar por un token del tema.

## Checklist para una pantalla nueva

- [ ] `final theme = Theme.of(context);` al inicio de `build`.
- [ ] Sin `AppTheme.textDark`, `AppTheme.textGrey`, `AppTheme.bgLight`, `AppTheme.inputLight` ni `Colors.white`/`Colors.black` para fondos o textos.
- [ ] Textos con `theme.textTheme.*` (con `copyWith` si hace falta ajustar).
- [ ] Tarjetas con `Card` o `theme.cardTheme`.
- [ ] Inputs y botones con `FormInput` / `FormBtn` o los widgets de Material sin estilo propio.
- [ ] Probada en modo claro y oscuro.
