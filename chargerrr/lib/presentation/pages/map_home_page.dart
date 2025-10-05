import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/constants/app_constants.dart';
import '../../services/location_service.dart';
import '../../services/charging_station_service.dart';
import '../../domain/entities/charging_station.dart';
import '../widgets/custom_sidebar_drawer.dart';
import '../widgets/station_info_card.dart';
import 'package:geolocator/geolocator.dart';
class MapHomeController extends GetxController {
  final MapController mapController = MapController();
  final RxnString selectedStationId = RxnString();
  final RxBool isLoading = false.obs;
  
  ChargingStation? get selectedStation {
    if (selectedStationId.value == null) return null;
    return ChargingStationService.instance.stations
        .where((station) => station.id == selectedStationId.value)
        .firstOrNull;
  }

  @override
  void onInit() {
    super.onInit();
    refreshStations();
  }

  Future<void> refreshStations() async {
    isLoading.value = true;
    await ChargingStationService.instance.refreshStations();
    isLoading.value = false;
  }
  
  void getCurrentLocation() async {
  // Check permission first to avoid repeated dialogs
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.deniedForever) {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('Location permission is permanently denied. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              LocationService.instance.openAppSettings();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryGreen),
            child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return;
  }

  final result = await LocationService.instance.getCurrentLocation();
  
  result.fold(
    (failure) {
      Get.snackbar(
        'Location Error', 
        failure.message, 
        backgroundColor: Colors.red, 
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    },
    (position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      mapController.move(newLocation, 16.0);
      Get.snackbar(
        'Success', 
        'Current location found', 
        backgroundColor: Colors.green, 
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    },
  );
}
  
  void searchLocation(String query) async {
    if (query.trim().isEmpty) return;
    
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        mapController.move(latLng, 14.0);
        Get.snackbar('Found', 'Location found', backgroundColor: AppConstants.primaryGreen, colorText: Colors.white);
      } else {
        Get.snackbar('Not Found', 'Location not found', backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Search failed', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  
  void selectStation(String stationId) {
    selectedStationId.value = stationId;
    
    final station = ChargingStationService.instance.stations
        .where((s) => s.id == stationId)
        .firstOrNull;
    
    if (station != null) {
      mapController.move(station.position, 16.0);
    }
  }
  
  void closeStationInfo() {
    selectedStationId.value = null;
  }
}

class MapHomePage extends StatelessWidget {
  const MapHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapHomeController>(
      init: MapHomeController(),
      builder: (controller) => Scaffold(
        endDrawer: const CustomSidebarDrawer(),
        body: Stack(
          children: [
            _buildMap(controller),
            _buildSearchBar(controller),
            _buildLocationButton(controller),
            _buildStationInfoCard(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(MapHomeController controller) {
    return Obx(() {
      final stations = ChargingStationService.instance.stations;
      final userLocation = LocationService.instance.currentLatLng;
      
      return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: const LatLng(28.6139, 77.2090),
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.debasmita.chargerrr.chargerrr',
          ),
          MarkerLayer(
            markers: [
              ...stations.map((station) => Marker(
                point: station.position,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => controller.selectStation(station.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: station.isAvailable ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.selectedStationId.value == station.id 
                            ? Colors.blue 
                            : Colors.white, 
                        width: controller.selectedStationId.value == station.id ? 3 : 2,
                      ),
                    ),
                    child: const Icon(Icons.ev_station, color: Colors.white, size: 20),
                  ),
                ),
              )),
              if (userLocation != null)
                Marker(
                  point: userLocation,
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.my_location, color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildSearchBar(MapHomeController controller) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search charging points',
                  border: InputBorder.none,
                ),
                onSubmitted: controller.searchLocation,
              ),
            ),
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.menu, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(MapHomeController controller) {
  return Positioned(
    right: 16,
    bottom: 120,
    child: Obx(() => FloatingActionButton(
      heroTag: "location",
      backgroundColor: Colors.white,
      onPressed: LocationService.instance.isLoading.value ? null : controller.getCurrentLocation,
      child: LocationService.instance.isLoading.value
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.my_location, color: AppConstants.primaryGreen),
    )),
  );
}
  Widget _buildStationInfoCard(MapHomeController controller) {
    return Obx(() {
      final selectedStation = controller.selectedStation;
      
      if (selectedStation == null) {
        return const SizedBox.shrink();
      }
      
      return Positioned(
        left: 16,
        right: 16,
        bottom: 200,
        child: StationInfoCard(
          station: selectedStation,
          onClose: controller.closeStationInfo,
          onNavigate: () {
            Get.snackbar(
              'Navigation',
              'Opening navigation to ${selectedStation.name}',
              backgroundColor: AppConstants.primaryGreen,
              colorText: Colors.white,
            );
          },
          onDetails: () {
            Get.snackbar(
              'Details',
              'Showing details for ${selectedStation.name}',
              backgroundColor: AppConstants.primaryGreen,
              colorText: Colors.white,
            );
          },
        ),
      );
    });
  }
}