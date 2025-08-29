import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  useMaterial3: true,
  platform: TargetPlatform.android,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[300]!,
    surface: Colors.black,
    onSurface: Color(0xeeffffff),
    onPrimary: Colors.white70,
    onPrimaryFixed: Colors.white70,
    onPrimaryFixedVariant: Colors.white70,
    onPrimaryContainer: Colors.white70,
    onSecondary: Colors.white70,
    onSecondaryFixed: Colors.white70,
    onSecondaryFixedVariant: Colors.white70,
    onSecondaryContainer: Colors.white70,
    onTertiary: Colors.white70,
    onTertiaryFixed: Colors.white70,
    onTertiaryFixedVariant: Colors.white70,
    onTertiaryContainer: Colors.white70,
    onSurfaceVariant: Colors.white70,
  ),
);
