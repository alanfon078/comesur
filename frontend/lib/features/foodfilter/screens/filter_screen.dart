// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'results_screen.dart'; // Importamos la nueva pantalla

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _comidaController = TextEditingController();
  final TextEditingController _presupuestoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false; // Variable para mostrar un símbolo de carga

  Future<void> _aplicarFiltros() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Iniciamos la animación de carga
      });

      final tipoComida = _comidaController.text;
      final presupuesto = _presupuestoController.text;

      try {
        // Configuramos la petición hacia tu backend en Node.js
        final uri = Uri.parse('http://localhost:3000/api/negocios/filtrar').replace(
          queryParameters: {
            if (tipoComida.isNotEmpty) 'tipoComida': tipoComida,
            if (presupuesto.isNotEmpty) 'presupuesto': presupuesto,
          },
        );

        // Hacemos la consulta [cite: 46]
        final response = await http.get(uri);

        List<dynamic> resultados = [];
        
        if (response.statusCode == 200) {
          resultados = jsonDecode(response.body); // Convertimos el JSON a lista
        } else if (response.statusCode == 404) {
          resultados = []; // Si da 404, la lista queda vacía para mostrar el mensaje de error [cite: 66, 67]
        }

        // Si la pantalla sigue activa, navegamos a los resultados y mostramos la lista ordenada [cite: 47]
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(resultados: resultados),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error de conexión con el servidor. Verifica que Node.js esté encendido.')), // Escenario 7a [cite: 63]
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Detenemos la animación de carga
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Qué se te antoja?', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
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
                      return 'Ingresa un presupuesto válido mayor a \$0'; // Corrección del símbolo de dólar aplicada [cite: 61, 62]
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón Aplicar Filtros con indicador de carga
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _isLoading ? null : _aplicarFiltros,
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('APLICAR FILTROS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _comidaController.dispose();
    _presupuestoController.dispose();
    super.dispose();
  }
}