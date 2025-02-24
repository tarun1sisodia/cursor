import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }
  }

  Future<void> verifyPhone(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-phone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send verification code');
    }
  }

  Future<void> confirmOTP(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/confirm-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phone, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify OTP');
    }
  }
}
