import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();

  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final RxString _currentAddress = ''.obs;
  final RxBool _isLocationEnabled = false.obs;
  final RxBool _isLoading = false.obs;

  final Distance _distance = const Distance();

  // Getters
  Position? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;
  bool get isLocationEnabled => _isLocationEnabled.value;
  bool get isLoading => _isLoading.value;

  LatLng? get currentLatLng => _currentPosition.value != null
      ? LatLng(
          _currentPosition.value!.latitude,
          _currentPosition.value!.longitude,
        )
      : null;

  @override
  void onInit() {
    super.onInit();
    _checkLocationServiceStatus();
  }

  // Request location permission
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          LocationFailure('Location services are disabled. Please enable GPS.'),
        );
      }

      // Check current permission
      LocationPermission permission = await Geolocator.checkPermission();

      // Request permission if denied
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied) {
          return const Left(
            LocationFailure(
              'Location permission denied. Please allow location access.',
            ),
          );
        }
      }

      // Check if permanently denied
      if (permission == LocationPermission.deniedForever) {
        return const Left(
          LocationFailure(
            'Location permission permanently denied. Please enable in app settings.',
          ),
        );
      }

      _isLocationEnabled.value = true;
      return const Right(true);
    } catch (e) {
      return Left(
        LocationFailure('Error requesting permission: ${e.toString()}'),
      );
    }
  }

  // Get current location
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      _isLoading.value = true;

      // Check permission first
      final permissionResult = await requestLocationPermission();
      if (permissionResult.isLeft()) {
        return permissionResult.fold(
          (failure) => Left(failure),
          (success) => const Left(LocationFailure('Permission failed')),
        );
      }

      // Get position with timeout
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      // Await the position with the new settings.
      // The built-in timeout will now throw the exception.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      _currentPosition.value = position;
      _getAddressFromCoordinates(position.latitude, position.longitude);

      return Right(position);
    } on LocationServiceDisabledException {
      return const Left(
        LocationFailure('Location services disabled. Please enable GPS.'),
      );
    } on PermissionDeniedException {
      return const Left(LocationFailure('Location permission denied.'));
    } catch (e) {
      if (e.toString().contains('timed out')) {
        return const Left(
          LocationFailure('Location request timed out. Please try again.'),
        );
      }
      return Left(LocationFailure('Failed to get location: ${e.toString()}'));
    } finally {
      _isLoading.value = false;
    }
  }

  // Get address from coordinates
  void _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAddress.value =
            '${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
      }
    } catch (e) {
      _currentAddress.value = 'Location found';
    }
  }

  // Calculate distance between two points
  double calculateDistanceLatLng(LatLng point1, LatLng point2) {
    return _distance.as(LengthUnit.Meter, point1, point2);
  }

  // Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  // Check location service status
  void _checkLocationServiceStatus() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      _isLocationEnabled.value =
          serviceEnabled &&
          (permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse);
    } catch (e) {
      _isLocationEnabled.value = false;
    }
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  // Check if should request permission
  Future<bool> shouldRequestPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.denied;
  }

  // Check if permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.deniedForever;
  }
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}
