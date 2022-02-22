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

  static final header = TextStyle(
    fontFamily: GoogleFonts.monoton().fontFamily,
    fontWeight: FontWeight.w700,
  );

  static final subHeader = TextStyle(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    fontWeight: FontWeight.w700,
  );

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
      backgroundColor: Colors.black26,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: lightColor,
      elevation: 0);

  static const bottomNavDark = BottomNavigationBarThemeData(
      backgroundColor: Colors.black26,
      selectedItemColor: Colors.orangeAccent,
      unselectedItemColor: darkColor,
      elevation: 0);

  BottomNavigationBarThemeData returnBottomTheme() {
    return darkMode ? bottomNavLight : bottomNavDark;
  }

  ThemeData themeMain() {
    return ThemeData(
      errorColor: darkMode ? Colors.orangeAccent : Colors.pinkAccent,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black26,
        foregroundColor: Colors.white,
      ),
      appBarTheme: darkMode ? appbarDark : appbarLight,
      drawerTheme: darkMode
          ? roundedDrawerBorder.copyWith(backgroundColor: darkColor)
          : roundedDrawerBorder.copyWith(backgroundColor: lightColor),
      brightness: darkMode ? Brightness.dark : Brightness.light,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: darkMode ? darkColor : lightColor,
      inputDecorationTheme: darkMode
          ? const InputDecorationTheme(
              iconColor: Colors.redAccent,
              suffixIconColor: Colors.redAccent,
            )
          : const InputDecorationTheme(
              iconColor: Colors.orangeAccent,
              suffixIconColor: Colors.orangeAccent,
            ),
      bottomNavigationBarTheme: returnBottomTheme(),
      textTheme: TextTheme(
        headline1: header.copyWith(
          fontSize: 32,
        ),
        headline2: subHeader.copyWith(
          fontSize: 26.0,
          color: darkMode ? Styles.lightColor : Styles.darkColor,
        ),
        headline3: GoogleFonts.orbitron().copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        headline4: subHeader.copyWith(
          fontSize: 26.0,
          color: Colors.black,
        ),
        bodyText1: GoogleFonts.inter().copyWith(
          fontSize: 16.0,
          color: darkMode ? Styles.lightColor : Styles.darkColor,
          fontWeight: FontWeight.w600,
        ),
        bodyText2: TextStyle(
          fontFamily: 'CascadiaMonoPL',
          fontSize: 16.0,
          color: darkMode ? Styles.lightColor : Styles.darkColor,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: darkMode ? Colors.redAccent : Colors.amber,
      ),
    );
  }
}
