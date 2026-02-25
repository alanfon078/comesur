//Alan Yael Fonseca Ruiz
import 'package:flutter/material.dart';

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
      // Cambia automaticamente según la configuración del dispositivo del usuario
      themeMode: ThemeMode.system, 
      
      // --- TEMA CLARO ---
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Fondo principal
        primaryColor: Colors.green, // Color institucional ITSUR
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // Texto del AppBar
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.green,
          secondary: Colors.grey, // Detalles secundarios
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.grey), // Texto base
        ),
      ),

      // --- TEMA OSCURO ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Fondo principal
        primaryColor: Colors.greenAccent, // Verde más brillante para resaltar en negro
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white, // Texto del AppBar
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.white, 
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white), // Texto base
        ),
      ),
      
      home: const HomeScreen(),
    );
  }
}

// Pantalla inicial de prueba
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComeSur'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fastfood,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Qué buscas comer hoy?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }
}