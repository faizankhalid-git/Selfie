import 'package:flutter/material.dart';

ThemeData buildPoseCoachTheme() {
  const surface = Color(0xFFF7F8FA);
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5A67D8)),
    appBarTheme: const AppBarTheme(backgroundColor: surface, elevation: 0),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
  );
}
