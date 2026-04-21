// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';

const String _baseUrl = 'http://10.0.2.2:3000/api';

class DisponibilidadController extends ChangeNotifier {
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  int? negocioId;
  String? horarioApertura;
  String? horarioCierre;
  List<Map<String, dynamic>> productos = [];
  Set<int> menuDelDia = {};

  // Carga el negocio del dueño con productos y menú del día
  Future<void> cargar() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/negocios/mio'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body)['data'] as Map<String, dynamic>;
        negocioId = body['id'] as int?;
        horarioApertura = body['horarioApertura']?.toString();
        horarioCierre = body['horarioCierre']?.toString();
        productos = List<Map<String, dynamic>>.from(body['menu'] as List? ?? []);

        final idsRaw = body['menuDelDia'];
        if (idsRaw is List) {
          menuDelDia = idsRaw.map((e) => e as int).toSet();
        } else {
          menuDelDia = {};
        }
      } else if (response.statusCode == 404) {
        negocioId = null;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al cargar datos';
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cargar disponibilidad: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Alterna si un producto está en el menú del día
  void toggleMenuDelDia(int productoId) {
    if (menuDelDia.contains(productoId)) {
      menuDelDia.remove(productoId);
    } else {
      menuDelDia.add(productoId);
    }
    notifyListeners();
  }

  // Guarda el menú del día en el servidor
  Future<bool> guardarMenuDelDia() async {
    if (negocioId == null) return false;
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.patch(
        Uri.parse('$_baseUrl/negocios/$negocioId/menu-del-dia'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'productoIds': menuDelDia.toList()}),
      ).timeout(const Duration(seconds: 10));

      isSaving = false;
      if (response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al guardar menú del día';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al guardar menú del día: $e');
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  // Guarda el horario de apertura y cierre
  Future<bool> guardarHorario(String? apertura, String? cierre) async {
    if (negocioId == null) return false;
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.patch(
        Uri.parse('$_baseUrl/negocios/$negocioId/horario'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'horarioApertura': apertura,
          'horarioCierre': cierre,
        }),
      ).timeout(const Duration(seconds: 10));

      isSaving = false;
      if (response.statusCode == 200) {
        horarioApertura = apertura;
        horarioCierre = cierre;
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al guardar horario';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al guardar horario: $e');
      isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
