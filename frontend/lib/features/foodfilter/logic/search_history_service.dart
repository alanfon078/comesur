// Autor: Alan Yael Fonseca Ruiz

import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _key = 'search_history';
  static const int _maxItems = 10;

  // Guardar una nueva búsqueda en el historial
  Future<void> guardarBusqueda(String tipoComida, String presupuesto) async {
    final prefs = await SharedPreferences.getInstance();
    final historial = prefs.getStringList(_key) ?? [];

    // Formato: "tipoComida|presupuesto"
    final entrada = '$tipoComida|$presupuesto';

    // Eliminar duplicado si ya existe
    historial.remove(entrada);

    // Insertar al inicio (más reciente primero)
    historial.insert(0, entrada);

    // Limitar a 10 elementos
    if (historial.length > _maxItems) {
      historial.removeRange(_maxItems, historial.length);
    }

    await prefs.setStringList(_key, historial);
  }

  // Obtener el historial de búsquedas
  Future<List<Map<String, String>>> obtenerHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final historial = prefs.getStringList(_key) ?? [];

    return historial.map((entrada) {
      final partes = entrada.split('|');
      return {
        'tipoComida': partes.isNotEmpty ? partes[0] : '',
        'presupuesto': partes.length > 1 ? partes[1] : '',
      };
    }).toList();
  }

  // Limpiar todo el historial
  Future<void> limpiarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
