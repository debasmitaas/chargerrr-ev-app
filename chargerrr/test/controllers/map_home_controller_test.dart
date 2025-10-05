 
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:chargerrr/presentation/pages/map_home_page.dart';

void main() {
  group('MapHomeController', () {
    late MapHomeController controller;

    setUp(() {
      Get.testMode = true;
      controller = MapHomeController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with null selected station', () {
      expect(controller.selectedStationId.value, isNull);
      expect(controller.selectedStation, isNull);
    });

    test('should initialize with loading false', () {
      expect(controller.isLoading.value, false);
    });

    test('should have map controller', () {
      expect(controller.mapController, isA<MapController>());
    });

    test('should select station', () {
      const stationId = 'test-station-1';
      
      controller.selectStation(stationId);
      
      expect(controller.selectedStationId.value, stationId);
    });

    test('should close station info', () {
      controller.selectedStationId.value = 'test-station-1';
      
      controller.closeStationInfo();
      
      expect(controller.selectedStationId.value, isNull);
    });
  });
}