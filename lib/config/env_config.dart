import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAuthDomain =>
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppIdWeb => dotenv.env['FIREBASE_APP_ID_WEB'] ?? '';
  static String get firebaseMeasurementId =>
      dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '';

  static String get firebaseApiKeyAndroid =>
      dotenv.env['FIREBASE_API_KEY_ANDROID'] ?? '';
  static String get firebaseAppIdAndroid =>
      dotenv.env['FIREBASE_APP_ID_ANDROID'] ?? '';

  static String get firebaseApiKeyIos =>
      dotenv.env['FIREBASE_API_KEY_IOS'] ?? '';
  static String get firebaseAppIdIos => dotenv.env['FIREBASE_APP_ID_IOS'] ?? '';
  static String get firebaseIosBundleId =>
      dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '';

  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';
  static String get googleAndroidClientId =>
      dotenv.env['GOOGLE_ANDROID_CLIENT_ID'] ?? '';

  static String get googleMacosClientId =>
      dotenv.env['GOOGLE_MACOS_CLIENT_ID'] ?? '';
  static String get googleWindowsClientId =>
      dotenv.env['GOOGLE_WINDOWS_CLIENT_ID'] ?? '';
  static String get firebaseApiKeyWindows =>
      dotenv.env['FIREBASE_API_KEY_WINDOWS'] ?? '';
  static String get firebaseAppIdWindows =>
      dotenv.env['FIREBASE_APP_ID_WINDOWS'] ?? '';
  static String get firebaseApiKeyMacos =>
      dotenv.env['FIREBASE_API_KEY_MACOS'] ?? '';
  static String get firebaseAppIdMacos =>
      dotenv.env['FIREBASE_APP_ID_MACOS'] ?? '';
}
