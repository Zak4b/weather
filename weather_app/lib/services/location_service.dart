import 'package:geolocator/geolocator.dart';

/// Erreur prévisible lors de la récupération de la position (services, permissions, GPS).
class LocationException implements Exception {
  const LocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Obtient la position GPS actuelle après vérification des services et des permissions.
/// Lance [LocationException] si la position ne peut pas être obtenue.
Future<Position> fetchGpsPosition() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw const LocationException('Location services are disabled.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw const LocationException('Location permission denied.');
  }

  if (permission == LocationPermission.deniedForever) {
    throw const LocationException(
      'Location permission denied permanently. Enable it in system settings.',
    );
  }

  try {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  } catch (e) {
    throw LocationException('Could not get GPS position: $e');
  }
}

String formatGpsCoordinates(Position position) {
  final lat = position.latitude.toStringAsFixed(6);
  final lon = position.longitude.toStringAsFixed(6);
  return '$lat, $lon';
}
