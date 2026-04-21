// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../services/api_constants.dart';

const String _baseUrl = ApiConstants.baseUrl;

class MenuController extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  List<Map<String, dynamic>> productos = [];
  int? negocioId;

  // Carga los productos del negocio del dueño autenticado
  Future<void> cargarMenu() async {
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
        productos = List<Map<String, dynamic>>.from(body['menu'] as List? ?? []);
      } else if (response.statusCode == 404) {
        negocioId = null;
        productos = [];
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al cargar el menú';
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cargar menú: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Agrega un nuevo platillo
  Future<bool> agregarProducto({
    required String nombre,
    String? descripcion,
    required double precio,
  }) async {
    if (negocioId == null) return false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.post(
        Uri.parse('$_baseUrl/negocios/$negocioId/productos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nombre': nombre,
          if (descripcion != null && descripcion.isNotEmpty) 'descripcion': descripcion,
          'precio': precio,
        }),
      ).timeout(const Duration(seconds: 10));

      isLoading = false;

      if (response.statusCode == 201) {
        final nuevo = jsonDecode(response.body)['data'] as Map<String, dynamic>;
        productos.add(nuevo);
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al agregar platillo';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al agregar producto: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Actualiza un platillo existente
  Future<bool> actualizarProducto({
    required int productoId,
    required String nombre,
    String? descripcion,
    required double precio,
  }) async {
    if (negocioId == null) return false;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.put(
        Uri.parse('$_baseUrl/negocios/$negocioId/productos/$productoId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nombre': nombre,
          if (descripcion != null && descripcion.isNotEmpty) 'descripcion': descripcion,
          'precio': precio,
        }),
      ).timeout(const Duration(seconds: 10));

      isLoading = false;

      if (response.statusCode == 200) {
        final idx = productos.indexWhere((p) => p['id'] == productoId);
        if (idx != -1) {
          productos[idx] = {
            ...productos[idx],
            'nombre': nombre,
            'descripcion': descripcion,
            'precio': precio,
          };
        }
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al actualizar platillo';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al actualizar producto: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Elimina un platillo
  Future<bool> eliminarProducto(int productoId) async {
    if (negocioId == null) return false;

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.delete(
        Uri.parse('$_baseUrl/negocios/$negocioId/productos/$productoId'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        productos.removeWhere((p) => p['id'] == productoId);
        notifyListeners();
        return true;
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al eliminar platillo';
        notifyListeners();
        return false;
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al eliminar producto: $e');
      notifyListeners();
      return false;
    }
  }

  // Cambia la disponibilidad de un platillo
  Future<void> toggleDisponibilidad(int productoId) async {
    if (negocioId == null) return;

    try {
      final token = await AuthService.obtenerToken();
      final response = await http.patch(
        Uri.parse('$_baseUrl/negocios/$negocioId/productos/$productoId/disponibilidad'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as Map<String, dynamic>;
        final idx = productos.indexWhere((p) => p['id'] == productoId);
        if (idx != -1) {
          productos[idx] = {...productos[idx], 'disponible': data['disponible']};
          notifyListeners();
        }
      } else {
        final body = jsonDecode(response.body);
        error = body['error']?['message'] ?? 'Error al cambiar disponibilidad';
        notifyListeners();
      }
    } catch (e) {
      error = 'No se pudo conectar al servidor';
      debugPrint('Error al cambiar disponibilidad: $e');
      notifyListeners();
    }
  }
}
