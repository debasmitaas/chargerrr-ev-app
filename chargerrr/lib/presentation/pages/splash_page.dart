import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../services/location_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // Wait for splash duration
    await Future.delayed(AppConstants.splashDuration);
    
    // Check authentication
    final isLoggedIn = SupabaseService.instance.isLoggedIn;
    
    if (isLoggedIn) {
      // If logged in, check location permission before going to map
      final shouldAskPermission = await LocationService.instance.shouldRequestPermission();
      
      if (shouldAskPermission) {
        // Ask for permission on first app launch
        await LocationService.instance.requestLocationPermission();
      }
      
      Get.offNamed(AppRoutes.mapHome);
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryGreen,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.ev_station,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Chargerrr',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Find your nearest EV charging station',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}