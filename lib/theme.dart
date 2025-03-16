import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData cutePastelTheme = ThemeData(
  // Use a softer pink as primary color
  primarySwatch: Colors.pink,
  primaryColor: Color(0xFFFFC0CB),
  
  // Light pastel background
  scaffoldBackgroundColor: Color(0xFFFFF0F5),
  
  // Typography
  textTheme: TextTheme(
    displayLarge: GoogleFonts.quicksand(
      fontWeight: FontWeight.w700,
      color: Color(0xFFD25A7E),
    ),
    displayMedium: GoogleFonts.quicksand(
      fontWeight: FontWeight.w700,
      color: Color(0xFFD25A7E),
    ),
    displaySmall: GoogleFonts.quicksand(
      fontWeight: FontWeight.w700,
      color: Color(0xFFD25A7E),
    ),
    headlineMedium: GoogleFonts.quicksand(
      fontWeight: FontWeight.w700,
      color: Color(0xFFD25A7E),
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      color: Color(0xFF5D4037),
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      color: Color(0xFF5D4037),
    ),
  ),
  
  // AppBar theme with gradient and rounded bottom
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFFB6C1),
    centerTitle: true,
    elevation: 0,
    titleTextStyle: GoogleFonts.quicksand(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
  ),
  
  // Cute floating action button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFA5B1),
    foregroundColor: Colors.white,
    elevation: 4,
    splashColor: Color(0xFFFF85A2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  
  // Soft bottom navigation bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFE4E8),
    selectedItemColor: Color(0xFFFF5C8D),
    unselectedItemColor: Color(0xFFFFADC6),
    selectedLabelStyle: GoogleFonts.nunito(
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
    unselectedLabelStyle: GoogleFonts.nunito(
      fontSize: 12,
    ),
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  
  // Card theme with soft shadows and rounded corners
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    shadowColor: Color(0xFFFFCDD2).withOpacity(0.4),
  ),
  
  // Input decoration for text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFFFD6DD), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFFFD6DD), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0xFFFF8FAB), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    hintStyle: GoogleFonts.nunito(color: Color(0xFFCCAFB0)),
    labelStyle: GoogleFonts.quicksand(color: Color(0xFFD27D93)),
  ),
  
  // Button theme with gradient
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFFA5B1),
      foregroundColor: Colors.white,
      elevation: 2,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: GoogleFonts.quicksand(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  
  // Icon theme
  iconTheme: IconThemeData(
    color: Color(0xFFF48FB1),
    size: 24,
  ),
  
  // Divider
  dividerTheme: DividerThemeData(
    color: Color(0xFFFFD6DD),
    thickness: 1,
    space: 24,
  ),
);

// You should add this to your pubspec.yaml:
// dependencies:
//   google_fonts: ^6.1.0