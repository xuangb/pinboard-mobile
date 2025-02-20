import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final String baseUsersUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/User";

  Future<bool> verifyConnection() async {
    try {
      print('Testing API connection...'); // Debug print
      
      final response = await http.get(Uri.parse(baseUsersUrl));
      
      print('Connection test status code: ${response.statusCode}');
      print('Connection test response: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test error: $e');
      return false;
    }
  }

  Future<bool> signIn(String username, String password)async{
    try{
      final response = await http.post(
        Uri.parse('$baseUsersUrl/authenticate'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
            'username': username,
            'password': password,
          }),
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('username', username);

        return true;
      }
      return false;
    }catch(e){
      print('Sign in Error: $e');
      return false;
    }
  }

  Future <void> signOut () async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
  }

  Future<bool> isSignedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token')!=null;
  }

  Future <String?> getToken()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future <String?> getUsername()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  // Add new signUp method
  Future<bool> signUp(
    String username,
    String fullname,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      if (password != confirmPassword) {
        print('Passwords do not match');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUsersUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'fullName': fullname,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

}
