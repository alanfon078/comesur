// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/estadisticas_controller.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  final EstadisticasController _controller = EstadisticasController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _controller.cargar();
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

  Future<void> _exportar() async {
    await _controller.exportarReporte();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reporte copiado al portapapeles ✓'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _controller.cargar,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Exportar reporte',
            onPressed: _controller.datos != null ? _exportar : null,
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.negocioId == null
                  ? _buildSinNegocio()
                  : _controller.datos == null
                      ? const Center(child: Text('Sin datos disponibles'))
                      : _buildContent(primaryColor, isDark),
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
            onPressed: _controller.cargar,
          ),
        ],
      ),
    );
  }

  Widget _buildSinNegocio() {
    return const Center(
      child: Text('No tienes un negocio registrado.', textAlign: TextAlign.center),
    );
  }

  Widget _buildContent(Color primaryColor, bool isDark) {
    final datos = _controller.datos!;
    final distribucion = _controller.distribucion;
    final tendencia = _controller.tendencia;
    final totalResenas = _controller.totalResenas;

    return RefreshIndicator(
      onRefresh: _controller.cargar,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Resumen general ---
          Text(
            'Resumen general',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _buildStatCard(
                icon: Icons.visibility,
                color: Colors.blue,
                label: 'Vistas',
                value: '${datos['totalVistas'] ?? 0}',
                isDark: isDark,
              ),
              _buildStatCard(
                icon: Icons.favorite,
                color: Colors.red,
                label: 'Favoritos',
                value: '${datos['totalFavoritos'] ?? 0}',
                isDark: isDark,
              ),
              _buildStatCard(
                icon: Icons.star,
                color: Colors.amber,
                label: 'Reseñas',
                value: '$totalResenas',
                isDark: isDark,
              ),
              _buildStatCard(
                icon: Icons.star_half,
                color: Colors.orange,
                label: 'Calif. Prom.',
                value: '${datos['promedioCalificacion'] ?? '0.00'}⭐',
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // --- Distribución de calificaciones ---
          Text(
            'Distribución de calificaciones',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 12),
          Card(
            color: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(5, (i) {
                  final estrellas = 5 - i;
                  final cantidad = distribucion[estrellas] ?? 0;
                  final porcentaje = totalResenas > 0 ? cantidad / totalResenas : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        // Etiqueta de estrellas
                        SizedBox(
                          width: 28,
                          child: Text(
                            '$estrellas',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 8),
                        // Barra de progreso
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: porcentaje,
                              minHeight: 12,
                              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                estrellas >= 4
                                    ? Colors.green
                                    : estrellas == 3
                                        ? Colors.amber
                                        : Colors.red,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Cantidad
                        SizedBox(
                          width: 30,
                          child: Text(
                            '$cantidad',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // --- Tendencia mensual ---
          Text(
            'Tendencia de calificaciones (últimos 6 meses)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 12),

          if (tendencia.isEmpty)
            Card(
              color: isDark ? Colors.grey[900] : Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('No hay reseñas en los últimos 6 meses.')),
              ),
            )
          else
            Card(
              color: isDark ? Colors.grey[900] : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  // Encabezado
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Periodo',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 12)),
                        ),
                        Expanded(
                          child: Text('Reseñas',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 12),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('Promedio',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 12),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ...tendencia.asMap().entries.map((entry) {
                    final t = entry.value;
                    final promedio = double.tryParse('${t['promedio']}') ?? 0.0;
                    final isLast = entry.key == tendencia.length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${t['periodo']}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${t['resenas']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 14),
                                    const SizedBox(width: 2),
                                    Text(
                                      promedio.toStringAsFixed(1),
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) const Divider(height: 1),
                      ],
                    );
                  }),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // --- Exportar ---
          OutlinedButton.icon(
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Exportar reporte (copiar al portapapeles)'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _exportar,
          ),

          const SizedBox(height: 8),
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
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
