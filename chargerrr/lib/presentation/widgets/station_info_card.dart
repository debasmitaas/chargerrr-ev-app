import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/charging_station.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_utils.dart';
import '../../services/location_service.dart';

class StationInfoCard extends StatelessWidget {
  final ChargingStation station;
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final VoidCallback onDetails;

  const StationInfoCard({
    super.key,
    required this.station,
    required this.onClose,
    required this.onNavigate,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildStationInfo(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: station.isAvailable 
                ? AppConstants.accentGreen 
                : AppConstants.errorRed,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.ev_station, 
            color: Colors.white, 
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                station.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                station.operatorName,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildStationInfo() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                station.address,
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildDistanceWidget(),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfoChip(
              '${station.availablePoints}/${station.totalPoints} Available',
              station.isAvailable 
                  ? AppConstants.accentGreen 
                  : AppConstants.errorRed,
            ),
            const SizedBox(width: 8),
            _buildInfoChip(
              station.priceText, 
              AppConstants.primaryGreen,
            ),
            if (station.rating != null) ...[
              const SizedBox(width: 8),
              _buildRatingChip(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceWidget() {
    final userLocation = LocationService.instance.currentLatLng;
    
    if (userLocation == null) {
      return const SizedBox.shrink();
    }

    final distanceInMeters = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      station.position.latitude,
      station.position.longitude,
    );

    return Text(
      AppUtils.formatDistance(distanceInMeters),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppConstants.primaryGreen,
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRatingChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Colors.orange),
          const SizedBox(width: 2),
          Text(
            station.ratingText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onNavigate,
            icon: const Icon(Icons.directions, size: 18),
            label: const Text('Navigate'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppConstants.primaryGreen),
              foregroundColor: AppConstants.primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDetails,
            icon: const Icon(Icons.info_outline, size: 18),
            label: const Text('Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}