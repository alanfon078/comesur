// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = 'http://10.0.2.2:3000/api';

class PerfilController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? perfil;

  Future<void> cargarPerfil() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/perfil'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        perfil = body['data'] as Map<String, dynamic>;
      } else {
        error = 'Error al cargar el perfil';
      }
    } catch (_) {
      error = 'No se pudo conectar al servidor';
    }

    isLoading = false;
    notifyListeners();
  }
}
