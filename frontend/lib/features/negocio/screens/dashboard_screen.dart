// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/dashboard_controller.dart';
import 'menu_gestion_screen.dart';
import 'disponibilidad_screen.dart';
import 'estadisticas_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _controller.cargarDashboard();
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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _controller.cargarDashboard,
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.negocio == null
                  ? _buildSinNegocio(primaryColor)
                  : _buildContent(primaryColor),
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
            onPressed: _controller.cargarDashboard,
          ),
        ],
      ),
    );
  }

  Widget _buildSinNegocio(Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No tienes un negocio registrado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Contacta al administrador para registrar tu negocio.',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Color primaryColor) {
    final negocio = _controller.negocio!;
    final stats = _controller.estadisticas;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nuevasResenas = _controller.nuevasResenas;

    return RefreshIndicator(
      onRefresh: _controller.cargarDashboard,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner de nuevas reseñas (notificación in-app)
          if (nuevasResenas > 0)
            GestureDetector(
              onTap: _controller.marcarResenasVistas,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tienes $nuevasResenas nueva${nuevasResenas == 1 ? '' : 's'} calificación${nuevasResenas == 1 ? '' : 'es'} recibida${nuevasResenas == 1 ? '' : 's'} ⭐',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.close, size: 18, color: Colors.amber),
                  ],
                ),
              ),
            ),

          // Info del negocio
          Card(
            color: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    child: Icon(Icons.storefront, size: 32, color: primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          negocio['nombre'] ?? '',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        if (negocio['categoria'] != null)
                          Text(negocio['categoria'], style: TextStyle(color: Colors.grey[600])),
                        if (negocio['direccion'] != null)
                          Text(
                            negocio['direccion'],
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Estadísticas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 8),

          // Tarjetas de estadísticas
          if (stats != null) ...[
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  icon: Icons.visibility,
                  color: Colors.blue,
                  label: 'Vistas',
                  value: '${stats['totalVistas'] ?? 0}',
                  isDark: isDark,
                ),
                _buildStatCard(
                  icon: Icons.favorite,
                  color: Colors.red,
                  label: 'Favoritos',
                  value: '${stats['totalFavoritos'] ?? 0}',
                  isDark: isDark,
                ),
                _buildStatCard(
                  icon: Icons.star,
                  color: Colors.amber,
                  label: 'Reseñas',
                  value: '${stats['totalResenas'] ?? 0}',
                  isDark: isDark,
                ),
                _buildStatCard(
                  icon: Icons.star_half,
                  color: Colors.orange,
                  label: 'Calif. Prom.',
                  value: '${stats['promedioCalificacion'] ?? '0.00'}⭐',
                  isDark: isDark,
                ),
              ],
            ),
          ] else
            Card(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Sin estadísticas disponibles')),
              ),
            ),

          const SizedBox(height: 24),

          // Botones de acción
          Text(
            'Herramientas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Gestionar Menú'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuGestionScreen()),
              ).then((_) => _controller.cargarDashboard());
            },
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            icon: const Icon(Icons.today),
            label: const Text('Gestión de Disponibilidad'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DisponibilidadScreen()),
              ).then((_) => _controller.cargarDashboard());
            },
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            icon: const Icon(Icons.bar_chart),
            label: const Text('Ver Estadísticas Detalladas'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EstadisticasScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
