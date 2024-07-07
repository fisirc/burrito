import 'package:flutter/material.dart';

const Map<String, Color> _colorThemes = {
  'backgroundBlack': Color(0xFF171920),
  'surface': Color(0xFF252A34),
  'accent': Color(0xFF74777C),
  'primary': Color(0xFF586DFA),
  'secondary': Color(0xFFC923FF),
  'tertiary': Color(0xFFC3D1E4),
  'backgroundError': Color(0xFFF7D7DA),
  'highlight': Color(0xFF78262E),
  'danger': Color(0xFFDC1200),
  'white': Colors.white,
  'black': Colors.black,
};

class BurritoMobileTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _colorThemes['primary']!,
      onPrimary: _colorThemes['white']!,
      secondary: _colorThemes['secondary']!,
      onSecondary: _colorThemes['secondary']!,
      tertiary: _colorThemes['tertiary']!,
      error: _colorThemes['danger']!,
      onError: _colorThemes['primary']!,
      // background: _colorThemes['backgroundBlack']!,
      // onBackground: _colorThemes['primary']!,
      surface: _colorThemes['surface']!,
      onSurface: _colorThemes['accent']!,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: 17),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Roboto',
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(Colors.grey[400]),
      thickness: MaterialStateProperty.all(8),
      radius: const Radius.circular(10),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}
