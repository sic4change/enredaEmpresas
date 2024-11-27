import 'package:enreda_empresas/app/values/values.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _lightFillColor = Colors.red;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);

  static ThemeData lightThemeData =
  themeData(lightColorScheme, _lightFocusColor);

  static MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      dialogTheme: DialogTheme().copyWith(surfaceTintColor: Colors.white,),
      primarySwatch: white,
      useMaterial3: true,
      textTheme: _textTheme,
      iconTheme: IconThemeData(color: AppColors.greyBorder),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      focusColor: AppColors.primaryColor, colorScheme: colorScheme.copyWith(secondary: colorScheme.primary),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: AppColors.primaryColor,
    secondary: AppColors.primaryColor,
    background: Colors.white,
    surface: Color(0xFFFAFBFB),
    onBackground: AppColors.primaryColor,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: Color(0xFF241E30),
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  // static const _superBold = FontWeight.w900;
  static const _bold = FontWeight.w700;
  // static const _semiBold = FontWeight.w600;
  static const _medium = FontWeight.w500;
  static const _regular = FontWeight.w400;
  static const _light = FontWeight.w300;

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_96,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    displayMedium: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_60,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    displaySmall: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_48,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headlineMedium: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_34,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headlineSmall: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_24,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    titleLarge: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_20,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    titleMedium: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_18,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    titleSmall: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_14,
      color: AppColors.black,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    bodyLarge: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_16,
      color: AppColors.primaryText2,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    bodyMedium: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_15,
      color: AppColors.black,
      fontWeight: _regular,
      fontStyle: FontStyle.normal,
    ),
    labelLarge: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_16,
      color: AppColors.black,
      fontStyle: FontStyle.normal,
      fontWeight: _regular,
    ),
    //For info button text
    labelMedium: GoogleFonts.inter(
      fontSize: Sizes.TEXT_SIZE_14,
      color: AppColors.greyTxtAlt,
      fontStyle: FontStyle.normal,
      fontWeight: _medium,
    ),
    bodySmall: GoogleFonts.outfit(
      fontSize: Sizes.TEXT_SIZE_12,
      color: AppColors.chatDarkGray,
      fontWeight: _regular,
      fontStyle: FontStyle.normal,
    ),
  );
}