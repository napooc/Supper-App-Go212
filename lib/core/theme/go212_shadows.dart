import 'package:flutter/material.dart';

class Go212Shadows {
  Go212Shadows._();

  static List<BoxShadow> get elevation1 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevation2 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevation3 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevation4 => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 25,
          offset: const Offset(0, 20),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get glowSubtle => [
        BoxShadow(
          color: const Color(0xFF22C55E).withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get glowStrong => [
        BoxShadow(
          color: const Color(0xFF22C55E).withOpacity(0.25),
          blurRadius: 40,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get bottomNav => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ];
}
