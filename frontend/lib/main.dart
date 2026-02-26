// Autor: Alan Yael Fonseca Ruiz
import 'package:flutter/material.dart';

// Importamos las pantallas que creaste previamente
import 'features/login/login_screen.dart';
import 'features/foodfilter/screens/filter_screen.dart';

void main() {
  runApp(const ComeSurApp());
}

class ComeSurApp extends StatelessWidget {
  const ComeSurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComeSur',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system, 
      
      // --- TEMA CLARO ---
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.green,
          secondary: Colors.grey,
        ),
      ),

      // --- TEMA OSCURO ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.greenAccent, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.white, 
        ),
      ),
      
      // Cambiamos el home para que apunte a tu Login real
      home: const LoginScreen(), 
    );
  }
}