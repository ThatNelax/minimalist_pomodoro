import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xff3c99ef),
          onPrimary: Color(0xffe0e0e0),
          secondary: Color(0xff343434),
          onSecondary: Color(0xffe0e0e0),
          error: Color(0xffCF6679),
          onError: Color(0xff121212),
          surface: Color(0xff141414),
          onSurface: Color(0xffF0F0F0),
          tertiary: Color(0xffffffff),
          onTertiary: Color(0xff121212),
        ),
        textTheme: GoogleFonts.robotoFlexTextTheme(),
      ),
    );
  }
}