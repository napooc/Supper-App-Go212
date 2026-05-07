import 'package:flutter/material.dart';

class Go212Colors {
  Go212Colors._();

  // ─── Primary (Official GoWash Branding Green) ───
  static const Color primary50  = Color(0xFFE8F6EA);
  static const Color primary100 = Color(0xFFC7EACC);
  static const Color primary200 = Color(0xFF9FD9A7);
  static const Color primary300 = Color(0xFF76C87F);
  static const Color primary400 = Color(0xFF32D05F); // Light Green Accent
  static const Color primary500 = Color(0xFF179B2E); // Official Primary Green
  static const Color primary600 = Color(0xFF148828);
  static const Color primary700 = Color(0xFF117522);
  static const Color primary800 = Color(0xFF0E621B);
  static const Color primary900 = Color(0xFF0D5D1F); // Official Dark Green

  // ─── Neutral (Warm/Minimal Scale) ───
  static const Color neutral0   = Color(0xFFFFFFFF);
  static const Color neutral50  = Color(0xFFFDFBF7); // Sand White
  static const Color neutral100 = Color(0xFFFAF9F6);
  static const Color neutral200 = Color(0xFFF3F1ED);
  static const Color neutral300 = Color(0xFFE5E2DB);
  static const Color neutral400 = Color(0xFFB5B0A5);
  static const Color neutral500 = Color(0xFF8A8478);
  static const Color neutral600 = Color(0xFF635E54);
  static const Color neutral700 = Color(0xFF45413A);
  static const Color neutral800 = Color(0xFF2B2925);
  static const Color neutral900 = Color(0xFF171614);

  // ─── Semantic ───
  static const Color success = Color(0xFF179B2E); // Unified with Brand Green
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ─── Surface & Elevation ───
  static const Color surfaceCard  = Color(0xFFFFFFFF);
  static const Color surfacePage  = Color(0xFFFDFBF7); // Sand White
  static const Color surfaceModal = Color(0xFFFFFFFF);

  // ─── Official Gradients ───
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary900, primary500],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary900, primary500],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary50, Colors.white],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary500, primary400],
  );

  static const LinearGradient darkOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC0D5D1F)],
  );
}
