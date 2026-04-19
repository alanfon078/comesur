// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BusinessDetailController extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic>? negocio;
  String? error;
  String? errorCode;

  // Obtener detalle del negocio por ID, con retry automático
  Future<void> cargarNegocio(int negocioId, {int maxRetries = 1}) async {
    isLoading = true;
    error = null;
    errorCode = null;
    negocio = null;
    notifyListeners();

    int intentos = 0;
    while (intentos <= maxRetries) {
      try {
        final uri = Uri.parse('http://10.0.2.2:3000/api/negocios/$negocioId');
        final response = await http
            .get(uri)
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
        if (intentos > maxRetries) {
          error = 'No se pudo conectar al servidor. Verifica tu conexión a internet.';
          errorCode = 'CONNECTION_ERROR';
        } else {
          // Esperar brevemente antes de reintentar
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
