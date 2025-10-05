import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../domain/entities/app_user.dart';
import '../core/config/supabase_config.dart';

class SupabaseService extends GetxService {
  static SupabaseService get instance => Get.find();
  late SupabaseClient _client;
  
  // Expose the client getter
  SupabaseClient get client => _client;
  
  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeSupabase();
  }
  
  Future<void> _initializeSupabase() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _client = Supabase.instance.client;
  }
  
  // Auth getters
  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  
  // Sign up
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      
      if (response.user != null) {
        return Right(_createAppUser(response.user!));
      }
      return const Left(AuthFailure('Signup failed'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
  
  // Sign in
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return Right(_createAppUser(response.user!));
      }
      return const Left(AuthFailure('Login failed'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // Get current user
  AppUser? getCurrentAppUser() {
    final user = currentUser;
    return user != null ? _createAppUser(user) : null;
  }
  
  // ADDED: Database method for adding charging stations
  Future<Map<String, dynamic>> insertChargingStation(Map<String, dynamic> stationData) async {
    try {
      final response = await _client
          .from('charging_stations')
          .insert(stationData)
          .select()
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to insert charging station: $e');
    }
  }
  
  // ADDED: Get all charging stations
  Future<List<Map<String, dynamic>>> getChargingStations() async {
    try {
      final response = await _client
          .from('charging_stations')
          .select()
          .eq('is_operational', true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get charging stations: $e');
    }
  }
  
  // ADDED: Update charging station
  Future<void> updateChargingStation(String id, Map<String, dynamic> data) async {
    try {
      await _client
          .from('charging_stations')
          .update(data)
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update charging station: $e');
    }
  }
  
  // ADDED: Delete charging station
  Future<void> deleteChargingStation(String id) async {
    try {
      await _client
          .from('charging_stations')
          .delete()
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete charging station: $e');
    }
  }
  
  // ADDED: Get stations by user
  Future<List<Map<String, dynamic>>> getStationsByUser(String userId) async {
    try {
      final response = await _client
          .from('charging_stations')
          .select()
          .eq('added_by', userId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get user stations: $e');
    }
  }
  
  // Favorites
  Future<void> addToFavorites(String stationId) async {
    final user = currentUser;
    if (user == null) return;
    
    final metadata = user.userMetadata ?? {};
    final favorites = List<String>.from(metadata['favorites'] ?? []);
    
    if (!favorites.contains(stationId)) {
      favorites.add(stationId);
      await _client.auth.updateUser(
        UserAttributes(data: {...metadata, 'favorites': favorites}),
      );
    }
  }
  
  Future<void> removeFromFavorites(String stationId) async {
    final user = currentUser;
    if (user == null) return;
    
    final metadata = user.userMetadata ?? {};
    final favorites = List<String>.from(metadata['favorites'] ?? []);
    
    favorites.remove(stationId);
    await _client.auth.updateUser(
      UserAttributes(data: {...metadata, 'favorites': favorites}),
    );
  }
  
  List<String> getFavoriteStations() {
    final user = currentUser;
    if (user?.userMetadata == null) return [];
    return List<String>.from(user!.userMetadata!['favorites'] ?? []);
  }
  
  // Create AppUser from Supabase User
  AppUser _createAppUser(User user) {
    final metadata = user.userMetadata ?? {};
    
    return AppUser(
      id: user.id,
      name: metadata['name'] ?? '',
      email: user.email ?? '',
      createdAt: DateTime.parse(user.createdAt),
      favoriteStations: List<String>.from(metadata['favorites'] ?? []),
    );
  }
}