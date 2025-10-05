import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../domain/entities/charging_station.dart';
import 'supabase_service.dart';

class ChargingStationService extends GetxService {
  static ChargingStationService get instance => Get.find();

  final RxList<ChargingStation> _stations = <ChargingStation>[].obs;

  List<ChargingStation> get stations => _stations;

  @override
  void onInit() {
    super.onInit();
    loadStations();
  }

  Future<void> loadStations() async {
    try {
      final response = await SupabaseService.instance.getChargingStations();
      
      _stations.value = response.map((json) {
        return ChargingStation(
          id: json['id'].toString(),
          name: json['name'] ?? 'Unknown Station',
          address: json['address'] ?? 'Unknown Address',
          position: LatLng(
            (json['latitude'] as num).toDouble(),
            (json['longitude'] as num).toDouble(),
          ),
          operatorName: json['operator_name'] ?? 'Unknown Operator',
          totalPoints: json['total_points'] ?? 1,
          availablePoints: json['available_points'] ?? 1,
          pricePerKwh: (json['price_per_kwh'] as num?)?.toDouble() ?? 12.0,
          connectorTypes: List<String>.from(json['connector_types'] ?? []),
          amenities: List<String>.from(json['amenities'] ?? []),
          openingHours: json['opening_hours'] ?? '24/7',
          isOperational: json['is_operational'] ?? true,
          addedBy: json['added_by'],
          addedByEmail: json['added_by_email'],
          createdAt: json['created_at'] != null 
              ? DateTime.parse(json['created_at']) 
              : DateTime.now(),
        );
      }).toList();
      
    } catch (e) {
      // print('Error loading stations: $e');
      _stations.clear();
    }
  }

  void addStation(ChargingStation station) {
    _stations.add(station);
  }

  void updateStation(ChargingStation updatedStation) {
    final index = _stations.indexWhere((s) => s.id == updatedStation.id);
    if (index != -1) {
      _stations[index] = updatedStation;
    }
  }

  void removeStation(String stationId) {
    _stations.removeWhere((s) => s.id == stationId);
  }

  List<ChargingStation> searchStations(String query) {
    if (query.isEmpty) return stations;
    
    return stations.where((station) {
      return station.name.toLowerCase().contains(query.toLowerCase()) ||
             station.address.toLowerCase().contains(query.toLowerCase()) ||
             station.operatorName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<ChargingStation> getStationsByUser(String userId) {
    return stations.where((station) => station.addedBy == userId).toList();
  }

  Future<void> refreshStations() async {
    await loadStations();
  }
}