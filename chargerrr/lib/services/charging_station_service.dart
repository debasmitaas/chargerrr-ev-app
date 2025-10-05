import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/entities/charging_station.dart';
import '../services/location_service.dart';

class ChargingStationService extends GetxService {
  static ChargingStationService get instance => Get.find();
  
  final RxList<ChargingStation> _stations = <ChargingStation>[].obs;
  final RxBool _isLoading = false.obs;
  
  SupabaseClient get _client => Supabase.instance.client;
  
  List<ChargingStation> get stations => _stations;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    loadStations();
  }
  
  // Load stations from Supabase database
  Future<void> loadStations() async {
    try {
      _isLoading.value = true;
      
      final response = await _client
          .from('charging_stations')
          .select()
          .order('name');
      
      _stations.value = response.map<ChargingStation>((data) => 
        _mapToChargingStation(data)
      ).toList();
      
    } catch (e) {
      // If database fails, use mock data
      _loadMockData();
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Convert database row to ChargingStation object
  ChargingStation _mapToChargingStation(Map<String, dynamic> data) {
    return ChargingStation(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      city: data['city'],
      state: data['state'],
      latitude: data['latitude'].toDouble(),
      longitude: data['longitude'].toDouble(),
      availablePoints: data['available_points'],
      totalPoints: data['total_points'],
      connectorTypes: List<String>.from(data['connector_types'] ?? []),
      amenities: List<String>.from(data['amenities'] ?? []),
      stationType: data['station_type'],
      operatorName: data['operator_name'],
      operatorPhone: data['operator_phone'],
      rating: data['rating']?.toDouble(),
      reviewCount: data['review_count'],
      pricePerKwh: data['price_per_kwh']?.toDouble(),
      imageUrl: data['image_url'],
      isOperational: data['is_operational'] ?? true,
      is24x7: data['is_24x7'] ?? false,
      lastUpdated: data['last_updated'] != null 
          ? DateTime.parse(data['last_updated'])
          : null,
      description: data['description'],
    );
  }
  
  // Search stations
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
  
  // Refresh stations from database
  Future<void> refreshStations() async {
    await loadStations();
  }
  
  // Get stations near your location
  List<ChargingStation> getStationsNearLocation(LatLng location, {double radiusInKm = 10.0}) {
    return _stations.where((station) {
      final distance = LocationService.instance.calculateDistanceLatLng(location, station.position);
      return distance <= radiusInKm * 1000;
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
  
  // Get available stations only
  List<ChargingStation> getAvailableStations() {
    return _stations.where((station) => station.isAvailable).toList();
  }
  
  // Backup mock data if database fails
  void _loadMockData() {
    _stations.value = [
      const ChargingStation(
        id: 'mock-1',
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
    ];
  }
}