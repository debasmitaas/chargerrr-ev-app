import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../domain/entities/charging_station.dart';
import '../services/location_service.dart';

class ChargingStationService extends GetxService {
  static ChargingStationService get instance => Get.find();
  
  final RxList<ChargingStation> _stations = <ChargingStation>[].obs;
  final RxBool _isLoading = false.obs;
  
  // Getters
  List<ChargingStation> get stations => _stations;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }
  
  // Load sample charging stations (Delhi NCR area)
  void _loadSampleData() {
    _stations.value = [
      // Connaught Place, Delhi
      const ChargingStation(
        id: '1',
        name: 'BPCL Fast Charging Hub',
        address: 'Connaught Place, Block A',
        city: 'New Delhi',
        state: 'Delhi',
        latitude: 28.6315,
        longitude: 77.2167,
        availablePoints: 3,
        totalPoints: 4,
        connectorTypes: ['CCS2', 'CHAdeMO'],
        amenities: ['WiFi', 'Cafe/Restaurant', 'ATM'],
        stationType: 'Fast Charging (DC)',
        operatorName: 'BPCL',
        rating: 4.2,
        reviewCount: 156,
        pricePerKwh: 12.5,
        is24x7: true,
        operatorPhone: '+91-11-23456789',
      ),
      
      // India Gate area
      const ChargingStation(
        id: '2',
        name: 'Tata Power Super Charger',
        address: 'India Gate Circle',
        city: 'New Delhi',
        state: 'Delhi',
        latitude: 28.6129,
        longitude: 77.2295,
        availablePoints: 0,
        totalPoints: 6,
        connectorTypes: ['CCS2', 'Type 2 AC'],
        amenities: ['Free Parking', 'Security', '24/7 Access'],
        stationType: 'Super Fast Charging',
        operatorName: 'Tata Power',
        rating: 4.7,
        reviewCount: 89,
        pricePerKwh: 15.0,
        is24x7: true,
        operatorPhone: '+91-11-98765432',
      ),
      
      // Gurgaon - Cyber City
      const ChargingStation(
        id: '3',
        name: 'Ather Grid Fast Charging',
        address: 'DLF Cyber City, Phase 2',
        city: 'Gurgaon',
        state: 'Haryana',
        latitude: 28.4949,
        longitude: 77.0869,
        availablePoints: 2,
        totalPoints: 3,
        connectorTypes: ['CCS2', 'Bharat DC'],
        amenities: ['Shopping Mall', 'WiFi', 'Restroom'],
        stationType: 'Fast Charging (DC)',
        operatorName: 'Ather Energy',
        rating: 4.5,
        reviewCount: 234,
        pricePerKwh: 13.8,
        is24x7: false,
        operatorPhone: '+91-124-4567890',
      ),
      
      // Noida Sector 18
      const ChargingStation(
        id: '4',
        name: 'ChargeZone Premium Hub',
        address: 'Atta Market, Sector 18',
        city: 'Noida',
        state: 'Uttar Pradesh',
        latitude: 28.5692,
        longitude: 77.3247,
        availablePoints: 5,
        totalPoints: 8,
        connectorTypes: ['CCS2', 'Type 2 AC', 'Bharat AC'],
        amenities: ['Shopping Mall', 'Cafe/Restaurant', 'Free Parking', 'ATM'],
        stationType: 'Standard Charging (AC)',
        operatorName: 'ChargeZone',
        rating: 4.1,
        reviewCount: 67,
        pricePerKwh: 8.5,
        is24x7: true,
        operatorPhone: '+91-120-9876543',
      ),
      
      // Dwarka, Delhi
      const ChargingStation(
        id: '5',
        name: 'Mahindra Electric Hub',
        address: 'Dwarka Sector 21 Metro Station',
        city: 'New Delhi',
        state: 'Delhi',
        latitude: 28.5521,
        longitude: 77.0598,
        availablePoints: 1,
        totalPoints: 2,
        connectorTypes: ['CCS2', 'CHAdeMO'],
        amenities: ['Metro Station', 'Free Parking'],
        stationType: 'Fast Charging (DC)',
        operatorName: 'Mahindra Electric',
        rating: 3.9,
        reviewCount: 45,
        pricePerKwh: 11.2,
        is24x7: false,
        operatorPhone: '+91-11-8765432',
      ),
    ];
  }
  
  // Get stations near location
  List<ChargingStation> getStationsNearLocation(LatLng location, {double radiusInKm = 10.0}) {
    return _stations.where((station) {
      final distance = LocationService.instance.calculateDistanceLatLng(location, station.position);
      return distance <= radiusInKm * 1000; // Convert km to meters
    }).toList();
  }
  
  // Get station by ID
  ChargingStation? getStationById(String id) {
    try {
      return _stations.firstWhere((station) => station.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Filter available stations only
  List<ChargingStation> getAvailableStations() {
    return _stations.where((station) => station.isAvailable).toList();
  }
}