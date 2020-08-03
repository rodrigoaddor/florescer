import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final scheme = ColorScheme.light(
    primary: Colors.purple[300],
    primaryVariant: Colors.purpleAccent[400],
  );
  final base = ThemeData.from(colorScheme: scheme, textTheme: Typography.blackMountainView);
  return base.copyWith(
    buttonTheme: base.buttonTheme.copyWith(disabledColor: Colors.grey[400]),
    textTheme: base.textTheme.apply(bodyColor: Colors.black),
  );
}
