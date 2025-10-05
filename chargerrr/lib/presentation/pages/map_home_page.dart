import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import '../../services/charging_station_service.dart';
import '../../domain/entities/charging_station.dart';
import '../widgets/station_info_card.dart';
import '../widgets/custom_marker.dart';

class MapHomePage extends StatefulWidget {
  const MapHomePage({super.key});

  @override
  State<MapHomePage> createState() => _MapHomePageState();
}

class _MapHomePageState extends State<MapHomePage> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService.instance;
  final ChargingStationService _stationService = ChargingStationService.instance;
  
  late LatLng _center;
  ChargingStation? _selectedStation;
  bool _isLocationLoading = false;
  
  @override
  void initState() {
    super.initState();
    _center = const LatLng(AppConstants.indiaLatitude, AppConstants.indiaLongitude);
    _getCurrentLocation();
  }
  
  Future<void> _getCurrentLocation() async {
    setState(() => _isLocationLoading = true);
    
    final result = await _locationService.getCurrentLocation();
    result.fold(
      (failure) {
        Get.snackbar(
          'Location Error',
          failure.message,
          backgroundColor: AppConstants.errorRed,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      },
      (position) {
        final newCenter = LatLng(position.latitude, position.longitude);
        setState(() => _center = newCenter);
        _mapController.move(newCenter, AppConstants.cityZoom);
      },
    );
    
    setState(() => _isLocationLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopBar(),
          if (_selectedStation != null) _buildStationInfoCard(),
          _buildFloatingButtons(),
        ],
      ),
    );
  }
  
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: AppConstants.indiaZoom,
        minZoom: 3.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) => setState(() => _selectedStation = null),
      ),
      children: [
        // OpenStreetMap tiles
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.debasmita.chargerrr.chargerrr',
          maxZoom: 18,
        ),
        
        // Charging station markers
        MarkerLayer(
          markers: _buildStationMarkers(),
        ),
        
        // User location marker
        if (_locationService.currentLatLng != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _locationService.currentLatLng!,
                width: 30,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
  
  List<Marker> _buildStationMarkers() {
    return _stationService.stations.map((station) {
      return Marker(
        point: station.position,
        width: 40,
        height: 50,
        child: GestureDetector(
          onTap: () => setState(() => _selectedStation = station),
          child: CustomMarker(
            station: station,
            isSelected: _selectedStation?.id == station.id,
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.ev_station,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryGreen,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: AppConstants.primaryGreen),
              onPressed: () {
                // TODO: Implement search
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppConstants.primaryGreen),
              onPressed: () async {
                await FirebaseService.instance.signOut();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStationInfoCard() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: StationInfoCard(
        station: _selectedStation!,
        onClose: () => setState(() => _selectedStation = null),
        onNavigate: () {
          // TODO: Implement navigation
        },
        onDetails: () {
          // TODO: Navigate to station details
        },
      ),
    );
  }
  
  Widget _buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: _selectedStation != null ? 200 : 100,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: "location",
            mini: true,
            backgroundColor: Colors.white,
            onPressed: _isLocationLoading ? null : _getCurrentLocation,
            child: _isLocationLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location, color: AppConstants.primaryGreen),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "refresh",
            mini: true,
            backgroundColor: AppConstants.primaryGreen,
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }
}