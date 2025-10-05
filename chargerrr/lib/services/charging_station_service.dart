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
  
  // Load sample charging stations
  void _loadSampleData() {
    _stations.value = [
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
      
      const ChargingStation(
        id: '6',
        name: 'Reliance Charging Point',
        address: 'Bandra Kurla Complex',
        city: 'Mumbai',
        state: 'Maharashtra',
        latitude: 19.0596,
        longitude: 72.8656,
        availablePoints: 4,
        totalPoints: 6,
        connectorTypes: ['CCS2', 'Type 2 AC'],
        amenities: ['WiFi', 'Cafe/Restaurant', 'Shopping Mall'],
        stationType: 'Fast Charging (DC)',
        operatorName: 'Reliance',
        rating: 4.3,
        reviewCount: 198,
        pricePerKwh: 14.0,
        is24x7: true,
        operatorPhone: '+91-22-12345678',
      ),
      
      const ChargingStation(
        id: '7',
        name: 'Bescom Quick Charge',
        address: 'Electronic City Phase 1',
        city: 'Bangalore',
        state: 'Karnataka',
        latitude: 12.8456,
        longitude: 77.6603,
        availablePoints: 2,
        totalPoints: 4,
        connectorTypes: ['CCS2', 'Bharat DC'],
        amenities: ['Tech Park', 'WiFi', 'Cafe/Restaurant'],
        stationType: 'Fast Charging (DC)',
        operatorName: 'BESCOM',
        rating: 4.0,
        reviewCount: 112,
        pricePerKwh: 10.5,
        is24x7: false,
        operatorPhone: '+91-80-87654321',
      ),
    ];
  }
  
  List<ChargingStation> searchStations(String query) {
    if (query.isEmpty) return _stations;
    
    final searchQuery = query.toLowerCase();
    return _stations.where((station) =>
      station.name.toLowerCase().contains(searchQuery) ||
      station.city.toLowerCase().contains(searchQuery) ||
      station.operatorName.toLowerCase().contains(searchQuery) ||
      station.address.toLowerCase().contains(searchQuery)
    ).toList();
  }
  
  Future<void> refreshStations() async {
    try {
      _isLoading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      _loadSampleData();
    } catch (e) {
      _isLoading.value = false;
      rethrow;
    } finally {
      _isLoading.value = false;
    }
  }
  
  List<ChargingStation> getStationsNearLocation(LatLng location, {double radiusInKm = 10.0}) {
    return _stations.where((station) {
      final distance = LocationService.instance.calculateDistanceLatLng(location, station.position);
      return distance <= radiusInKm * 1000;
    }).toList();
  }
  
  ChargingStation? getStationById(String id) {
    try {
      return _stations.firstWhere((station) => station.id == id);
    } catch (e) {
      return null;
    }
  }
  
  List<ChargingStation> getAvailableStations() {
    return _stations.where((station) => station.isAvailable).toList();
  }
  
  List<ChargingStation> getStationsByCity(String city) {
    return _stations.where((station) => 
      station.city.toLowerCase() == city.toLowerCase()
    ).toList();
  }
  
  List<ChargingStation> getStationsByConnectorType(String connectorType) {
    return _stations.where((station) => 
      station.connectorTypes.contains(connectorType)
    ).toList();
  }
  
  List<ChargingStation> getTopRatedStations({int limit = 10}) {
    final sortedStations = List<ChargingStation>.from(_stations);
    sortedStations.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return sortedStations.take(limit).toList();
  }
}