// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/disponibilidad_controller.dart';

class DisponibilidadScreen extends StatefulWidget {
  const DisponibilidadScreen({super.key});

  @override
  State<DisponibilidadScreen> createState() => _DisponibilidadScreenState();
}

class _DisponibilidadScreenState extends State<DisponibilidadScreen> {
  final DisponibilidadController _controller = DisponibilidadController();

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

  // Parsea "HH:MM:SS" o "HH:MM" a TimeOfDay
  TimeOfDay? _parseTime(String? t) {
    if (t == null || t.isEmpty) return null;
    final parts = t.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _editarHorario() async {
    final primaryColor = Theme.of(context).primaryColor;
    final aperturaInicial = _parseTime(_controller.horarioApertura);
    final cierreInicial = _parseTime(_controller.horarioCierre);

    TimeOfDay? apertura = aperturaInicial ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay? cierre = cierreInicial ?? const TimeOfDay(hour: 22, minute: 0);

    // Selector de apertura
    final pickedApertura = await showTimePicker(
      context: context,
      initialTime: apertura,
      helpText: 'Horario de apertura',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;
    if (pickedApertura != null) apertura = pickedApertura;

    // Selector de cierre
    final pickedCierre = await showTimePicker(
      context: context,
      initialTime: cierre,
      helpText: 'Horario de cierre',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;
    if (pickedCierre != null) cierre = pickedCierre;

    final exito = await _controller.guardarHorario(
      _formatTime(apertura),
      _formatTime(cierre),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exito ? 'Horario guardado correctamente' : (_controller.error ?? 'Error al guardar')),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _guardarMenuDelDia() async {
    final exito = await _controller.guardarMenuDelDia();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exito ? 'Menú del día guardado' : (_controller.error ?? 'Error al guardar')),
        backgroundColor: exito ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Disponibilidad', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _controller.cargar,
          ),
        ],
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.negocioId == null
                  ? _buildSinNegocio()
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- Horario ---
        Card(
          color: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Horario de atención',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Apertura', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          Text(
                            _controller.horarioApertura?.substring(0, 5) ?? '--:--',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.grey[400]),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Cierre', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          Text(
                            _controller.horarioCierre?.substring(0, 5) ?? '--:--',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar horario'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                    ),
                    onPressed: _controller.isSaving ? null : _editarHorario,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // --- Menú del Día ---
        Row(
          children: [
            Icon(Icons.today, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              'Menú del Día',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Selecciona los platillos que estarán disponibles hoy.',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 8),

        if (_controller.productos.isEmpty)
          Card(
            color: isDark ? Colors.grey[900] : Colors.grey[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No hay platillos en el menú aún.')),
            ),
          )
        else
          Card(
            color: isDark ? Colors.grey[900] : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: _controller.productos.map((p) {
                final id = p['id'] as int;
                final enMenu = _controller.menuDelDia.contains(id);
                final precio = (p['precio'] as num?)?.toDouble() ?? 0.0;
                return CheckboxListTile(
                  value: enMenu,
                  activeColor: primaryColor,
                  title: Text(p['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('\$${precio.toStringAsFixed(2)} MXN'),
                  secondary: Icon(
                    Icons.restaurant_menu,
                    color: enMenu ? primaryColor : Colors.grey[400],
                  ),
                  onChanged: (_) => _controller.toggleMenuDelDia(id),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 16),

        ElevatedButton.icon(
          icon: _controller.isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.save),
          label: Text(_controller.isSaving ? 'Guardando...' : 'Guardar menú del día'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: _controller.isSaving ? null : _guardarMenuDelDia,
        ),

        const SizedBox(height: 8),
        Center(
          child: Text(
            '${_controller.menuDelDia.length} platillo(s) seleccionado(s) para hoy',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
      ],
    );
  }
}
