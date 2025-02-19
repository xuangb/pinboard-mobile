import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String baseUrl = "http://10.0.2.2:8080/api/User"; // Android emulator URL

  Future<bool> signIn(String username, String password) async {
    return _authenticate('$baseUrl/authenticate', {
      "username": username,
      "password": password,
    });
  }

  Future<bool> signUp(String username, String fullname, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      print("⚠️ Passwords do not match!");
      return false;
    }

    return _authenticate('$baseUrl/register', {
      "username": username,
      "fullname": fullname,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    });
  }

  Future<bool> _authenticate(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('token')) {
          await _storeToken(data['token']);
          return true;
        }
      } else {
        print('❌ ${_extractErrorMessage(response)}');
      }
    } catch (error) {
      print('🚨 Error: $error');
    }
    return false;
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Non-JSON response';
    }
  }
}
