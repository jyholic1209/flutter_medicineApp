import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_colors.dart';

class MyAppThemes {
  // light mode
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'GmarketSansTTF',
        primarySwatch: MyAppColors.primaryMeterialColor,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.white,
        brightness: Brightness.light,
        textTheme: _textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,  // 자연스럽게 보임
      );
      
  // dark mode
  static ThemeData get darkTheme => ThemeData(
        fontFamily: 'GmarketSansTTF',
        primarySwatch: MyAppColors.primaryMeterialColor,
        //  scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.white,
        brightness: Brightness.dark,
        textTheme: _textTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}
