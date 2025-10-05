import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class ChargingStation extends Equatable {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final int availablePoints;
  final int totalPoints;
  final List<String> connectorTypes;
  final List<String> amenities;
  final String stationType;
  final double? rating;
  final int? reviewCount;
  final double? pricePerKwh;
  final String? imageUrl;
  final bool isOperational;
  final bool is24x7;
  final String operatorName;
  final String? operatorPhone;
  final DateTime? lastUpdated;
  final String? description;

  const ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.availablePoints,
    required this.totalPoints,
    required this.connectorTypes,
    required this.amenities,
    required this.stationType,
    required this.operatorName,
    this.rating,
    this.reviewCount,
    this.pricePerKwh,
    this.imageUrl,
    this.isOperational = true,
    this.is24x7 = false,
    this.operatorPhone,
    this.lastUpdated,
    this.description,
  });

  // Helper getters for Flutter Map
  bool get isAvailable => availablePoints > 0 && isOperational;
  LatLng get position => LatLng(latitude, longitude);
  
  // Status and color helpers
  String get statusText {
    if (!isOperational) return 'Offline';
    if (availablePoints == 0) return 'Occupied';
    if (availablePoints <= 2) return 'Limited';
    return 'Available';
  }
  
  // Rating and price display
  String get ratingText => rating != null ? rating!.toStringAsFixed(1) : 'No rating';
  String get reviewText => reviewCount != null ? '($reviewCount reviews)' : '(No reviews)';
  String get priceText => pricePerKwh != null ? '₹${pricePerKwh!.toStringAsFixed(1)}/kWh' : 'Price not available';

  @override
  List<Object?> get props => [
        id, name, address, city, state, latitude, longitude,
        availablePoints, totalPoints, connectorTypes, amenities,
        stationType, rating, reviewCount, pricePerKwh, imageUrl,
        isOperational, is24x7, operatorName, operatorPhone,
        lastUpdated, description,
      ];
}