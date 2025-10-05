import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();

  final Rxn<LatLng> _currentLocation = Rxn<LatLng>();
  final RxBool isLoading = false.obs;

  LatLng? get currentLatLng => _currentLocation.value;

  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      isLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool opened = await Geolocator.openLocationSettings();
        if (!opened) {
          return const Left(LocationFailure('Location services are disabled. Please enable GPS.'));
        }
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          return const Left(LocationFailure('Location services still disabled.'));
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(LocationFailure('Location permission denied by user.'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(LocationFailure('Location permission permanently denied. Please enable in app settings.'));
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
        forceAndroidLocationManager: true,
      );

      _currentLocation.value = LatLng(position.latitude, position.longitude);
      
      return Right(position);

    } catch (e) {
      return Left(LocationFailure('Unable to get location: ${e.toString()}'));
    } finally {
      isLoading.value = false;
    }
  }

  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()}m';
    }
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }

  Future<bool> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || 
           permission == LocationPermission.whileInUse;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  void clearLocation() {
    _currentLocation.value = null;
  }
}

class LocationFailure extends Failure {
  const LocationFailure(String message) : super(message);
}