// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = 'http://10.0.2.2:3000/api';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  // LOGIN CON CORREO Y CONTRASEÑA
  Future<bool> login(String correo, String contrasena) async {
    _iniciarCarga();

    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      )
          .timeout(const Duration(seconds: 10));

      return _procesarRespuestaAuth(response);
    } catch (_) {
      error = 'No se pudo conectar al servidor. Verifica tu conexión.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // REGISTRO CON CORREO Y CONTRASEÑA
  Future<bool> register(String nombre, String correo, String contrasena) async {
    _iniciarCarga();

    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'correo': correo, 'contrasena': contrasena}),
      )
          .timeout(const Duration(seconds: 10));

      return _procesarRespuestaAuth(response);
    } catch (_) {
      error = 'No se pudo conectar al servidor. Verifica tu conexión.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIN CON GOOGLE (CORREGIDO PARA V7+)
  Future<bool> loginConGoogle() async {
    _iniciarCarga();

    try {
      // 1. Es obligatorio inicializar la instancia en la versión 7.0+
      await GoogleSignIn.instance.initialize();

      // 2. authenticate() reemplaza a signIn(). Si el usuario cancela, lanzará una excepción.
      final googleUser = await GoogleSignIn.instance.authenticate();

      // 3. Obtenemos las credenciales
      final auth = await googleUser.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        error = 'No se pudo obtener el token de Google.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http
          .post(
        Uri.parse('$_baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      )
          .timeout(const Duration(seconds: 15));

      return _procesarRespuestaAuth(response);
    } catch (_) {
      // Si el usuario cierra el modal de Google, caerá en este catch.
      error = 'Error al iniciar sesión con Google o cancelado por el usuario.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // LOGIN CON FACEBOOK
  Future<bool> loginConFacebook() async {
    _iniciarCarga();

    try {
      final result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        error = null;
        isLoading = false;
        notifyListeners();
        return false;
      }

      final accessToken = result.accessToken?.tokenString;
      if (accessToken == null) {
        error = 'No se pudo obtener el token de Facebook.';
        isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await http
          .post(
        Uri.parse('$_baseUrl/auth/facebook'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'accessToken': accessToken}),
      )
          .timeout(const Duration(seconds: 15));

      return _procesarRespuestaAuth(response);
    } catch (_) {
      error = 'Error al iniciar sesión con Facebook.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Procesa la respuesta de cualquier endpoint de auth y guarda la sesión
  Future<bool> _procesarRespuestaAuth(http.Response response) async {
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = body['data'];
      final usuario = data['usuario'];
      final token = data['token'];

      await AuthService.guardarSesion(
        token: token,
        id: usuario['id'],
        nombre: usuario['nombre'],
        correo: usuario['correo'],
        rol: usuario['rol'],
      );

      isLoading = false;
      notifyListeners();
      return true;
    } else {
      error = body['error']?['message'] ?? 'Error desconocido';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _iniciarCarga() {
    isLoading = true;
    error = null;
    notifyListeners();
  }
}