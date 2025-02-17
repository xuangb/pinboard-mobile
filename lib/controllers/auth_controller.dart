import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String baseUrl = "http://10.0.2.2:5062/api/User"; // Change for iOS if needed

  Future<bool> signIn(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/authenticate');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token); // ✅ Save token

        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('Login failed: ${errorData['message']}');
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }
}
