import 'package:flutter/material.dart';

extension ListAverage on List<num> {
  double average() {
    try {
      return this.cast<num>().reduce((a, b) => a + b) / this.length;
    } on StateError {
      return 0;
    }
  }
}

extension Brightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension KeySorter<T> on List<T> {
  void keySort<U>(List<U> keys, U Function(T entry) mapper) {
    this.sort((T a, T b) => keys.indexOf(mapper(a)) - keys.indexOf(mapper(b)));
  }
}
