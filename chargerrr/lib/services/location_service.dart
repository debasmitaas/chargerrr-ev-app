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
  
  // Distance calculator
  final Distance _distance = const Distance();
  
  // Getters
  Position? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;
  bool get isLocationEnabled => _isLocationEnabled.value;
  LatLng? get currentLatLng => _currentPosition.value != null 
    ? LatLng(_currentPosition.value!.latitude, _currentPosition.value!.longitude)
    : null;
  
  // Reactive getters
  Rx<Position?> get currentPositionStream => _currentPosition;
  RxString get currentAddressStream => _currentAddress;
  
  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
  }
  
  // Check and request location permissions
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(LocationFailure('Location services are disabled. Please enable location in settings.'));
      }
      
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(LocationFailure('Location permission denied. Please allow location access.'));
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return const Left(LocationFailure('Location permission permanently denied. Please enable in app settings.'));
      }
      
      _isLocationEnabled.value = true;
      return const Right(true);
    } catch (e) {
      return Left(LocationFailure('Error requesting location permission: ${e.toString()}'));
    }
  }
  
  // Get current location
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final permissionResult = await requestLocationPermission();
      if (permissionResult.isLeft()) {
        return Left(permissionResult.fold((l) => l, (r) => const LocationFailure('Permission error')));
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      _currentPosition.value = position;
      
      // Get address from coordinates
      await _getAddressFromCoordinates(position.latitude, position.longitude);
      
      return Right(position);
    } catch (e) {
      return Left(LocationFailure('Error getting location: ${e.toString()}'));
    }
  }
  
  // Get address from coordinates
  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAddress.value = '${place.street}, ${place.locality}, ${place.administrativeArea}';
      }
    } catch (e) {
      print('Error getting address: $e');
      _currentAddress.value = 'Location found';
    }
  }
  
  // Calculate distance between two LatLng points
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
  
  // Check location permission on init
  void _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    _isLocationEnabled.value = permission == LocationPermission.always || 
                               permission == LocationPermission.whileInUse;
  }
  
  // Open app settings
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}