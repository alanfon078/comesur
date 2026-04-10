// Autor: Janetzy Maldonado Nava
// Proyecto: COMESUR
// Módulo: Detalle de Negocio
// Descripción: Pantalla premium con animaciones, favoritos persistentes,
// manejo de errores, estados vacíos y UI moderna tipo app profesional.

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BusinessDetail extends StatefulWidget {
  final int id;

  const BusinessDetail({super.key, required this.id});

  @override
  State<BusinessDetail> createState() => _BusinessDetailState();
}

class _BusinessDetailState extends State<BusinessDetail>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> negocio;
  bool isFavorite = false;

  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    negocio = fetchNegocio();
    loadFavorite();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<Map<String, dynamic>> fetchNegocio() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/negocios/${widget.id}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error');
    }
  }

  Future<void> loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('fav_${widget.id}') ?? false;
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = !isFavorite;
    });
    prefs.setBool('fav_${widget.id}', isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: negocio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingScreen();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 80, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text("Error de conexión 😢"),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        negocio = fetchNegocio();
                      });
                    },
                    child: const Text("Reintentar"),
                  )
                ],
              ),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No hay información disponible 😢"),
                ],
              ),
            );
          }

          return FadeTransition(
            opacity: _fade,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
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
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          key: ValueKey(isFavorite),
                          color: Colors.red,
                        ),
                      ),
                      onPressed: toggleFavorite,
                    )
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _card("Categoría", data['categoria'] ?? '', Icons.restaurant),
                        _card("Dirección", data['direccion'] ?? '', Icons.location_on),
                        _card("Horario", data['horario'] ?? '', Icons.access_time),

                        const SizedBox(height: 20),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reseñas",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 10),

                        _review("Excelente lugar 🔥", 5),
                        _review("Muy buen servicio 👍", 4),
                        _review("Normal 😅", 3),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(String title, String value, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.green, size: 30),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }

  Widget _review(String text, int stars) {
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
