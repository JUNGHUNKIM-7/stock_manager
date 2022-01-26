import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const outerSpacing = 15.0;
const innerSpacing = 10.0;

class Styles {
  bool darkMode;

  Styles({required this.darkMode});

  static const lightColor = Color(0xffA3A3A3);
  static const darkColor = Color(0xff404040);

  static final lightShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.2),
      blurRadius: 3,
      spreadRadius: 1,
      offset: const Offset(-2, -2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 3,
      offset: const Offset(1.5, 1.5),
    ),
  ];

  static final innerShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurStyle: BlurStyle.solid,
      blurRadius: 1,
      offset: const Offset(-1.5, -1.5),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.2),
      blurRadius: 1,
      offset: const Offset(2, 2),
    ),
  ];

  static final darkShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(0.2),
      blurRadius: 5,
      offset: const Offset(-1, -1),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.6),
      blurRadius: 5,
      spreadRadius: 1,
      offset: const Offset(2, 2),
    ),
  ];

  //fontStyle
  static final highlight = TextStyle(
    fontFamily: GoogleFonts.monoton().fontFamily,
    fontWeight: FontWeight.w700,
  );

  static final header = TextStyle(
    fontFamily: GoogleFonts.righteous().fontFamily,
    fontWeight: FontWeight.w500,
  );

  static final subHeader = TextStyle(
    fontFamily: GoogleFonts.mPlus1p().fontFamily,
    fontWeight: FontWeight.normal,
  );

  //AppBar
  static const appbarLight = AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    foregroundColor: Color(0xff010409),
  );

  static const appbarDark = AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    foregroundColor: Color(0xffF5F5F5),
  );

  static const roundedDrawerBorder = DrawerThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
    ),
  );

  static const bottomNavLight = BottomNavigationBarThemeData(
    backgroundColor: darkColor,
    selectedItemColor: Colors.orange,
    unselectedItemColor: lightColor,
  );

  static const bottomNavDark = BottomNavigationBarThemeData(
    backgroundColor: lightColor,
    selectedItemColor: Colors.redAccent,
    unselectedItemColor: darkColor,
  );

  BottomNavigationBarThemeData returnBottomTheme() {
    return darkMode ? bottomNavDark : bottomNavLight;
  }

  //return ThemeSet
  ThemeData themeMain() {
    return ThemeData(
      appBarTheme: darkMode ? appbarDark : appbarLight,
      drawerTheme: darkMode
          ? roundedDrawerBorder.copyWith(backgroundColor: darkColor)
          : roundedDrawerBorder.copyWith(backgroundColor: lightColor),
      brightness: darkMode ? Brightness.dark : Brightness.light,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: darkMode ? darkColor : lightColor,
      inputDecorationTheme: darkMode
          ? const InputDecorationTheme(
              iconColor: Colors.redAccent, suffixIconColor: Colors.redAccent)
          : const InputDecorationTheme(
              iconColor: Colors.orangeAccent,
              suffixIconColor: Colors.orangeAccent),
      bottomNavigationBarTheme: returnBottomTheme(),
      textTheme: TextTheme(
        headline1: highlight.copyWith(
          fontSize: 32,
          color: darkMode ? Colors.red : const Color(0xff010409),
        ),
        headline2: header.copyWith(
          fontSize: 26.0,
        ),
        subtitle1: subHeader.copyWith(
          fontSize: 22.0,
        ),
        bodyText1: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.openSans().fontFamily,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: darkMode ? Colors.redAccent : Colors.amber,
      ),
    );
  }
}
