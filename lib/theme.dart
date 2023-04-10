import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
    ),
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: const Color.fromARGB(255, 10, 10, 10),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color.fromARGB(255, 100, 95, 70),
      
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.deepPurpleAccent),
      displayMedium: TextStyle(color: Colors.deepPurpleAccent),
      bodyMedium: TextStyle(color: Colors.deepPurpleAccent),
      titleMedium: TextStyle(color: Colors.pinkAccent),
    ),
  );
}
