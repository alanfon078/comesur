// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final List<dynamic> resultados;

  const ResultsScreen({super.key, required this.resultados});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: resultados.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay comidas que coincidan con los filtros especificados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Modificar Filtros', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final item = resultados[index];
                return Card(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
                    ),
                    title: Text(
                      item['platillo'] ?? 'Platillo',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('📍 ${item['negocio'] ?? 'Negocio'}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${item['calificacionPromedio'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\$${item['precio'] ?? '0.00'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}