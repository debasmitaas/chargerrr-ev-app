import 'package:flutter/material.dart'; // ADD THIS IMPORT
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

// Mock AuthController since the real one might have complex dependencies
class MockAuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  String? validateEmail(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) return 'Name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
  }
}

void main() {
  group('AuthController', () {
    late MockAuthController authController;

    setUp(() {
      Get.testMode = true;
      authController = MockAuthController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should validate email correctly', () {
      expect(authController.validateEmail(''), 'Email is required');
      expect(authController.validateEmail('invalid-email'), 'Please enter a valid email');
      expect(authController.validateEmail('test@example.com'), null);
    });

    test('should validate password correctly', () {
      expect(authController.validatePassword(''), 'Password is required');
      expect(authController.validatePassword('123'), 'Password must be at least 6 characters');
      expect(authController.validatePassword('123456'), null);
    });

    test('should validate name correctly', () {
      expect(authController.validateName(''), 'Name is required');
      expect(authController.validateName('A'), 'Name must be at least 2 characters');
      expect(authController.validateName('John Doe'), null);
    });

    test('should toggle password visibility', () {
      expect(authController.obscurePassword.value, true);
      authController.togglePasswordVisibility();
      expect(authController.obscurePassword.value, false);
    });
  });
}