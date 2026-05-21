// Autor: Alan Yael Fonseca Ruiz

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyToken = 'auth_token';
  static const String _keyNombre = 'auth_nombre';
  static const String _keyCorreo = 'auth_correo';
  static const String _keyRol = 'auth_rol';
  static const String _keyId = 'auth_id';

  // Guardar datos de sesión tras login exitoso
// Guardar datos de sesión tras login exitoso
  static Future<void> guardarSesion({
    required String token,
    required int id,
    required String nombre,
    required String correo,
    String? rol, // Se cambia a opcional (String?)
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyId, id);
    await prefs.setString(_keyNombre, nombre);
    await prefs.setString(_keyCorreo, correo);
    // Si el rol viene nulo, le asignamos 'Cliente' por defecto
    await prefs.setString(_keyRol, rol ?? 'Cliente');
  }

  // Obtener el JWT almacenado
  static Future<String?> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Obtener ID del usuario autenticado
  static Future<int?> obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyId);
  }

  // Obtener datos del usuario como mapa
  static Future<Map<String, String>?> obtenerDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    if (token == null) return null;
    return {
      'nombre': prefs.getString(_keyNombre) ?? '',
      'correo': prefs.getString(_keyCorreo) ?? '',
      'rol': prefs.getString(_keyRol) ?? '',
    };
  }

  // ¿Hay sesión activa?
  static Future<bool> estaAutenticado() async {
    final token = await obtenerToken();
    if (token == null || token.isEmpty) return false;

    // Decodificar payload del JWT (base64url, sin verificar firma)
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      // El payload es la segunda parte del token (index 1)
      final normalized = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(payloadString);

      final exp = payload['exp'] as int?;
      if (exp == null) return false;

      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      if (DateTime.now().isAfter(expDate)) {
        await cerrarSesion(); // Limpiar sesión expirada
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // Cerrar sesión
  static Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyId);
    await prefs.remove(_keyNombre);
    await prefs.remove(_keyCorreo);
    await prefs.remove(_keyRol);
  }
}
