 
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:chargerrr/services/location_service.dart';

void main() {
  group('LocationService', () {
    late LocationService locationService;

    setUp(() {
      Get.testMode = true;
      locationService = LocationService();
    });

    tearDown(() {
      Get.reset();
    });

    test('should calculate distance between two points', () {
      const point1 = LatLng(28.6139, 77.2090); // Delhi
      const point2 = LatLng(28.6142, 77.2094); // Very close point
      
      final distance = locationService.calculateDistance(point1, point2);
      
      expect(distance, isA<double>());
      expect(distance, greaterThan(0));
      expect(distance, lessThan(100)); // Should be less than 100 meters
    });

    test('should format distance correctly for meters', () {
      const distance = 150.0;
      final formatted = locationService.formatDistance(distance);
      
      expect(formatted, '150m');
    });

    test('should format distance correctly for kilometers', () {
      const distance = 1500.0;
      final formatted = locationService.formatDistance(distance);
      
      expect(formatted, '1.5km');
    });

    test('should clear location', () {
      locationService.clearLocation();
      
      expect(locationService.currentLatLng, isNull);
    });

    test('should handle loading state', () {
      expect(locationService.isLoading.value, false);
    });
  });
}