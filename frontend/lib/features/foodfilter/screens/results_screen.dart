// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../negocio/screens/business_detail_screen.dart';
import '../../favoritos/logic/favoritos_controller.dart';

class ResultsScreen extends StatefulWidget {
  final List<dynamic> resultados;
  final bool isLoading;

  const ResultsScreen({
    super.key,
    required this.resultados,
    this.isLoading = false,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final FavoritosController _favoritosController = FavoritosController();
  final Set<int> _favoritos = {};
  final Set<int> _loadingFavoritos = {};

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    await _favoritosController.cargarFavoritos();
    if (mounted) {
      setState(() {
        _favoritos.clear();
        for (final f in _favoritosController.favoritos) {
          // CORRECCIÓN: Parseo seguro en caso de que el ID venga como String
          final dynamic idRaw = f['negocio_id'];
          final int? id = idRaw is int ? idRaw : int.tryParse(idRaw?.toString() ?? '');
          if (id != null) {
            _favoritos.add(id);
          }
        }
      });
    }
  }

  Future<void> _toggleFavorito(int negocioId) async {
    if (_loadingFavoritos.contains(negocioId)) return;

    setState(() => _loadingFavoritos.add(negocioId));

    bool ok;
    bool ahora;
    if (_favoritos.contains(negocioId)) {
      ok = await _favoritosController.eliminarFavorito(negocioId);
      ahora = false;
    } else {
      ok = await _favoritosController.agregarFavorito(negocioId);
      ahora = true;
    }

    // CORRECCIÓN: Evitar problemas al usar el contexto tras un 'await'
    if (!mounted) return;

    setState(() {
      _loadingFavoritos.remove(negocioId);
      if (ok) {
        if (ahora) {
          _favoritos.add(negocioId);
        } else {
          _favoritos.remove(negocioId);
        }
      }
    });

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ahora ? 'Agregado a favoritos' : 'Quitado de favoritos'),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  @override
  void dispose() {
    _favoritosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: widget.isLoading
          ? _buildSkeletonList(isDark)
          : widget.resultados.isEmpty
          ? _buildEmptyState(context)
          : _buildResultList(context, isDark),
    );
  }

  Widget _buildSkeletonList(bool isDark) {
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 14, width: double.infinity, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 150, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(height: 12, width: 80, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            ElevatedButton.icon(
              icon: const Icon(Icons.tune),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              label: const Text('Modificar Filtros'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultList(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: widget.resultados.length,
      itemBuilder: (context, index) {
        final item = widget.resultados[index];

        // CORRECCIÓN: Parseo seguro para el ID del negocio también aquí
        final dynamic idRaw = item['negocio_id'];
        final int? negocioId = idRaw is int ? idRaw : int.tryParse(idRaw?.toString() ?? '');

        final esFavorito = negocioId != null && _favoritos.contains(negocioId);
        final cargandoFav = negocioId != null && _loadingFavoritos.contains(negocioId);

        return Card(
          color: isDark ? Colors.grey[900] : Colors.white,
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (negocioId != null) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BusinessDetailScreen(
                          negocioId: negocioId,
                          negocioNombre: item['negocio'] ?? 'Negocio',
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                ).then((_) => _cargarFavoritos());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['platillo'] ?? 'Platillo',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text('📍 ${item['negocio'] ?? 'Negocio'}'),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${item['calificacionPromedio'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${item['precio'] ?? '0.00'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (negocioId != null)
                        cargandoFav
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : GestureDetector(
                          onTap: () => _toggleFavorito(negocioId),
                          child: Icon(
                            esFavorito ? Icons.favorite : Icons.favorite_border,
                            color: esFavorito ? Colors.red : Colors.grey,
                            size: 22,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}