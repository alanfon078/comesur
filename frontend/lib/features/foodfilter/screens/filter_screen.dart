// Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _comidaController = TextEditingController();
  final TextEditingController _presupuestoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _aplicarFiltros() {
    if (_formKey.currentState!.validate()) {
      // Aquí se llamaría a la lógica para buscar en la BD (aplicarFiltros)
      final tipoComida = _comidaController.text;
      final presupuesto = _presupuestoController.text;
      
      print('Buscando: $tipoComida con presupuesto máximo de: \$$presupuesto');
      // Navegar a la pantalla de resultados (listaOrdenada)
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
              
              // Input: Tipo de Comida
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
                    return 'Por favor ingresa qué deseas comer'; // Notificación si el nombre es inválido
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input: Presupuesto Máximo (Opcional)
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
                      return 'Ingresa un presupuesto válido mayor a $0'; // Validación del escenario alternativo 5a
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón Aplicar Filtros
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: _aplicarFiltros,
                child: const Text('APLICAR FILTROS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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