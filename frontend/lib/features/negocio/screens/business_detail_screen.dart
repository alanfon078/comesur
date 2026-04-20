// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/business_detail_controller.dart';
import '../../resenas/widgets/rating_bottom_sheet.dart';
import '../../resenas/logic/resena_controller.dart';

class BusinessDetailScreen extends StatefulWidget {
  final int negocioId;
  final String negocioNombre;

  const BusinessDetailScreen({
    super.key,
    required this.negocioId,
    required this.negocioNombre,
  });

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen> {
  final BusinessDetailController _controller = BusinessDetailController();
  final ResenaController _resenaController = ResenaController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
    _controller.cargarNegocio(widget.negocioId);
    _controller.verificarFavorito(widget.negocioId);
    _resenaController.cargarMiResena(widget.negocioId);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _resenaController.dispose();
    super.dispose();
  }

  Future<void> _abrirCalificacion() async {
    final resenaExistente = _resenaController.resenaExistente;
    final guardado = await mostrarRatingBottomSheet(
      context: context,
      negocioId: widget.negocioId,
      negocioNombre: widget.negocioNombre,
      calificacionInicial: resenaExistente?['calificacion'] as int?,
      comentarioInicial: resenaExistente?['comentario'] as String?,
    );
    if (guardado) {
      // Recargar negocio para ver nuevo promedio y reseñas
      await _controller.cargarNegocio(widget.negocioId);
      await _resenaController.cargarMiResena(widget.negocioId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Reseña guardada exitosamente!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: _controller.isLoading
          ? _buildSkeleton(isDark)
          : _controller.error != null
              ? _buildError(context)
              : _buildContent(context, isDark, primaryColor),
    );
  }

  // --- Skeleton Loader ---
  Widget _buildSkeleton(bool isDark) {
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    return Column(
      children: [
        Container(height: 220, color: shimmerBase),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _skeletonBox(shimmerBase, width: 200, height: 24),
                const SizedBox(height: 12),
                _skeletonBox(shimmerBase, width: 140, height: 16),
                const SizedBox(height: 24),
                _skeletonBox(shimmerBase, width: double.infinity, height: 16),
                const SizedBox(height: 8),
                _skeletonBox(shimmerBase, width: double.infinity, height: 16),
                const SizedBox(height: 8),
                _skeletonBox(shimmerBase, width: 180, height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _skeletonBox(Color color, {double? width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // --- Error State ---
  Widget _buildError(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.negocioNombre),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              if (_controller.errorCode != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Código: ${_controller.errorCode}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                onPressed: () => _controller.cargarNegocio(widget.negocioId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Main Content ---
  Widget _buildContent(BuildContext context, bool isDark, Color primaryColor) {
    final n = _controller.negocio!;
    final menu = (n['menu'] as List<dynamic>?) ?? [];
    final resenas = (n['resenas'] as List<dynamic>?) ?? [];
    final miResena = _resenaController.resenaExistente;

    return CustomScrollView(
      slivers: [
        // Banner con imagen y AppBar
        SliverAppBar(
          expandedHeight: 220.0,
          pinned: true,
          actions: [
            // Botón Favorito
            IconButton(
              icon: Icon(
                _controller.esFavorito ? Icons.favorite : Icons.favorite_border,
                color: _controller.esFavorito ? Colors.red : Colors.white,
              ),
              tooltip: _controller.esFavorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
              onPressed: () async {
                await _controller.toggleFavorito(widget.negocioId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _controller.esFavorito ? 'Agregado a favoritos' : 'Quitado de favoritos',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              n['nombre'] ?? widget.negocioNombre,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor.withOpacity(0.8), primaryColor],
                ),
              ),
              child: const Center(
                child: Icon(Icons.store, size: 80, color: Colors.white54),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calificación y categoría + Botón Calificar
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '${n['calificacionPromedio'] ?? 'N/A'}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    if (n['categoria'] != null)
                      Chip(
                        label: Text(n['categoria']),
                        backgroundColor: primaryColor.withOpacity(0.15),
                      ),
                    const Spacer(),
                    // Botón Calificar
                    OutlinedButton.icon(
                      icon: Icon(
                        miResena != null ? Icons.edit : Icons.star_border,
                        size: 16,
                        color: primaryColor,
                      ),
                      label: Text(
                        miResena != null ? 'Editar reseña' : 'Calificar',
                        style: TextStyle(color: primaryColor, fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: _abrirCalificacion,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Descripción
                if (n['descripcion'] != null && n['descripcion'].toString().isNotEmpty) ...[
                  Text(
                    n['descripcion'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Dirección y Horario
                _buildInfoRow(Icons.location_on, n['direccion'] ?? 'Dirección no disponible', primaryColor),
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.access_time,
                  _formatHorario(n['horarioApertura'], n['horarioCierre']),
                  primaryColor,
                ),
                const Divider(height: 32),

                // Menú completo
                Text(
                  'Menú',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),

                if (menu.isEmpty)
                  const Text('No hay platillos disponibles en este momento.')
                else
                  ...menu.map((platillo) => _buildMenuCard(platillo, isDark, primaryColor)),

                const Divider(height: 32),

                // Reseñas
                Row(
                  children: [
                    Text(
                      'Calificaciones y reseñas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${resenas.length} reseña${resenas.length != 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (resenas.isEmpty)
                  const Text('Aún no hay reseñas para este negocio.')
                else
                  ...resenas.map((r) => _buildResenaCard(r, isDark)),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  String _formatHorario(dynamic apertura, dynamic cierre) {
    if (apertura == null && cierre == null) return 'Horario no disponible';
    final aperturaStr = apertura?.toString().substring(0, 5) ?? '--:--';
    final cierreStr = cierre?.toString().substring(0, 5) ?? '--:--';
    return '$aperturaStr - $cierreStr';
  }

  Widget _buildMenuCard(Map<String, dynamic> platillo, bool isDark, Color primaryColor) {
    final disponible = platillo['disponible'] == true || platillo['disponible'] == 1;
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: ListTile(
        leading: Icon(
          Icons.restaurant_menu,
          color: disponible ? primaryColor : Colors.grey,
        ),
        title: Text(
          platillo['nombre'] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: disponible ? null : Colors.grey,
          ),
        ),
        subtitle: platillo['descripcion'] != null && platillo['descripcion'].toString().isNotEmpty
            ? Text(platillo['descripcion'], maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${platillo['precio'] ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: disponible ? primaryColor : Colors.grey,
              ),
            ),
            if (!disponible)
              const Text(
                'No disponible',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResenaCard(Map<String, dynamic> resena, bool isDark) {
    final calificacion = resena['calificacion'] as int? ?? 0;
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Text(
                    (resena['autor'] ?? '?')[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resena['autor'] ?? 'Anónimo',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatFecha(resena['fecha']),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < calificacion ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
            if (resena['comentario'] != null && resena['comentario'].toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(resena['comentario']),
            ],
          ],
        ),
      ),
    );
  }

  String _formatFecha(dynamic fecha) {
    if (fecha == null) return '';
    try {
      final dt = DateTime.parse(fecha.toString());
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return fecha.toString();
    }
  }
}
