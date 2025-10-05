import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class AppUtils {
  // Date & Time Formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }
  
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return formatDate(dateTime);
    }
  }
  
  // Distance & Location
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }
  
  static String formatPrice(double price) {
    return '${AppConstants.defaultCurrency}${price.toStringAsFixed(1)}';
  }
  
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
  
  // Validation
  static bool isValidEmail(String email) {
    return GetUtils.isEmail(email);
  }
  
  static bool isValidPhoneNumber(String phone) {
    return GetUtils.isPhoneNumber(phone);
  }
  
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  // Snackbars
  static void showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppConstants.successGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      borderRadius: AppConstants.radiusMedium,
      duration: AppConstants.mediumAnimation,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
  
  static void showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppConstants.errorRed,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      borderRadius: AppConstants.radiusMedium,
      duration: AppConstants.mediumAnimation,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
  
  static void showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppConstants.infoBlue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      borderRadius: AppConstants.radiusMedium,
      duration: AppConstants.mediumAnimation,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
  
  static void showWarningSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppConstants.warningOrange,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      borderRadius: AppConstants.radiusMedium,
      duration: AppConstants.mediumAnimation,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }
  
  // URL Launcher
  static Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showErrorSnackbar('Error', 'Could not launch $url');
    }
  }
  
  static Future<void> launchPhoneCall(String phoneNumber) async {
    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showErrorSnackbar('Error', 'Could not make phone call');
    }
  }
  
  static Future<void> launchNavigation(double latitude, double longitude) async {
    final Uri uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showErrorSnackbar('Error', 'Could not open navigation');
    }
  }
  
  // Loading Dialog
  static void showLoadingDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                message,
                style: const TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: AppConstants.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  static void hideLoadingDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
  
  // Debug logging
  static void logInfo(String message) {
    debugPrint('INFO: $message');
  }
  
  static void logError(String message) {
    debugPrint('ERROR: $message');
  }
  
  static void logWarning(String message) {
    debugPrint('WARNING: $message');
  }
}