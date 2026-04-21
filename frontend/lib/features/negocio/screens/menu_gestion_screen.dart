// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart' hide MenuController;
import '../logic/menu_controller.dart';
import 'business_detail_screen.dart';

class MenuGestionScreen extends StatefulWidget {
  const MenuGestionScreen({super.key});

  @override
  State<MenuGestionScreen> createState() => _MenuGestionScreenState();
}

class _MenuGestionScreenState extends State<MenuGestionScreen> {
  final MenuController _controller = MenuController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
    _controller.cargarMenu();
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

  // Muestra el diálogo para agregar o editar un platillo
  Future<void> _mostrarFormulario({Map<String, dynamic>? producto}) async {
    final nombreCtrl = TextEditingController(text: producto?['nombre'] ?? '');
    final descCtrl = TextEditingController(text: producto?['descripcion'] ?? '');
    final precioCtrl = TextEditingController(
      text: producto != null ? '${producto['precio']}' : '',
    );
    final formKey = GlobalKey<FormState>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(producto == null ? 'Agregar platillo' : 'Editar platillo'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: precioCtrl,
                  decoration: const InputDecoration(labelText: 'Precio (MXN) *'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'El precio es requerido';
                    final p = double.tryParse(v.trim());
                    if (p == null || p <= 0) return 'Ingresa un precio válido mayor a 0';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(producto == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    final precio = double.parse(precioCtrl.text.trim());
    bool exito;

    if (producto == null) {
      exito = await _controller.agregarProducto(
        nombre: nombreCtrl.text.trim(),
        descripcion: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
        precio: precio,
      );
    } else {
      exito = await _controller.actualizarProducto(
        productoId: producto['id'] as int,
        nombre: nombreCtrl.text.trim(),
        descripcion: descCtrl.text.trim().isNotEmpty ? descCtrl.text.trim() : null,
        precio: precio,
      );
    }

    if (!mounted) return;
    if (!exito && _controller.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error!), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _confirmarEliminar(Map<String, dynamic> producto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar platillo'),
        content: Text('¿Eliminar "${producto['nombre']}" del menú?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final exito = await _controller.eliminarProducto(producto['id'] as int);
      if (!exito && mounted && _controller.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.error!), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Menú', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          if (_controller.negocioId != null)
            IconButton(
              icon: const Icon(Icons.preview_outlined),
              tooltip: 'Vista previa',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BusinessDetailScreen(
                      negocioId: _controller.negocioId!,
                      negocioNombre: 'Vista previa',
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _controller.cargarMenu,
          ),
        ],
      ),
      floatingActionButton: _controller.negocioId != null
          ? FloatingActionButton.extended(
              onPressed: () => _mostrarFormulario(),
              icon: const Icon(Icons.add),
              label: const Text('Agregar platillo'),
              backgroundColor: primaryColor,
            )
          : null,
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.error != null
              ? _buildError()
              : _controller.negocioId == null
                  ? _buildSinNegocio()
                  : _controller.productos.isEmpty
                      ? _buildEmptyState(primaryColor)
                      : _buildLista(isDark, primaryColor),
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
            onPressed: _controller.cargarMenu,
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

  Widget _buildEmptyState(Color primaryColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Tu menú está vacío',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega platillos para que tus clientes los puedan ver.',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Agregar platillo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () => _mostrarFormulario(),
          ),
        ],
      ),
    );
  }

  Widget _buildLista(bool isDark, Color primaryColor) {
    return RefreshIndicator(
      onRefresh: _controller.cargarMenu,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        itemCount: _controller.productos.length,
        itemBuilder: (context, index) {
          final p = _controller.productos[index];
          final disponible = p['disponible'] == true || p['disponible'] == 1;
          final precio = (p['precio'] as num?)?.toDouble() ?? 0.0;

          return Card(
            color: isDark ? Colors.grey[900] : Colors.white,
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Icono de disponibilidad
                  GestureDetector(
                    onTap: () => _controller.toggleDisponibilidad(p['id'] as int),
                    child: Tooltip(
                      message: disponible ? 'Disponible — toca para ocultar' : 'No disponible — toca para activar',
                      child: Icon(
                        disponible ? Icons.check_circle : Icons.cancel_outlined,
                        color: disponible ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['nombre'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: disponible ? null : Colors.grey,
                          ),
                        ),
                        if (p['descripcion'] != null && p['descripcion'].toString().isNotEmpty)
                          Text(
                            p['descripcion'],
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          '\$${precio.toStringAsFixed(2)} MXN',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Acciones
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Editar',
                    onPressed: () => _mostrarFormulario(producto: p),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Eliminar',
                    onPressed: () => _confirmarEliminar(p),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
