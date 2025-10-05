import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../services/location_service.dart';
import '../../services/charging_station_service.dart';

class MapHomeController extends GetxController {
  final MapController mapController = MapController();
  final RxBool isMapReady = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _getCurrentLocationOnInit();
  }
  
  void _getCurrentLocationOnInit() async {
    final result = await LocationService.instance.getCurrentLocation();
    result.fold(
      (failure) {
        // Silent fail on init
        // print('Location error on init: ${failure.message}');
      },
      (position) {
        mapController.move(
          LatLng(position.latitude, position.longitude), 
          14.0
        );
      },
    );
  }
  
  void getCurrentLocation() async {
    final result = await LocationService.instance.getCurrentLocation();
    
    result.fold(
      (failure) {
        if (failure.message.contains('permanently denied')) {
          Get.dialog(
            AlertDialog(
              title: const Text('Location Permission'),
              content: const Text('Please enable location permission in app settings.'),
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
                  child: const Text('Settings'),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar(
            'Location Error',
            failure.message,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      (position) {
        mapController.move(
          LatLng(position.latitude, position.longitude), 
          16.0
        );
        Get.snackbar(
          'Location Found',
          'Showing your current location',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }
  
  void searchStations(String query) {
    final results = ChargingStationService.instance.searchStations(query);
    Get.snackbar('Search', 'Found ${results.length} stations');
  }
  
  void logout() async {
    await SupabaseService.instance.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}

class MapHomePage extends StatelessWidget {
  const MapHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapHomeController>(
      init: MapHomeController(),
      builder: (controller) => Scaffold(
        body: Stack(
          children: [
            _buildMap(controller),
            _buildSearchBar(controller),
            _buildLocationButton(controller),
            _buildLogoutButton(controller),
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
          initialCenter: const LatLng(28.6139, 77.2090), // Delhi
          initialZoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.debasmita.chargerrr.chargerrr',
          ),
          
          // Station markers
          MarkerLayer(
            markers: stations.map((station) => Marker(
              point: station.position,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => Get.snackbar('Station', station.name),
                child: Container(
                  decoration: BoxDecoration(
                    color: station.isAvailable ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.ev_station, color: Colors.white, size: 20),
                ),
              ),
            )).toList(),
          ),
          
          // User location marker
          if (userLocation != null)
            MarkerLayer(
              markers: [
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
                  hintText: 'Search charging stations...',
                  border: InputBorder.none,
                ),
                onSubmitted: controller.searchStations,
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
      bottom: 100,
      child: Obx(() => FloatingActionButton(
        heroTag: "location",
        backgroundColor: Colors.white,
        onPressed: LocationService.instance.isLoading ? null : controller.getCurrentLocation,
        child: LocationService.instance.isLoading
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Icon(Icons.my_location, color: AppConstants.primaryGreen),
      )),
    );
  }

  Widget _buildLogoutButton(MapHomeController controller) {
    return Positioned(
      right: 16,
      bottom: 40,
      child: FloatingActionButton(
        heroTag: "logout",
        backgroundColor: Colors.red,
        onPressed: controller.logout,
        child: const Icon(Icons.logout, color: Colors.white),
      ),
    );
  }
}