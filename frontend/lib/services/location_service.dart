import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Solicita permisos de ubicación y obtiene la posición actual del usuario.
  /// Retorna null si los permisos son denegados o si ocurre un error.
  static Future<Position?> obtenerPosicionActual() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    // Verificar si el servicio de ubicación está habilitado
    try {
      servicioHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicioHabilitado) {
        return null;
      }
    } catch (_) {
      return null;
    }

    try {
      permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) {
          return null;
        }
      }

      if (permiso == LocationPermission.deniedForever) {
        return null;
      }

      // Intentar obtener una posición rápida con timeout
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 4),
      );
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (_) {
      try {
        // Fallback a la última ubicación conocida si expira el tiempo
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  /// Calcula la distancia entre el usuario y las coordenadas de un negocio.
  /// Retorna un string formateado (ej. "A ~1.2 km de tu ubicación") o null si no se puede calcular.
  static Future<String?> calcularDistanciaFormateada(double negocioLat, double negocioLng) async {
    final posicionUsuario = await obtenerPosicionActual();
    if (posicionUsuario == null) return null;

    try {
      final distanciaMetros = Geolocator.distanceBetween(
        posicionUsuario.latitude,
        posicionUsuario.longitude,
        negocioLat,
        negocioLng,
      );

      if (distanciaMetros < 1000) {
        return 'A ~${distanciaMetros.toStringAsFixed(0)} m de tu ubicación';
      } else {
        final distanciaKm = distanciaMetros / 1000;
        return 'A ~${distanciaKm.toStringAsFixed(1)} km de tu ubicación';
      }
    } catch (_) {
      return null;
    }
  }
}
