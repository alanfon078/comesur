// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import '../logic/resena_controller.dart';

/// Muestra un bottom sheet para calificar un negocio.
/// Retorna `true` si la reseña fue guardada exitosamente.
Future<bool> mostrarRatingBottomSheet({
  required BuildContext context,
  required int negocioId,
  required String negocioNombre,
  int? calificacionInicial,
  String? comentarioInicial,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _RatingBottomSheet(
      negocioId: negocioId,
      negocioNombre: negocioNombre,
      calificacionInicial: calificacionInicial,
      comentarioInicial: comentarioInicial,
    ),
  );
  return result ?? false;
}

class _RatingBottomSheet extends StatefulWidget {
  final int negocioId;
  final String negocioNombre;
  final int? calificacionInicial;
  final String? comentarioInicial;

  const _RatingBottomSheet({
    required this.negocioId,
    required this.negocioNombre,
    this.calificacionInicial,
    this.comentarioInicial,
  });

  @override
  State<_RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<_RatingBottomSheet> {
  late int _calificacion;
  late TextEditingController _comentarioCtrl;
  final ResenaController _controller = ResenaController();

  @override
  void initState() {
    super.initState();
    _calificacion = widget.calificacionInicial ?? 0;
    _comentarioCtrl = TextEditingController(text: widget.comentarioInicial ?? '');
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _comentarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (_calificacion == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una calificación')),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar calificación'),
        content: Text(
          'Vas a enviar $_calificacion estrella${_calificacion > 1 ? 's' : ''} para ${widget.negocioNombre}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final ok = await _controller.guardarResena(
      negocioId: widget.negocioId,
      calificacion: _calificacion,
      comentario: _comentarioCtrl.text.trim(),
    );

    if (mounted) {
      if (ok) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.error ?? 'Error al guardar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Calificar ${widget.negocioNombre}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'Tu calificación',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Estrellas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => _calificacion = i + 1),
                child: Icon(
                  i < _calificacion ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 44,
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              _calificacion == 0
                  ? 'Toca para calificar'
                  : _calificacionTexto(_calificacion),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),

          // Comentario
          const Text(
            'Comentario (opcional)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comentarioCtrl,
            maxLines: 3,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: '¿Cómo fue tu experiencia?',
              filled: true,
              fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Error
          if (_controller.error != null) ...[
            Text(
              _controller.error!,
              style: TextStyle(color: Colors.red[700], fontSize: 13),
            ),
            const SizedBox(height: 8),
          ],

          // Botón Enviar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _controller.isLoading ? null : _enviar,
              child: _controller.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      widget.calificacionInicial != null ? 'Actualizar reseña' : 'Enviar reseña',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _calificacionTexto(int cal) {
    switch (cal) {
      case 1:
        return 'Muy malo 😞';
      case 2:
        return 'Malo 😕';
      case 3:
        return 'Regular 😐';
      case 4:
        return 'Bueno 😊';
      case 5:
        return 'Excelente 🤩';
      default:
        return '';
    }
  }
}
