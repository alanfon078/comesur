// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../services/api_constants.dart';


const String _baseUrl = ApiConstants.baseUrl;

class ResenaController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? resenaExistente;

  // Obtener la reseña del usuario para un negocio (si existe)
  Future<void> cargarMiResena(int negocioId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/resenas/negocio/$negocioId'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        resenaExistente = body['data'] as Map<String, dynamic>;
      } else {
        resenaExistente = null;
      }
    } catch (e) {
      resenaExistente = null;
      debugPrint('Error al cargar reseña: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Crear o actualizar reseña
  Future<bool> guardarResena({
    required int negocioId,
    required int calificacion,
    String? comentario,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/resenas'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'negocio_id': negocioId,
          'calificacion': calificacion,
          if (comentario != null && comentario.isNotEmpty) 'comentario': comentario,
        }),
      ).timeout(const Duration(seconds: 10));

      isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al guardar la reseña';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al guardar reseña: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
