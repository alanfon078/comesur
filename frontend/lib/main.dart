// Autor: Alan Yael Fonseca Ruiz
import 'package:flutter/material.dart';

import 'services/auth_service.dart';
import 'features/login/login_screen.dart';
import 'features/home/home_screen.dart';

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

      // Splash que comprueba si ya hay sesión activa
      home: const _AuthSplash(),

      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

/// Pantalla de inicio que determina a dónde navegar según el estado de la sesión
class _AuthSplash extends StatefulWidget {
  const _AuthSplash();

  @override
  State<_AuthSplash> createState() => _AuthSplashState();
}

class _AuthSplashState extends State<_AuthSplash> {
  @override
  void initState() {
    super.initState();
    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final autenticado = await AuthService.estaAutenticado();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, autenticado ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_rounded, size: 80, color: primaryColor),
            const SizedBox(height: 16),
            const Text(
              'COMESUR',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(color: primaryColor),
          ],
        ),
      ),
    );
  }
}