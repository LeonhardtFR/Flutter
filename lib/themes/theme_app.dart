import 'package:flutter/material.dart';

@override
ThemeData appBarThemeApp(BuildContext context) {
  assert(context != null);
  final ThemeData theme = Theme.of(context);
  assert(theme != null);
  return theme.copyWith(
    appBarTheme: theme.appBarTheme.copyWith(
      backgroundColor: Colors.black,
    ),
    inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      hintStyle: TextStyle(color: Colors.white70),
    ),
    textTheme: theme.textTheme.copyWith(
      headline6: TextStyle(color: Colors.white),
    ),
    textSelectionTheme: theme.textSelectionTheme.copyWith(
      cursorColor: Colors.white,
    ),
  );
}
