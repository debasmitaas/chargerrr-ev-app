import 'package:flutter_test/flutter_test.dart';
import 'package:chargerrr/domain/entities/app_user.dart';

void main() {
  group('AppUser', () {
    test('should create AppUser with required fields', () {
      final user = AppUser(
        id: 'user-123',
        email: 'test@example.com',
        name: 'Test User',
        createdAt: DateTime.now(),
      );

      expect(user.id, 'user-123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.favoriteStations, isEmpty);
    });

    test('should handle favorite stations', () {
      final user = AppUser(
        id: 'user-123',
        email: 'test@example.com',
        name: 'Test User',
        favoriteStations: ['station-1', 'station-2'],
        createdAt: DateTime.now(),
      );

      expect(user.favoriteStations, ['station-1', 'station-2']);
      expect(user.favoriteStations?.length ?? 0, 2); // Fixed nullable access
    });
  });
}