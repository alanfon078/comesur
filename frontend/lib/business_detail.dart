// Autor: Janetzy Maldonado
// Proyecto: COMESUR
// Módulo: Detalle de Negocio
// Descripción: Implementación de pantalla con diseño moderno, integración de API REST, manejo de estados y UI responsiva.

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BusinessDetail extends StatefulWidget {
  final int id;

  const BusinessDetail({super.key, required this.id});

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail> {
  late Future<Map<String, dynamic>> negocio;
  bool isFavorite = false;

  Future<Map<String, dynamic>> fetchNegocio() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/negocios/${widget.id}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar el negocio');
    }
  }

  @override
  void initState() {
    super.initState();
    negocio = fetchNegocio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: negocio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingScreen();
          } else if (snapshot.hasError) {
            return const _ErrorScreen();
          } else {
            final data = snapshot.data!;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(data['nombre'] ?? ''),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          data['imagen'] ?? '',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    )
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        _infoCard(
                          title: "Categoría",
                          value: data['categoria'] ?? '',
                          icon: Icons.restaurant,
                        ),

                        _infoCard(
                          title: "Dirección",
                          value: data['direccion'] ?? '',
                          icon: Icons.location_on,
                        ),

                        _infoCard(
                          title: "Horario",
                          value: data['horario'] ?? '',
                          icon: Icons.access_time,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Reseñas",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _reviewItem("Muy buena comida 🔥", 5),
                        _reviewItem("Buen servicio 👍", 4),
                        _reviewItem("Podría mejorar 😅", 3),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _infoCard({required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _reviewItem(String text, int stars) {
    return Card(
      child: ListTile(
        title: Text(text),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            stars,
            (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
          ),
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error al cargar el negocio 😢"),
    );
  }
}
