// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = 'http://10.0.2.2:3000/api';

class FavoritosController extends ChangeNotifier {
  bool isLoading = false;
  List<dynamic> favoritos = [];
  String? error;

  Future<void> cargarFavoritos() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/favoritos'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Corrección: Asegurar que si 'data' es null no explote la app
        favoritos = (body['data'] as List<dynamic>?) ?? [];
      } else {
        error = 'Error al cargar favoritos';
      }
    } catch (_) {
      error = 'No se pudo conectar al servidor';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> agregarFavorito(int negocioId) async {
    try {
      final token = await AuthService.obtenerToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/favoritos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'negocio_id': negocioId}),
      ).timeout(const Duration(seconds: 10));

      // Aceptamos tanto 201 (Created) como 200 (OK) por seguridad
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> eliminarFavorito(int negocioId) async {
    try {
      final token = await AuthService.obtenerToken();
      final response = await http.delete(
        Uri.parse('$_baseUrl/favoritos/$negocioId'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Corrección: Parseo seguro para comparar IDs
        favoritos.removeWhere((f) {
          final idF = f['negocio_id'] is int
              ? f['negocio_id']
              : int.tryParse(f['negocio_id']?.toString() ?? '');
          return idF == negocioId;
        });
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}