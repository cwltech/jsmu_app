import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final String title;
  final String subtitle;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  final String? errorMessage;

  const LocationResult({
    required this.title,
    required this.subtitle,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.errorMessage,
  });
}

class LocationService {
  LocationService._();

  static const String defaultTitle = 'Gurgaon • DLF Phase 4';
  static const String defaultSubtitle = 'Sector 28, Galleria Market nearby';

  static Future<LocationResult> getCurrentLocation({bool askPermission = true}) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult(
          title: defaultTitle,
          subtitle: defaultSubtitle,
          isDefault: true,
          errorMessage: 'Location services are disabled on this device.',
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && askPermission) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const LocationResult(
          title: defaultTitle,
          subtitle: defaultSubtitle,
          isDefault: true,
          errorMessage: 'Location permission was denied.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(
          title: defaultTitle,
          subtitle: defaultSubtitle,
          isDefault: true,
          errorMessage:
              'Location permissions are permanently denied. Please enable them in app settings.',
        );
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        return const LocationResult(
          title: defaultTitle,
          subtitle: defaultSubtitle,
          isDefault: true,
          errorMessage: 'Unable to acquire current position.',
        );
      }

      try {
        final geocoding = Geocoding();
        List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city = (place.locality != null && place.locality!.isNotEmpty)
              ? place.locality!
              : (place.subAdministrativeArea != null &&
                      place.subAdministrativeArea!.isNotEmpty)
                  ? place.subAdministrativeArea!
                  : 'Current Area';

          final area = (place.subLocality != null &&
                  place.subLocality!.isNotEmpty)
              ? place.subLocality!
              : (place.thoroughfare != null &&
                      place.thoroughfare!.isNotEmpty)
                  ? place.thoroughfare!
                  : (place.name != null && place.name!.isNotEmpty)
                      ? place.name!
                      : 'Nearby';

          final street = (place.street != null && place.street!.isNotEmpty)
              ? place.street!
              : '';
          final postCode = (place.postalCode != null &&
                  place.postalCode!.isNotEmpty)
              ? ' • ${place.postalCode}'
              : '';

          final title = '$city • $area';
          final subtitle = street.isNotEmpty
              ? '$street$postCode'
              : '$area, nearby';

          return LocationResult(
            title: title,
            subtitle: subtitle,
            latitude: position.latitude,
            longitude: position.longitude,
            isDefault: false,
          );
        }
      } catch (geocodeError) {
        debugPrint('Geocoding error: $geocodeError');
      }

      return LocationResult(
        title: 'Current Location',
        subtitle:
            'Lat: ${position.latitude.toStringAsFixed(3)}, Lng: ${position.longitude.toStringAsFixed(3)}',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return LocationResult(
        title: defaultTitle,
        subtitle: defaultSubtitle,
        isDefault: true,
        errorMessage: e.toString(),
      );
    }
  }
}
