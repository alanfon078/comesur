// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = 'http://10.0.2.2:3000/api';

class DashboardController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? negocio;
  Map<String, dynamic>? estadisticas;

  // Carga el negocio del dueño autenticado junto con las estadísticas del dashboard
  Future<void> cargarDashboard() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final headers = {'Authorization': 'Bearer $token'};

      // Obtener el negocio del dueño
      final negocioRes = await http.get(
        Uri.parse('$_baseUrl/negocios/mio'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (negocioRes.statusCode == 404) {
        negocio = null;
        estadisticas = null;
        isLoading = false;
        notifyListeners();
        return;
      }

      if (negocioRes.statusCode != 200) {
        final body = jsonDecode(negocioRes.body);
        error = body['error']?['message'] ?? 'Error al cargar el negocio';
        isLoading = false;
        notifyListeners();
        return;
      }

      final negocioData = jsonDecode(negocioRes.body)['data'] as Map<String, dynamic>;
      negocio = negocioData;

      // Obtener estadísticas del dashboard
      final dashRes = await http.get(
        Uri.parse('$_baseUrl/negocios/${negocioData['id']}/dashboard'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (dashRes.statusCode == 200) {
        estadisticas = jsonDecode(dashRes.body)['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cargar dashboard: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
