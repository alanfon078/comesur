// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/favoritos_controller.dart';
import '../../negocio/screens/business_detail_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final FavoritosController _controller = FavoritosController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _controller.cargarFavoritos();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _controller.cargarFavoritos,
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.favoritos.isEmpty
                  ? _buildEmptyState(context)
                  : _buildLista(context, isDark, primaryColor),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_controller.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              onPressed: _controller.cargarFavoritos,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Aún no tienes favoritos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega negocios a tus favoritos tocando el ícono de corazón.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLista(BuildContext context, bool isDark, Color primaryColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _controller.favoritos.length,
      itemBuilder: (context, i) {
        final fav = _controller.favoritos[i];
        return Card(
          color: isDark ? Colors.grey[900] : Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BusinessDetailScreen(
                    negocioId: fav['negocio_id'] as int,
                    negocioNombre: fav['nombre'] ?? 'Negocio',
                  ),
                ),
              ).then((_) => _controller.cargarFavoritos());
            },
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.15),
                child: Icon(Icons.store, color: primaryColor),
              ),
              title: Text(
                fav['nombre'] ?? 'Negocio',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (fav['categoria'] != null) ...[
                    const SizedBox(height: 4),
                    Text('🍽️ ${fav['categoria']}'),
                  ],
                  if (fav['calificacionPromedio'] != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${fav['calificacionPromedio']}'),
                      ],
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                tooltip: 'Quitar de favoritos',
                onPressed: () async {
                  final ok = await _controller.eliminarFavorito(fav['negocio_id'] as int);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(ok ? 'Quitado de favoritos' : 'No se pudo eliminar'),
                      duration: const Duration(seconds: 2),
                    ));
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
