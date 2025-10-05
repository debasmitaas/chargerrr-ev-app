import 'package:flutter/material.dart';
import '../../domain/entities/charging_station.dart';
import '../../core/constants/app_constants.dart';

class CustomMarker extends StatelessWidget {
  final ChargingStation station;
  final bool isSelected;
  
  const CustomMarker({
    super.key,
    required this.station,
    this.isSelected = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow
        Positioned(
          bottom: 0,
          child: Container(
            width: isSelected ? 16 : 12,
            height: isSelected ? 8 : 6,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        
        // Main marker
        Container(
          width: isSelected ? 36 : 32,
          height: isSelected ? 36 : 32,
          decoration: BoxDecoration(
            color: _getMarkerColor(),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: isSelected ? 8 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            _getMarkerIcon(),
            color: Colors.white,
            size: isSelected ? 20 : 16,
          ),
        ),
        
        // Status indicator
        if (!station.isOperational || station.availablePoints == 0)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: station.isOperational ? AppConstants.errorRed : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Icon(
                station.isOperational ? Icons.block : Icons.power_off,
                color: Colors.white,
                size: 8,
              ),
            ),
          ),
      ],
    );
  }
  
  Color _getMarkerColor() {
    if (!station.isOperational) return Colors.grey;
    if (station.availablePoints == 0) return AppConstants.errorRed;
    if (station.availablePoints <= 2) return const Color(0xFFFF9800); // Orange
    return AppConstants.accentGreen;
  }
  
  IconData _getMarkerIcon() {
    switch (station.stationType) {
      case 'Super Fast Charging':
        return Icons.flash_on;
      case 'Fast Charging (DC)':
        return Icons.ev_station;
      case 'Standard Charging (AC)':
        return Icons.electrical_services;
      default:
        return Icons.ev_station;
    }
  }
}