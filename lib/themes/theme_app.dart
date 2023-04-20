import 'package:flutter/material.dart';

final ThemeData lightAppThemeData = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Colors.black,
    onSecondary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.black,
    onSecondaryContainer: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black54),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.black,
  ),
);

final ThemeData darkAppThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF191919),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.black,
    background: Color(0xFF191919),
    onBackground: Colors.white,
    surface: Color(0xFF191919),
    onSurface: Color(0xFF131313),
    error: Colors.red,
    onError: Colors.white,
    onSecondaryContainer: Color(0xFF131313),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF191919),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white70),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
);

final ThemeData amoledAppThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.black,
    background: Colors.black,
    onBackground: Colors.white,
    surface: Colors.black,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onSecondaryContainer: Color(0xFF131313),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white70),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
);

@override
ThemeData appBarThemeApp(BuildContext context) {
  assert(context != null);
  final ThemeData theme = Theme.of(context);
  assert(theme != null);
  return theme.copyWith(
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: Theme.of(context).colorScheme.background,
    ),
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    ),
    textTheme: theme.textTheme.copyWith(
      titleLarge: TextStyle(color: Theme.of(context).colorScheme.onBackground),
    ),
    textSelectionTheme: theme.textSelectionTheme.copyWith(
      cursorColor: Theme.of(context).colorScheme.onBackground,
    ),
  );
}
