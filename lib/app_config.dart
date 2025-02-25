import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppConfig {
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const String _userUUIDKey = 'user_uuid';
  static const String _deviceUUIDKey = 'device_uuid';

  // Method to generate a UUID
  static String generateUUID() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  // Store user UUID
  static Future<void> storeUserUUID(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUUIDKey, uuid);
    print('Stored User UUID: $uuid');
  }

  // Get stored user UUID
  static Future<String?> getUserUUID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUUIDKey);
  }

  // Get or generate device UUID
  static Future<String> getDeviceUUID() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceUUIDKey);
    if (deviceId == null) {
      deviceId = generateUUID();
      await prefs.setString(_deviceUUIDKey, deviceId);
    }
    return deviceId;
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool(_hasSeenOnboardingKey) ?? false;
    print('Checking if user has seen onboarding: $hasSeenOnboarding');
    return hasSeenOnboarding;
  }

  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
    print('Marked onboarding as complete');
  }

  // Add method to clear onboarding state (useful for testing)
  static Future<void> clearOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasSeenOnboardingKey);
    print('Cleared onboarding state');
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Cleared all data');
  }
}
