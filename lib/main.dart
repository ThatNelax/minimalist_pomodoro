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
          primary: Color(0xffF7934C),
          onPrimary: Color(0xff000000),
          secondary: Color(0xffFFC15E),
          onSecondary: Color(0xff000000),
          error: Color(0xffCF6679),
          onError: Color(0xff121212),
          surface: Color(0xff121212),
          onSurface: Color(0xffF0F0F0),
          tertiary: Color(0xffCC5803),
          onTertiary: Color(0xffFFFFFF),
        ),
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
      ),
    );
  }
}