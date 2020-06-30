import 'package:flutter/material.dart';

ThemeData buildTheme() => ThemeData.light().copyWith(
      primaryColor: Colors.purple[300],
      hintColor: Colors.white,
      cursorColor: Color.lerp(Colors.white, Colors.blue[700], 0.4),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
        labelStyle: TextStyle(color: Colors.white),
      ),
    );
