import 'package:flutter/material.dart';

class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
  
  // App Identity
  static const String appName = 'Chargerrr';
  static const String appVersion = '1.0.0';
  
  // Brand Colors 
  static const Color primaryGreen = Color(0xFF1B5E20);      // Dark green
  static const Color accentGreen = Color(0xFF4CAF50);       // Medium green  
  static const Color lightGreen = Color(0xFFE8F5E8);        // Very light green
  static const Color electricBlue = Color(0xFF2196F3);      // Electric blue
  static const Color warningOrange = Color(0xFFFF9800);     // Warning/occupied
  static const Color errorRed = Color(0xFFE53935);          // Error/unavailable
  static const Color neutralGrey = Color(0xFF757575);       // Text/icons
  static const Color backgroundGrey = Color(0xFFF5F5F5);    // Background
  
  // Map Configuration for India
  static const double indiaLatitude = 20.5937;   // Center of India
  static const double indiaLongitude = 78.9629;  // Center of India
  static const double indiaZoom = 5.0;           // Shows entire India
  static const double cityZoom = 12.0;           // City level zoom
  static const double stationZoom = 16.0;        // Individual station zoom
  
  // Firebase Collections (Database table names)
  static const String chargingStationsCollection = 'charging_stations';
  static const String usersCollection = 'users';
  static const String reviewsCollection = 'reviews';
  static const String bookingsCollection = 'bookings';
  
  // Station Types 
  static const List<String> stationTypes = [
    'Fast Charging (DC)',
    'Super Fast Charging',
    'Standard Charging (AC)',
    'Battery Swapping',
    'Tesla Supercharger',
    'Universal Charging'
  ];
  
  // Connector Types 
  static const List<String> connectorTypes = [
    'CCS2',           // Combined Charging System
    'CHAdeMO',        // Japanese standard
    'Type 2 AC',      // European standard
    'Bharat AC',      // Indian AC standard
    'Bharat DC',      // Indian DC standard
    'Tesla',          // Tesla proprietary
  ];
  
  // Common Amenities 
  static const List<String> commonAmenities = [
    'WiFi',
    'Restroom',
    'Cafe/Restaurant',
    'Shopping Mall',
    'Free Parking',
    'Paid Parking',
    'ATM',
    '24/7 Access',
    'Security',
    'Wheelchair Accessible'
  ];
  
  // Pricing Ranges
  static const Map<String, double> pricingRanges = {
    'budget': 8.0,      // ₹8 per kWh
    'standard': 12.0,   // ₹12 per kWh  
    'premium': 18.0,    // ₹18 per kWh
  };
  
  // Common Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Error Messages
  static const String networkError = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please check your credentials.';
  static const String locationError = 'Unable to get your location. Please enable location services.';
  
  // Success Messages  
  static const String loginSuccess = 'Welcome back to Chargerrr!';
  static const String signupSuccess = 'Account created successfully!';
  static const String locationSuccess = 'Location updated successfully!';
}