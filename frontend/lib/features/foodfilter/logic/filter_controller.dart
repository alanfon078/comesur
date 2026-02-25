// Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FilterController extends ChangeNotifier {
  bool isLoading = false;
  List<dynamic> resultados = [];
  String? error;

  // Método que procesa el CU1: Filtrar comida según preferencias
  Future<void> aplicarFiltros(String tipoComida, String presupuestoTxt) async {
    isLoading = true;
    error = null;
    resultados = [];
    notifyListeners();

    try {
      // Configuramos los parámetros de la URL
      // Usamos 10.0.2.2 en lugar de localhost para el emulador de Android
      final uri = Uri.parse('http://10.0.2.2:3000/api/negocios/filtrar').replace(
        queryParameters: {
          if (tipoComida.isNotEmpty) 'tipoComida': tipoComida,
          if (presupuestoTxt.isNotEmpty) 'presupuesto': presupuestoTxt,
        },
      );

      print('Realizando petición a: $uri');

      // Hacemos la petición GET al servidor Node.js
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Si la petición es exitosa, decodificamos el JSON
        resultados = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // Manejo del escenario alternativo 8a: No se encuentran resultados
        error = 'No hay comidas que coincidan con los filtros especificados';
      } else {
        // Otros errores del servidor
        error = 'Ocurrió un error al consultar los datos. Código: ${response.statusCode}';
      }
    } catch (e) {
      // Manejo del escenario alternativo 7a: Falla de conexión a la base de datos/servidor
      error = 'No se pudo concretar la búsqueda. Verifica tu conexión.';
      print('Error de conexión: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}