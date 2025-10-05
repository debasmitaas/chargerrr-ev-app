import 'package:latlong2/latlong.dart';

class ChargingStation {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final String operatorName;
  final int totalPoints;
  final int availablePoints;
  final double pricePerKwh;
  final List<String> connectorTypes;
  final List<String> amenities;
  final String? openingHours;
  final String? phone;
  final bool isOperational;
  final String? addedBy;
  final String? addedByEmail;
  final DateTime? createdAt;
  final double? rating;

  ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.operatorName,
    required this.totalPoints,
    required this.availablePoints,
    required this.pricePerKwh,
    this.connectorTypes = const [],
    this.amenities = const [],
    this.openingHours,
    this.phone,
    this.isOperational = true,
    this.addedBy,
    this.addedByEmail,
    this.createdAt,
    this.rating,
  });

  bool get isAvailable => isOperational && availablePoints > 0;

  String get priceText => '₹${pricePerKwh.toStringAsFixed(2)}/kWh';

  String get ratingText => rating != null ? rating!.toStringAsFixed(1) : 'No rating';

  String get addedByText => addedByEmail != null ? 'Added by $addedByEmail' : 'Official station';

  factory ChargingStation.fromJson(Map<String, dynamic> json) {
    return ChargingStation(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      position: LatLng(json['latitude'], json['longitude']),
      operatorName: json['operator_name'],
      totalPoints: json['total_points'] ?? 1,
      availablePoints: json['available_points'] ?? 1,
      pricePerKwh: (json['price_per_kwh'] ?? 12.0).toDouble(),
      connectorTypes: List<String>.from(json['connector_types'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      openingHours: json['opening_hours'],
      phone: json['phone'],
      isOperational: json['is_operational'] ?? true,
      addedBy: json['added_by'],
      addedByEmail: json['added_by_email'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      rating: json['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'operator_name': operatorName,
      'total_points': totalPoints,
      'available_points': availablePoints,
      'price_per_kwh': pricePerKwh,
      'connector_types': connectorTypes,
      'amenities': amenities,
      'opening_hours': openingHours,
      'phone': phone,
      'is_operational': isOperational,
      'added_by': addedBy,
      'added_by_email': addedByEmail,
      'created_at': createdAt?.toIso8601String(),
      'rating': rating,
    };
  }
}