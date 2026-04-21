// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/perfil_controller.dart';
import '../../../services/auth_service.dart';
import '../../negocio/screens/business_detail_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final PerfilController _controller = PerfilController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _controller.cargarPerfil();
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

  Future<void> _cerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      await AuthService.cerrarSesion();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.perfil == null
                  ? const SizedBox.shrink()
                  : _buildContent(context, isDark, primaryColor),
    );
  }

  Widget _buildError() {
    return Center(
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
            onPressed: _controller.cargarPerfil,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark, Color primaryColor) {
    final p = _controller.perfil!;
    final calificaciones = (p['calificaciones'] as List<dynamic>?) ?? [];
    final favoritos = (p['favoritos'] as List<dynamic>?) ?? [];

    return RefreshIndicator(
      onRefresh: _controller.cargarPerfil,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar y datos del usuario
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: primaryColor.withOpacity(0.15),
                  child: Text(
                    (p['nombre'] as String? ?? '?')[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  p['nombre'] ?? '',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  p['correo'] ?? '',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(p['rol'] ?? ''),
                  backgroundColor: primaryColor.withOpacity(0.15),
                  labelStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),

          // Favoritos
          _buildSeccionHeader(
            icon: Icons.favorite,
            titulo: 'Negocios Favoritos',
            conteo: favoritos.length,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 8),
          if (favoritos.isEmpty)
            _buildEmptyItem('Sin favoritos guardados')
          else
            ...favoritos.map((f) => _buildFavoritoTile(f, isDark, primaryColor)),

          const Divider(height: 32),

          // Historial de calificaciones
          _buildSeccionHeader(
            icon: Icons.star,
            titulo: 'Historial de Calificaciones',
            conteo: calificaciones.length,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: 8),
          if (calificaciones.isEmpty)
            _buildEmptyItem('Aún no has calificado ningún negocio')
          else
            ...calificaciones.map((c) => _buildCalificacionTile(c, isDark, primaryColor)),

          const SizedBox(height: 24),

          // Botón Cerrar sesión
          OutlinedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionHeader({
    required IconData icon,
    required String titulo,
    required int conteo,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const Spacer(),
        Text(
          '$conteo',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildEmptyItem(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(msg, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
    );
  }

  Widget _buildFavoritoTile(Map<String, dynamic> f, bool isDark, Color primaryColor) {
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(Icons.favorite, color: Colors.red[400]),
        title: Text(f['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: f['categoria'] != null ? Text(f['categoria']) : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BusinessDetailScreen(
                negocioId: f['negocio_id'] as int,
                negocioNombre: f['nombre'] ?? '',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalificacionTile(Map<String, dynamic> c, bool isDark, Color primaryColor) {
    final cal = c['calificacion'] as int? ?? 0;
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    c['negocio'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < cal ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (c['comentario'] != null && c['comentario'].toString().isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(c['comentario'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ],
            const SizedBox(height: 4),
            Text(
              _formatFecha(c['fecha']),
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
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
