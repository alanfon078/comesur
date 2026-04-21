// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../services/api_constants.dart';


class BusinessDetailController extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic>? negocio;
  String? error;
  String? errorCode;
  bool esFavorito = false;
  bool _favoritoLoading = false;

  // Obtener detalle del negocio por ID, con retry automático
  Future<void> cargarNegocio(int negocioId, {int maxAttempts = 2}) async {
    isLoading = true;
    error = null;
    errorCode = null;
    negocio = null;
    notifyListeners();

    final token = await AuthService.obtenerToken();
    final headers = token != null ? {'Authorization': 'Bearer $token'} : <String, String>{};

    int intentos = 0;
    while (intentos < maxAttempts) {
      try {
        final uri = Uri.parse('${ApiConstants.baseUrl}/negocios/$negocioId');
        final response = await http
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          negocio = body['data'] as Map<String, dynamic>;
          break;
        } else {
          final body = jsonDecode(response.body);
          errorCode = body['error']?['code'] ?? 'ERROR_${response.statusCode}';
          final mensaje = body['error']?['message'] ?? 'Error desconocido';

          if (response.statusCode == 404) {
            error = 'No se encontró la información del negocio.';
            break;
          } else {
            error = '$mensaje (Código: $errorCode)';
            break;
          }
        }
      } catch (e) {
        intentos++;
        if (intentos >= maxAttempts) {
          error = 'No se pudo conectar al servidor. Verifica tu conexión a internet.';
          errorCode = 'CONNECTION_ERROR';
        } else {
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  // Verificar si el negocio ya está en favoritos del usuario
  Future<void> verificarFavorito(int negocioId) async {
    try {
      final token = await AuthService.obtenerToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('http://192.168.137.1:3000/api/favoritos'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final lista = body['data'] as List<dynamic>;
        esFavorito = lista.any((f) => f['negocio_id'] == negocioId);
        notifyListeners();
      }
    } catch (_) {}
  }

  // Toggle favorito
  Future<void> toggleFavorito(int negocioId) async {
    if (_favoritoLoading) return;
    _favoritoLoading = true;

    try {
      final token = await AuthService.obtenerToken();
      if (token == null) return;

      if (esFavorito) {
        final response = await http.delete(
          Uri.parse('http://10.0.2.2:3000/api/favoritos/$negocioId'),
          headers: {'Authorization': 'Bearer $token'},
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          esFavorito = false;
          notifyListeners();
        }
      } else {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/favoritos'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'negocio_id': negocioId}),
        ).timeout(const Duration(seconds: 10));

        // 201 = favorito añadido, 409 = ya era favorito (ambos indican que esFavorito = true)
        if (response.statusCode == 201 || response.statusCode == 409) {
          esFavorito = true;
          notifyListeners();
        }
      }
    } catch (_) {
    } finally {
      _favoritoLoading = false;
    }
  }
}
