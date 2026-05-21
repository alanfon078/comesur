// Autor: Alan Yael Fonseca Ruiz

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget de mini mapa que muestra la ubicación del negocio,
/// la distancia al usuario, y un botón para abrir Google Maps.
class LocationMapWidget extends StatefulWidget {
  final double latitud;
  final double longitud;
  final String direccion;
  final String negocioNombre;

  const LocationMapWidget({
    super.key,
    required this.latitud,
    required this.longitud,
    required this.direccion,
    required this.negocioNombre,
  });

  @override
  State<LocationMapWidget> createState() => _LocationMapWidgetState();
}

class _LocationMapWidgetState extends State<LocationMapWidget> {
  double? _distanciaKm;
  bool _cargandoUbicacion = true;
  String? _errorUbicacion;

  @override
  void initState() {
    super.initState();
    _calcularDistancia();
  }

  Future<void> _calcularDistancia() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _errorUbicacion = 'Servicio de ubicación deshabilitado';
            _cargandoUbicacion = false;
          });
        }
        return;
      }

      // Verificar y solicitar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _errorUbicacion = 'Permiso de ubicación denegado';
            _cargandoUbicacion = false;
          });
        }
        return;
      }

      // Obtener posición actual
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Calcular distancia
      final distanciaMetros = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.latitud,
        widget.longitud,
      );

      if (mounted) {
        setState(() {
          _distanciaKm = distanciaMetros / 1000;
          _cargandoUbicacion = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorUbicacion = 'No se pudo obtener la ubicación';
          _cargandoUbicacion = false;
        });
      }
    }
  }

  Future<void> _abrirGoogleMaps() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${widget.latitud},${widget.longitud}'
      '&destination_place_id=${Uri.encodeComponent(widget.negocioNombre)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDistancia(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final negocioLatLng = LatLng(widget.latitud, widget.longitud);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),

        // Título de sección
        Row(
          children: [
            Icon(Icons.map_outlined, color: primaryColor, size: 22),
            const SizedBox(width: 8),
            Text(
              'Ubicación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Mini mapa
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: IgnorePointer(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: negocioLatLng,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.ComeSUR',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: negocioLatLng,
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red[700],
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Tarjeta de información de distancia
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              // Dirección
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.direccion,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Distancia
              Row(
                children: [
                  Icon(Icons.straighten, size: 18, color: primaryColor),
                  const SizedBox(width: 8),
                  _cargandoUbicacion
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : _errorUbicacion != null
                          ? Text(
                              _errorUbicacion!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            )
                          : Text(
                              'A ${_formatDistancia(_distanciaKm!)} de tu ubicación',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                ],
              ),
              const SizedBox(height: 12),

              // Botón "Cómo llegar"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Cómo llegar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _abrirGoogleMaps,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
