 
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:chargerrr/domain/entities/charging_station.dart';

void main() {
  group('ChargingStation', () {
    test('should create ChargingStation with all required fields', () {
      final station = ChargingStation(
        id: 'test-id',
        name: 'Test Station',
        address: 'Test Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'Test Operator',
        totalPoints: 5,
        availablePoints: 3,
        pricePerKwh: 12.0,
        connectorTypes: ['Type 2', 'CCS'],
        amenities: ['wifi', 'restroom'],
        openingHours: '24/7',
        isOperational: true,
        createdAt: DateTime.now(),
      );

      expect(station.id, 'test-id');
      expect(station.name, 'Test Station');
      expect(station.isAvailable, true);
      expect(station.priceText, '₹12.0/kWh');
    });

    test('should return correct availability status', () {
      final availableStation = ChargingStation(
        id: 'test-1',
        name: 'Available Station',
        address: 'Test Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'Test Operator',
        totalPoints: 5,
        availablePoints: 3,
        pricePerKwh: 12.0,
        connectorTypes: [],
        amenities: [],
        openingHours: '24/7',
        isOperational: true,
        createdAt: DateTime.now(),
      );

      final unavailableStation = ChargingStation(
        id: 'test-2',
        name: 'Unavailable Station',
        address: 'Test Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'Test Operator',
        totalPoints: 5,
        availablePoints: 0,
        pricePerKwh: 12.0,
        connectorTypes: [],
        amenities: [],
        openingHours: '24/7',
        isOperational: true,
        createdAt: DateTime.now(),
      );

      expect(availableStation.isAvailable, true);
      expect(unavailableStation.isAvailable, false);
    });

    test('should format price correctly', () {
      final station = ChargingStation(
        id: 'test-id',
        name: 'Test Station',
        address: 'Test Address',
        position: const LatLng(28.6139, 77.2090),
        operatorName: 'Test Operator',
        totalPoints: 5,
        availablePoints: 3,
        pricePerKwh: 15.5,
        connectorTypes: [],
        amenities: [],
        openingHours: '24/7',
        isOperational: true,
        createdAt: DateTime.now(),
      );

      expect(station.priceText, '₹15.5/kWh');
    });
  });
}