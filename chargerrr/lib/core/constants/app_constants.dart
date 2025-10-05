import 'package:flutter/material.dart';

class AppConstants {
  // ========================
  // APP INFORMATION
  // ========================
  static const String appName = 'Chargerrr';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Find EV charging stations near you';
  static const String appTagline = 'Power up your journey';
  static const String developerName = 'Chargerrr Team';
  static const String supportEmail = 'support@chargerrr.com';
  
  // ========================
  // COLORS - PRIMARY PALETTE
  // ========================
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color forestGreen = Color(0xFF0D4F12);
  
  // ========================
  // COLORS - STATUS COLORS
  // ========================
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF1976D2);
  static const Color purpleAccent = Color(0xFF9C27B0);
  
  // ========================
  // COLORS - NEUTRAL COLORS
  // ========================
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color shadowGrey = Color(0xFFE0E0E0);
  static const Color borderGrey = Color(0xFFDDDDDD);
  
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF424242);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textVeryLight = Color(0xFFBDBDBD);
  
  // ========================
  // COLORS - CHARGING STATUS
  // ========================
  static const Color availableGreen = Color(0xFF4CAF50);
  static const Color limitedOrange = Color(0xFFFF9800);
  static const Color occupiedRed = Color(0xFFD32F2F);
  static const Color offlineGrey = Color(0xFF757575);
  static const Color chargingBlue = Color(0xFF2196F3);
  
  // ========================
  // TIMING & DURATIONS
  // ========================
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  static const Duration slowAnimation = Duration(seconds: 1);
  static const Duration verySlowAnimation = Duration(seconds: 2);
  
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 300);
  static const Duration longDelay = Duration(milliseconds: 500);
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration locationTimeout = Duration(seconds: 10);
  
  // ========================
  // TYPOGRAPHY - FONT SIZES
  // ========================
  static const double fontTiny = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontRegular = 16.0;
  static const double fontLarge = 18.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
  static const double fontHuge = 28.0;
  static const double fontMassive = 32.0;
  static const double fontGigantic = 40.0;
  
  // ========================
  // TYPOGRAPHY - FONT WEIGHTS
  // ========================
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  
  // ========================
  // SPACING & PADDING
  // ========================
  static const double spaceTiny = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceXLarge = 32.0;
  static const double spaceXXLarge = 40.0;
  static const double spaceHuge = 48.0;
  
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double paddingXXLarge = 40.0;
  
  static const double marginTiny = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;
  
  // ========================
  // BORDER RADIUS
  // ========================
  static const double radiusTiny = 2.0;
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusXXLarge = 20.0;
  static const double radiusHuge = 24.0;
  static const double radiusCircular = 50.0;
  
  // ========================
  // MAP CONSTANTS - LOCATIONS
  // ========================
  static const double indiaLatitude = 20.5937;
  static const double indiaLongitude = 78.9629;
  static const double delhiLatitude = 28.6139;
  static const double delhiLongitude = 77.2090;
  static const double mumbaiLatitude = 19.0760;
  static const double mumbaiLongitude = 72.8777;
  static const double bangaloreLatitude = 12.9716;
  static const double bangaloreLongitude = 77.5946;
  static const double chennaiLatitude = 13.0827;
  static const double chennaiLongitude = 80.2707;
  
  // ========================
  // MAP CONSTANTS - ZOOM LEVELS
  // ========================
  static const double worldZoom = 2.0;
  static const double continentZoom = 3.0;
  static const double countryZoom = 5.0;
  static const double indiaZoom = 5.0;
  static const double regionZoom = 7.0;
  static const double stateZoom = 8.0;
  static const double cityZoom = 12.0;
  static const double areaZoom = 15.0;
  static const double stationZoom = 16.0;
  static const double detailZoom = 18.0;
  static const double maxZoom = 20.0;
  
  // ========================
  // CHARGING STATION CONSTANTS
  // ========================
  static const int maxSearchRadius = 100; // km
  static const int defaultSearchRadius = 10; // km
  static const int minSearchRadius = 1; // km
  static const int nearbyRadius = 5; // km
  static const int extendedRadius = 25; // km
  
  static const double maxPricePerKwh = 50.0; // ₹
  static const double minPricePerKwh = 5.0; // ₹
  static const double averagePricePerKwh = 12.0; // ₹
  
  static const int maxRating = 5;
  static const int minRating = 1;
  static const double defaultRating = 3.0;
  
  // ========================
  // CONNECTOR TYPES
  // ========================
  static const List<String> connectorTypes = [
    'CCS2',
    'CHAdeMO',
    'Type 2 AC',
    'Type 1 AC',
    'Bharat AC',
    'Bharat DC',
    'Tesla Supercharger',
    'GB/T',
    'Schuko',
  ];
  
  // ========================
  // STATION TYPES
  // ========================
  static const List<String> stationTypes = [
    'Super Fast Charging',
    'Fast Charging (DC)',
    'Standard Charging (AC)',
    'Ultra Fast Charging',
    'Battery Swapping',
    'Tesla Supercharger',
    'Home Charging',
    'Workplace Charging',
  ];
  
  // ========================
  // POWER LEVELS
  // ========================
  static const Map<String, String> powerLevels = {
    'Level 1': '1.4 kW - 2.3 kW',
    'Level 2': '3.3 kW - 22 kW',
    'Level 3': '50 kW - 350 kW',
  };
  
  // ========================
  // AMENITIES
  // ========================
  static const List<String> commonAmenities = [
    'WiFi',
    'Cafe/Restaurant',
    'Restroom',
    'Shopping Mall',
    'ATM',
    'Free Parking',
    'Paid Parking',
    'Security',
    '24/7 Access',
    'Metro Station',
    'Food Court',
    'Gas Station',
    'Car Wash',
    'Tire Service',
    'EV Service Center',
    'Waiting Lounge',
    'Kids Play Area',
    'Pet Friendly',
  ];
  
  // ========================
  // CURRENCY & FORMATTING
  // ========================
  static const String defaultCurrency = '₹';
  static const String currencySymbol = '₹';
  static const String dollarSymbol = '\$';
  static const String euroSymbol = '€';
  
  // ========================
  // API CONSTANTS
  // ========================
  static const String baseUrl = 'https://api.chargerrr.com';
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/v1';
  static const int apiTimeoutSeconds = 30;
  static const int retryAttempts = 3;
  static const int retryDelaySeconds = 2;
  
  // ========================
  // STORAGE KEYS
  // ========================
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String userPreferencesKey = 'user_preferences';
  static const String lastLocationKey = 'last_location';
  static const String appPreferencesKey = 'app_preferences';
  static const String favoriteStationsKey = 'favorite_stations';
  static const String searchHistoryKey = 'search_history';
  static const String recentStationsKey = 'recent_stations';
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  
  // ========================
  // VALIDATION CONSTANTS
  // ========================
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  
  // ========================
  // REGEX PATTERNS
  // ========================
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[6-9]\d{9}$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';
  
  // ========================
  // ERROR MESSAGES
  // ========================
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String locationErrorMessage = 'Unable to get your location.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';
  static const String timeoutErrorMessage = 'Request timed out. Please try again.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  
  // Specific error messages
  static const String emailRequiredMessage = 'Email is required';
  static const String invalidEmailMessage = 'Please enter a valid email';
  static const String passwordRequiredMessage = 'Password is required';
  static const String weakPasswordMessage = 'Password must be at least 6 characters';
  static const String nameRequiredMessage = 'Name is required';
  static const String phoneRequiredMessage = 'Phone number is required';
  static const String invalidPhoneMessage = 'Please enter a valid phone number';
  
  // ========================
  // SUCCESS MESSAGES
  // ========================
  static const String loginSuccessMessage = 'Welcome back!';
  static const String signupSuccessMessage = 'Account created successfully!';
  static const String logoutSuccessMessage = 'Logged out successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String locationUpdatedMessage = 'Location updated successfully!';
  static const String bookingSuccessMessage = 'Booking confirmed!';
  static const String bookingCancelledMessage = 'Booking cancelled!';
  static const String reviewSubmittedMessage = 'Review submitted successfully!';
  
  // ========================
  // INFO MESSAGES
  // ========================
  static const String locationPermissionMessage = 'Location permission is required to find nearby stations.';
  static const String noInternetMessage = 'No internet connection. Please check your network.';
  static const String updateAvailableMessage = 'A new version is available. Please update.';
  static const String maintenanceMessage = 'App is under maintenance. Please try again later.';
  
  // ========================
  // PLACEHOLDER TEXTS
  // ========================
  static const String searchPlaceholder = 'Search stations, locations...';
  static const String emailPlaceholder = 'Enter your email';
  static const String passwordPlaceholder = 'Enter your password';
  static const String confirmPasswordPlaceholder = 'Confirm your password';
  static const String namePlaceholder = 'Enter your full name';
  static const String phonePlaceholder = 'Enter your phone number';
  static const String addressPlaceholder = 'Enter your address';
  static const String reviewPlaceholder = 'Write your review...';
  
  // ========================
  // BUTTON TEXTS
  // ========================
  static const String loginButtonText = 'Sign In';
  static const String signupButtonText = 'Create Account';
  static const String logoutButtonText = 'Logout';
  static const String continueButtonText = 'Continue';
  static const String cancelButtonText = 'Cancel';
  static const String saveButtonText = 'Save';
  static const String updateButtonText = 'Update';
  static const String deleteButtonText = 'Delete';
  static const String confirmButtonText = 'Confirm';
  
  static const String navigateButtonText = 'Navigate';
  static const String detailsButtonText = 'Details';
  static const String refreshButtonText = 'Refresh';
  static const String searchButtonText = 'Search';
  static const String filterButtonText = 'Filter';
  static const String bookButtonText = 'Book Now';
  static const String callButtonText = 'Call';
  static const String shareButtonText = 'Share';
  static const String favoriteButtonText = 'Favorite';
  static const String reviewButtonText = 'Review';
  
  // ========================
  // ASSET PATHS
  // ========================
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String animationsPath = 'assets/animations/';
  static const String soundsPath = 'assets/sounds/';
  
  // Specific assets
  static const String appLogo = '${imagesPath}app_logo.png';
  static const String splashLogo = '${imagesPath}splash_logo.png';
  static const String defaultAvatar = '${imagesPath}default_avatar.png';
  static const String chargingAnimation = '${animationsPath}charging.json';
  
  // ========================
  // FIREBASE COLLECTION NAMES
  // ========================
  static const String usersCollection = 'users';
  static const String stationsCollection = 'charging_stations';
  static const String reviewsCollection = 'reviews';
  static const String bookingsCollection = 'bookings';
  static const String operatorsCollection = 'operators';
  static const String paymentsCollection = 'payments';
  static const String notificationsCollection = 'notifications';
  static const String feedbackCollection = 'feedback';
  static const String analyticsCollection = 'analytics';
  
  // ========================
  // WIDGET SIZES
  // ========================
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightLarge = 64.0;
  
  static const double inputFieldHeight = 56.0;
  static const double inputFieldHeightSmall = 40.0;
  static const double inputFieldHeightLarge = 64.0;
  
  static const double appBarHeight = 60.0;
  static const double toolbarHeight = 56.0;
  static const double bottomNavBarHeight = 70.0;
  static const double tabBarHeight = 48.0;
  
  static const double cardHeight = 120.0;
  static const double cardHeightSmall = 80.0;
  static const double cardHeightLarge = 160.0;
  
  // ========================
  // ICON SIZES
  // ========================
  static const double iconSizeTiny = 12.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  static const double iconSizeXXLarge = 64.0;
  static const double iconSizeHuge = 80.0;
  
  // ========================
  // AVATAR SIZES
  // ========================
  static const double avatarSizeSmall = 30.0;
  static const double avatarSizeMedium = 40.0;
  static const double avatarSizeLarge = 60.0;
  static const double avatarSizeXLarge = 80.0;
  static const double avatarSizeXXLarge = 100.0;
  
  // ========================
  // ELEVATION LEVELS
  // ========================
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationXHigh = 16.0;
  static const double elevationMax = 24.0;
  
  // ========================
  // OPACITY LEVELS
  // ========================
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.1;
  static const double opacityMedium = 0.3;
  static const double opacityHeavy = 0.7;
  static const double opacityDark = 0.87;
  
  // ========================
  // ANIMATION CURVES
  // ========================
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastCurve = Curves.easeOut;
  static const Curve slowCurve = Curves.easeIn;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.ease;
  static const Curve sharpCurve = Curves.fastOutSlowIn;
  
  // ========================
  // LIST LIMITS
  // ========================
  static const int maxRecentSearches = 10;
  static const int maxFavoriteStations = 50;
  static const int maxRecentStations = 20;
  static const int maxNotifications = 100;
  static const int maxReviewsPerStation = 500;
  
  // ========================
  // PAGINATION
  // ========================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;
  
  // ========================
  // FEATURE FLAGS
  // ========================
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  static const bool enableOfflineMode = true;
}