import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'go212_colors.dart';
import 'go212_typography.dart';

class Go212Theme {
  Go212Theme._();

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Go212Colors.primary500, // Official GoWash Green: #179B2E
          onPrimary: Colors.white,
          primaryContainer: Go212Colors.primary100,
          onPrimaryContainer: Go212Colors.primary900,
          secondary: Go212Colors.primary400, // Light Accent: #32D05F
          onSecondary: Colors.white,
          surface: Go212Colors.surfacePage,
          onSurface: Go212Colors.neutral800,
          error: Go212Colors.error,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: Go212Colors.surfacePage,
        textTheme: Go212Typography.textTheme,
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: Go212Colors.neutral800),
          titleTextStyle: Go212Typography.textTheme.titleLarge?.copyWith(
            color: Go212Colors.neutral800,
            fontWeight: FontWeight.w800,
          ),
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Go212Colors.primary500,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            textStyle: Go212Typography.textTheme.labelLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Go212Colors.primary500,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: const BorderSide(color: Go212Colors.primary500, width: 1.5),
            textStyle: Go212Typography.textTheme.labelLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Go212Colors.primary500,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Go212Colors.primary500,
            textStyle: Go212Typography.textTheme.labelLarge?.copyWith(
              color: Go212Colors.primary500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Go212Colors.surfaceCard,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Go212Colors.primary500,
          unselectedItemColor: Go212Colors.neutral400,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Go212Colors.neutral100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Go212Colors.primary500, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Go212Colors.error, width: 1.5),
          ),
          hintStyle: Go212Typography.textTheme.bodyMedium?.copyWith(
            color: Go212Colors.neutral400,
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Go212Colors.neutral100,
          selectedColor: Go212Colors.primary100,
          secondarySelectedColor: Go212Colors.primary500,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide.none,
          labelStyle: Go212Typography.textTheme.labelMedium,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Go212Colors.surfaceModal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          surfaceTintColor: Colors.transparent,
          dragHandleColor: Go212Colors.neutral300,
          showDragHandle: true,
          elevation: 20,
        ),
        dividerTheme: const DividerThemeData(
          color: Go212Colors.neutral200,
          thickness: 1,
          space: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Go212Colors.neutral800,
          contentTextStyle: Go212Typography.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          surfaceTintColor: Colors.transparent,
        ),
      );
}
