import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final List<String>? favoriteStations;
  final Map<String, dynamic>? preferences;
  final String? vehicleType;
  final String? vehicleModel;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
    this.favoriteStations,
    this.preferences,
    this.vehicleType,
    this.vehicleModel,
  });

  // Helper getters
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get initials => name.isNotEmpty 
    ? name.split(' ').map((n) => n[0]).take(2).join().toUpperCase()
    : email[0].toUpperCase();

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        profileImageUrl,
        createdAt,
        lastLoginAt,
        favoriteStations,
        preferences,
        vehicleType,
        vehicleModel,
      ];
}