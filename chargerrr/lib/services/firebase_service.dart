import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/app_user.dart';

class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Auth getters
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign up with email and password
  Future<Either<Failure, AppUser>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        
        final appUser = AppUser(
          id: result.user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );
        
        await _createUserDocument(appUser);
        return Right(appUser);
      } else {
        return const Left(AuthFailure('Failed to create user account'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
  
  // Sign in with email and password
  Future<Either<Failure, AppUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        final appUser = await _getUserData(result.user!.uid);
        if (appUser != null) {
          return Right(appUser);
        } else {
          return const Left(AuthFailure('User data not found'));
        }
      } else {
        return const Left(AuthFailure('Failed to sign in'));
      }
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Create user document in Firestore
  Future<void> _createUserDocument(AppUser user) async {
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'createdAt': user.createdAt.toIso8601String(),
      'lastLoginAt': DateTime.now().toIso8601String(),
    });
  }
  
  // Get user data from Firestore
  Future<AppUser?> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return AppUser(
          id: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          createdAt: DateTime.parse(data['createdAt']),
          lastLoginAt: data['lastLoginAt'] != null 
            ? DateTime.parse(data['lastLoginAt'])
            : null,
        );
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
  
  // Convert Firebase error codes to user-friendly messages
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}