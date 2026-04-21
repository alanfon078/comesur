// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'results_screen.dart';
import '../logic/search_history_service.dart';
import '../logic/filter_controller.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _comidaController = TextEditingController();
  final TextEditingController _presupuestoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final SearchHistoryService _historialService = SearchHistoryService();
  final FilterController _filterController = FilterController(); // Instancia del controlador

  List<Map<String, String>> _historial = [];

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    final historial = await _historialService.obtenerHistorial();
    if (mounted) {
      setState(() {
        _historial = historial;
      });
    }
  }

  void _seleccionarBusqueda(Map<String, String> entrada) {
    setState(() {
      _comidaController.text = entrada['tipoComida'] ?? '';
      _presupuestoController.text = entrada['presupuesto'] ?? '';
    });
  }

  Future<void> _aplicarFiltros() async {
    if (_formKey.currentState!.validate()) {
      final tipoComida = _comidaController.text;
      final presupuesto = _presupuestoController.text;

      // Guardar en historial localmente
      await _historialService.guardarBusqueda(tipoComida, presupuesto);

      // Delegar la petición y la lógica de reintentos al controlador
      await _filterController.aplicarFiltros(tipoComida, presupuesto);

      // Verificamos que el widget siga montado después del await
      if (!mounted) return;

      // Manejar el resultado devuelto por el controlador
      if (_filterController.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_filterController.error!),
            backgroundColor: Colors.red[700],
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: _aplicarFiltros,
            ),
          ),
        );
      } else {
        // Éxito: Actualizar historial y navegar a resultados
        _cargarHistorial();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ResultsScreen(resultados: _filterController.resultados),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _comidaController.dispose();
    _presupuestoController.dispose();
    _filterController.dispose(); // Es importante liberar el controlador de memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué se te antoja?', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Text('TIPO DE COMIDA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _comidaController,
                decoration: InputDecoration(
                  hintText: 'Ej. Hamburguesa, Tacos...',
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.fastfood),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa qué deseas comer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text('PRESUPUESTO MÁXIMO (OPCIONAL)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _presupuestoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Ej. 40',
                  filled: true,
                  fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final numero = double.tryParse(value);
                    if (numero == null || numero <= 0) {
                      return 'Ingresa un presupuesto válido mayor a \$0';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón Aplicar Filtros reactivo al estado del controlador usando ListenableBuilder
              ListenableBuilder(
                listenable: _filterController,
                builder: (context, _) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _filterController.isLoading ? null : _aplicarFiltros,
                    child: _filterController.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : const Text('APLICAR FILTROS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  );
                },
              ),

              // --- Historial de Búsquedas ---
              if (_historial.isNotEmpty) ...[
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BÚSQUEDAS RECIENTES',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _historialService.limpiarHistorial();
                        _cargarHistorial();
                      },
                      child: const Text('Limpiar', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._historial.map((entrada) {
                  final tipoComida = entrada['tipoComida'] ?? '';
                  final presupuesto = entrada['presupuesto'] ?? '';
                  final subtitulo = presupuesto.isNotEmpty
                      ? 'Presupuesto: \$$presupuesto'
                      : 'Sin límite de presupuesto';

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.history, color: Theme.of(context).primaryColor),
                    title: Text(tipoComida, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(subtitulo, style: const TextStyle(fontSize: 12)),
                    onTap: () => _seleccionarBusqueda(entrada),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: isDark ? Colors.grey[900]!.withOpacity(0.5) : Colors.grey[100],
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}