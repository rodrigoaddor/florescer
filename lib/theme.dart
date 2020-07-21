import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final scheme = ColorScheme.light(
    primary: Colors.purple[300],
    primaryVariant: Colors.purpleAccent[400],
  );
  final base = ThemeData.from(colorScheme: scheme);
  return base.copyWith(buttonTheme: base.buttonTheme.copyWith(disabledColor: Colors.grey[400]));
}
