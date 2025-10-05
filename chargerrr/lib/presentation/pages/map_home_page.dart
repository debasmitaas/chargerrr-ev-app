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
  final TextEditingController _searchController = TextEditingController();
  
  late LatLng _center;
  ChargingStation? _selectedStation;
  bool _isLocationLoading = false;
  bool _isSearching = false;
  List<ChargingStation> _filteredStations = [];
  
  @override
  void initState() {
    super.initState();
    _center = const LatLng(AppConstants.indiaLatitude, AppConstants.indiaLongitude);
    _filteredStations = _stationService.stations;
    _getCurrentLocation();
    
    // Listen for search text changes
    _searchController.addListener(_onSearchChanged);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_searchController.text.isEmpty) {
        _filteredStations = _stationService.stations;
      } else {
        _filteredStations = _stationService.searchStations(_searchController.text);
      }
    });
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
  
  void _selectStationFromSearch(ChargingStation station) {
    setState(() {
      _selectedStation = station;
      _searchController.clear();
      _isSearching = false;
    });
    
    // Move map to selected station
    _mapController.move(station.position, AppConstants.stationZoom);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildFloatingSearchBar(),
          if (_isSearching && _filteredStations.isNotEmpty) _buildSearchResults(),
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
    final stationsToShow = _isSearching ? _filteredStations : _stationService.stations;
    
    return stationsToShow.map((station) {
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
  
  Widget _buildFloatingSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 16,
      right: 16,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a place here',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onTap: () {
                  if (_searchController.text.isNotEmpty) {
                    setState(() => _isSearching = true);
                  }
                },
              ),
            ),
            if (_searchController.text.isNotEmpty) ...[
              IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[600]),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _isSearching = false;
                    _filteredStations = _stationService.stations;
                  });
                },
              ),
            ] else ...[
              const SizedBox(width: 16),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSearchResults() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 85, // Below search bar
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _filteredStations.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.search_off, color: Colors.grey[400], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No charging stations found for "${_searchController.text}"',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredStations.length > 5 ? 5 : _filteredStations.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final station = _filteredStations[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: station.isAvailable 
                            ? AppConstants.accentGreen.withOpacity(0.1)
                            : AppConstants.errorRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.ev_station,
                        color: station.isAvailable 
                            ? AppConstants.accentGreen
                            : AppConstants.errorRed,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${station.address}, ${station.city}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: station.isAvailable 
                                    ? AppConstants.accentGreen.withOpacity(0.1)
                                    : AppConstants.errorRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${station.availablePoints}/${station.totalPoints} Available',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: station.isAvailable 
                                      ? AppConstants.accentGreen
                                      : AppConstants.errorRed,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_locationService.currentLatLng != null) ...[
                              Icon(Icons.location_on, size: 12, color: Colors.grey[500]),
                              const SizedBox(width: 2),
                              Text(
                                _locationService.formatDistance(
                                  _locationService.calculateDistanceLatLng(
                                    _locationService.currentLatLng!,
                                    station.position,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _selectStationFromSearch(station),
                  );
                },
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
          Get.snackbar(
            'Navigation',
            'Opening navigation to ${_selectedStation!.name}',
            backgroundColor: AppConstants.primaryGreen,
            colorText: Colors.white,
          );
        },
        onDetails: () {
          // TODO: Navigate to station details
          Get.snackbar(
            'Details',
            'Opening details for ${_selectedStation!.name}',
            backgroundColor: AppConstants.primaryGreen,
            colorText: Colors.white,
          );
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
            elevation: 4,
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
            elevation: 4,
            onPressed: () {
              _stationService.refreshStations();
              setState(() {
                _filteredStations = _stationService.stations;
              });
              Get.snackbar(
                'Refreshed',
                'Charging stations updated',
                backgroundColor: AppConstants.primaryGreen,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "logout",
            mini: true,
            backgroundColor: AppConstants.errorRed,
            elevation: 4,
            onPressed: () async {
              await FirebaseService.instance.signOut();
              Get.offAllNamed(AppRoutes.login);
            },
            child: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }
}