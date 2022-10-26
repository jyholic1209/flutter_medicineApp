import 'package:flutter/material.dart';
import 'package:flutter_myapp/components/myapp_themes.dart';
import 'package:flutter_myapp/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // custom Theme
      theme: MyAppThemes.lightTheme,

      home: const HomePage(),
      // bulid 추가
      builder: ((context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!)),
    );
  }
}
