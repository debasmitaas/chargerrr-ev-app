import 'package:equatable/equatable.dart';

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
  final Map<String, dynamic>? openingHours;

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
    this.openingHours,
  });

  // Helper getters
  bool get isAvailable => availablePoints > 0 && isOperational;
  String get availabilityText => isAvailable ? 'Available' : 'Occupied';
  String get distanceText => ''; // Will be calculated based on user location
  
  // Rating helpers
  String get ratingText => rating != null ? rating!.toStringAsFixed(1) : 'No rating';
  String get reviewText => reviewCount != null ? '($reviewCount reviews)' : '(No reviews)';

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        city,
        state,
        latitude,
        longitude,
        availablePoints,
        totalPoints,
        connectorTypes,
        amenities,
        stationType,
        rating,
        reviewCount,
        pricePerKwh,
        imageUrl,
        isOperational,
        is24x7,
        operatorName,
        operatorPhone,
        lastUpdated,
        description,
        openingHours,
      ];
}