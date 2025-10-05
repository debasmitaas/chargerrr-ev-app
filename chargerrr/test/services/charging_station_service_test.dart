 
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:chargerrr/services/charging_station_service.dart';
import 'package:chargerrr/domain/entities/charging_station.dart';

void main() {
  group('ChargingStationService', () {
    late ChargingStationService service;
    late ChargingStation testStation;

    setUp(() {
      Get.testMode = true;
      service = ChargingStationService();
      
      testStation = ChargingStation(
        id: 'test-station-1',
        name: 'Test Station',
        address: 'Test Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'Test Operator',
        totalPoints: 5,
        availablePoints: 3,
        pricePerKwh: 12.0,
        connectorTypes: ['Type 2'],
        amenities: ['wifi'],
        openingHours: '24/7',
        isOperational: true,
        createdAt: DateTime.now(),
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('should add station to list', () {
      service.addStation(testStation);
      
      expect(service.stations.length, 1);
      expect(service.stations.first.id, 'test-station-1');
    });

    test('should remove station from list', () {
      service.addStation(testStation);
      expect(service.stations.length, 1);
      
      service.removeStation('test-station-1');
      expect(service.stations.length, 0);
    });

    test('should update existing station', () {
      service.addStation(testStation);
      
      final updatedStation = ChargingStation(
        id: 'test-station-1',
        name: 'Updated Station Name',
        address: testStation.address,
        position: testStation.position,
        operatorName: testStation.operatorName,
        totalPoints: testStation.totalPoints,
        availablePoints: testStation.availablePoints,
        pricePerKwh: testStation.pricePerKwh,
        connectorTypes: testStation.connectorTypes,
        amenities: testStation.amenities,
        openingHours: testStation.openingHours,
        isOperational: testStation.isOperational,
        createdAt: testStation.createdAt,
      );
      
      service.updateStation(updatedStation);
      
      expect(service.stations.first.name, 'Updated Station Name');
    });

    test('should search stations by name', () {
      service.addStation(testStation);
      
      final searchResults = service.searchStations('Test');
      
      expect(searchResults.length, 1);
      expect(searchResults.first.id, 'test-station-1');
    });

    test('should search stations by address', () {
      service.addStation(testStation);
      
      final searchResults = service.searchStations('Test Address');
      
      expect(searchResults.length, 1);
      expect(searchResults.first.id, 'test-station-1');
    });

    test('should return empty list for empty search query', () {
      service.addStation(testStation);
      
      final searchResults = service.searchStations('');
      
      expect(searchResults.length, 1); // Should return all stations
    });

    test('should return empty list for no matches', () {
      service.addStation(testStation);
      
      final searchResults = service.searchStations('NonExistent');
      
      expect(searchResults.length, 0);
    });

    test('should get stations by user', () {
      final userStation = ChargingStation(
        id: 'user-station-1',
        name: 'User Station',
        address: 'User Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'User Operator',
        totalPoints: 3,
        availablePoints: 2,
        pricePerKwh: 10.0,
        connectorTypes: ['Type 1'],
        amenities: ['parking'],
        openingHours: '9-5',
        isOperational: true,
        addedBy: 'user-123',
        createdAt: DateTime.now(),
      );
      
      service.addStation(testStation);
      service.addStation(userStation);
      
      final userStations = service.getStationsByUser('user-123');
      
      expect(userStations.length, 1);
      expect(userStations.first.id, 'user-station-1');
    });
  });
}