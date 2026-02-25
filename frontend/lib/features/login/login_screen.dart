// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Detectamos si el tema actual es oscuro o claro para ajustar contrastes
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo y Título
              const Center(
                child: Text(
                  'COMESUR',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  '¿QUÉ BUSCAS COMER?',
                  style: TextStyle(fontSize: 14, letterSpacing: 1.2),
                ),
              ),
              const SizedBox(height: 40),

              // Formulario de Ingreso
              const Text('USUARIO / CORREO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const Text('CONTRASEÑA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '******',
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botón Principal
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // Verde
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Lógica para iniciar sesión
                },
                child: const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),

              const Center(child: Text('O ingresa con')),
              const SizedBox(height: 20),

              // Botones de Autenticación Social
              OutlinedButton.icon(
                icon: Icon(Icons.g_mobiledata, color: isDark ? Colors.white : Colors.black, size: 30),
                label: Text('Login con Google', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.facebook, color: Colors.blue),
                label: Text('Login con Facebook', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 30),

              // Crear cuenta nueva
              TextButton(
                onPressed: () {
                  // Navegar a pantalla de registro
                },
                child: Text(
                  'Crear Cuenta Nueva',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              // Ilustración decorativa inferior (simulada con un ícono)
              const SizedBox(height: 20),
              Center(
                child: Icon(
                  Icons.fastfood_rounded,
                  size: 60,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}