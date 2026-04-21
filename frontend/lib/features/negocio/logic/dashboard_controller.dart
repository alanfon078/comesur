// Autor: Alan Yael Fonseca Ruiz

import 'package:ComeSUR/services/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = ApiConstants.baseUrl;

class DashboardController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Map<String, dynamic>? negocio;
  Map<String, dynamic>? estadisticas;

  // Notificaciones
  int nuevasResenas = 0;

  static const String _prefKeyResenas = 'dashboard_last_resenas_';

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

        // Detectar nuevas reseñas para notificación in-app
        await _verificarNuevasResenas(negocioData['id'] as int);
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cargar dashboard: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Verifica si hay nuevas reseñas desde la última visita al dashboard
  Future<void> _verificarNuevasResenas(int negocioId) async {
    final totalActual = (estadisticas?['totalResenas'] as num?)?.toInt() ?? 0;
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefKeyResenas$negocioId';
    final lastSeen = prefs.getInt(key) ?? totalActual;

    nuevasResenas = (totalActual - lastSeen).clamp(0, 999);
  }

  // Marca las reseñas actuales como "vistas" y resetea el contador
  Future<void> marcarResenasVistas() async {
    if (negocio == null) return;
    final negocioId = negocio!['id'] as int;
    final totalActual = (estadisticas?['totalResenas'] as num?)?.toInt() ?? 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_prefKeyResenas$negocioId', totalActual);
    nuevasResenas = 0;
    notifyListeners();
  }
}
