// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../services/api_constants.dart';

final String _baseUrl = ApiConstants.baseUrl;

class EstadisticasController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  int? negocioId;
  Map<String, dynamic>? datos;

  // Carga el negocio y luego las estadísticas
  Future<void> cargar() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final headers = {'Authorization': 'Bearer $token'};

      // Obtener el ID del negocio
      final negocioRes = await http.get(
        Uri.parse('$_baseUrl/negocios/mio'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (negocioRes.statusCode == 404) {
        negocioId = null;
        isLoading = false;
        notifyListeners();
        return;
      }
      if (negocioRes.statusCode != 200) {
        final body = jsonDecode(negocioRes.body);
        error = body['error']?['message'] ?? 'Error al cargar negocio';
        isLoading = false;
        notifyListeners();
        return;
      }

      final negocioData = jsonDecode(negocioRes.body)['data'] as Map<String, dynamic>;
      negocioId = negocioData['id'] as int?;

      // Obtener estadísticas
      final statsRes = await http.get(
        Uri.parse('$_baseUrl/negocios/$negocioId/estadisticas'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (statsRes.statusCode == 200) {
        datos = jsonDecode(statsRes.body)['data'] as Map<String, dynamic>;
      } else {
        final body = jsonDecode(statsRes.body);
        error = body['error']?['message'] ?? 'Error al cargar estadísticas';
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cargar estadísticas: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Genera un reporte en formato CSV y lo copia al portapapeles
  Future<void> exportarReporte() async {
    if (datos == null) return;

    final distribucion = datos!['distribucion'] as Map<String, dynamic>? ?? {};
    final tendencia = datos!['tendencia'] as List<dynamic>? ?? [];

    final buffer = StringBuffer();
    buffer.writeln('Reporte de Estadísticas - ComeSur');
    buffer.writeln('Generado: ${DateTime.now()}');
    buffer.writeln();

    buffer.writeln('=== RESUMEN ===');
    buffer.writeln('Total de vistas,${datos!['totalVistas'] ?? 0}');
    buffer.writeln('Total de favoritos,${datos!['totalFavoritos'] ?? 0}');
    buffer.writeln('Total de reseñas,${datos!['totalResenas'] ?? 0}');
    buffer.writeln('Calificación promedio,${datos!['promedioCalificacion'] ?? '0.00'}');
    buffer.writeln();

    buffer.writeln('=== DISTRIBUCIÓN DE CALIFICACIONES ===');
    buffer.writeln('Estrellas,Cantidad');
    for (int i = 5; i >= 1; i--) {
      buffer.writeln('$i,${distribucion['$i'] ?? 0}');
    }
    buffer.writeln();

    buffer.writeln('=== TENDENCIA MENSUAL ===');
    buffer.writeln('Periodo,Reseñas,Promedio');
    for (final t in tendencia) {
      buffer.writeln('${t['periodo']},${t['resenas']},${t['promedio']}');
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
  }

  // Obtiene el total de reseñas
  int get totalResenas => (datos?['totalResenas'] as num?)?.toInt() ?? 0;

  // Obtiene la distribución de calificaciones (1-5)
  Map<int, int> get distribucion {
    final raw = datos?['distribucion'] as Map<String, dynamic>? ?? {};
    return {
      1: (raw['1'] as num?)?.toInt() ?? 0,
      2: (raw['2'] as num?)?.toInt() ?? 0,
      3: (raw['3'] as num?)?.toInt() ?? 0,
      4: (raw['4'] as num?)?.toInt() ?? 0,
      5: (raw['5'] as num?)?.toInt() ?? 0,
    };
  }

  // Obtiene la tendencia mensual como lista
  List<Map<String, dynamic>> get tendencia {
    final raw = datos?['tendencia'] as List<dynamic>? ?? [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
