// Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert';
import '../../../services/auth_service.dart';
import '../../../services/api_constants.dart';


class FilterController extends ChangeNotifier {
  bool isLoading = false;
  List<dynamic> resultados = [];
  String? error;
  String? errorCode;

  // Método que procesa el CU1: Filtrar comida según preferencias, con retry automático
  Future<void> aplicarFiltros(String tipoComida, String presupuestoTxt,
      {int maxAttempts = 2}) async {
    isLoading = true;
    error = null;
    errorCode = null;
    resultados = [];
    notifyListeners();

    int intentos = 0;
    while (intentos < maxAttempts) {
      try {
        final uri = Uri.parse('${ApiConstants.baseUrl}/negocios/filtrar').replace(
          queryParameters: {
            if (tipoComida.isNotEmpty) 'tipoComida': tipoComida,
            if (presupuestoTxt.isNotEmpty) 'presupuesto': presupuestoTxt,
          },
        );

        final response =
            await http.get(uri).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          resultados = body['data'] as List<dynamic>;
        } else if (response.statusCode == 404) {
          error = 'No hay comidas que coincidan con los filtros especificados.';
          errorCode = 'NO_RESULTS_FOUND';
        } else {
          final body = jsonDecode(response.body);
          errorCode =
              body['error']?['code'] ?? 'ERROR_${response.statusCode}';
          final mensaje =
              body['error']?['message'] ?? 'Ocurrió un error inesperado';
          error = '$mensaje (Código: $errorCode)';
        }
        break; // Salir del loop si la petición fue exitosa o error definido
      } catch (e) {
        intentos++;
        if (intentos >= maxAttempts) {
          error =
              'No se pudo conectar al servidor. Verifica tu conexión a internet.';
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
