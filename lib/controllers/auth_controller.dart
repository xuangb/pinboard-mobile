import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
  final String baseUsersUrl = "http://10.0.2.2:5062/api/User";

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<bool> verifyConnection() async {
    try {
      print('Testing API connection...');
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
      print('Starting sign in process');
      print('Endpoint: $baseUsersUrl/authenticate');
      print('Username: $username');

      final response = await http.post(
        Uri.parse('$baseUsersUrl/authenticate'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
            'username': username,
            'password': password,
          }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if(response.statusCode == 200 || response.statusCode == 201){
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        //Extract user data from API response
        String userId = responseData['userId'].toString();
        String username = responseData['userName'];
        String fullName = responseData['fullName'];

        //Save user details securely
        await secureStorage.write(key: 'userId', value: userId);
        await secureStorage.write(key: 'username', value: username);
        await secureStorage.write(key: 'fullName', value: fullName);

        return true;
      }
      return false;
    }catch(e){
      print('Sign in Error: $e');
      return false;
    }
  }

  Future <void> signOut () async{
    await secureStorage.delete(key: 'userId');
    await secureStorage.delete(key: 'username');
    await secureStorage.delete(key: 'fullName');
  }

  Future<String?> getUserId() async {
    return await secureStorage.read(key: 'userId');
  }

  Future<bool> isSignedIn() async {
    String? userId = await secureStorage.read(key: 'userId');
    return userId != null;
  }

  Future <String?> getUsername()async{
    return await secureStorage.read(key: 'username');
  }

  // Future<String?> getFullName() async {
  //   return await secureStorage.read(key: 'fullName');
  // }

  Future<String?> getFullName() async {
  try {
    String? userId = await getUserId();
    if (userId == null) return null;

    final response = await http.get(Uri.parse(baseUsersUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> users = responseData['data']['\$values'];

      final user = users.firstWhere(
        (user) => user['userId'].toString() == userId,
        orElse: () => null,
      );

      return user?['fullName'];
    }
    return null;
  } catch (e) {
    print("Error fetching full name: $e");
    return null;
  }
}

  // Add new signUp method
  Future<bool> signUp(
    String username,
    String fullname,
    String email,
    String passwordHash,
    String confirmPasswordHash,
  ) async {
    try {
      if (passwordHash != confirmPasswordHash) {
        print('Passwords do not match');
        return false;
      }

      print("🔄 Sending sign-up request...");

      final response = await http.post(
        Uri.parse('$baseUsersUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'fullName': fullname,
          'email': email,
          'passwordHash': passwordHash,
        }),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
  try {
    final response = await http.get(Uri.parse(baseUsersUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> users = responseData['data']['\$values'];  // Access the nested array

      // Find user with the matching ID
      Map<String, dynamic>? user = users.firstWhere(
        (user) => user['userId'].toString() == userId,
        orElse: () => null,
      );
      
      print("API Response: $user");
      return user;
    } else {
      throw Exception("Failed to fetch users");
    }
  } catch (e) {
    print("Error fetching user: $e");
    return null;
  }
}

  Future<bool> updateUser(
    String userId, String username, String fullName, String email, String? password) async {
  try {
    final userDetails = await getUserById(userId);

    if (userDetails == null) {
      print('Error: User not found.');
      return false;
    }

    final String externalId = userDetails['externalId'] ?? '';

    if (externalId.isEmpty) {
      print('Error: externalId is missing or invalid.');
      return false;
    }

    Map<String, dynamic> body = {
      'externalId': externalId,
      'userId': int.parse(userId),
      'userName': username,
      'fullName': fullName,
      'email': email,
    };

    if (password != null && password.isNotEmpty) {
      body['passwordHash'] = password;
    }

    print('Request body: ${jsonEncode(body)}'); // Print the request being sent

    final response = await http.put(
      Uri.parse(baseUsersUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Print full response

    return response.statusCode == 200;
  } catch (e) {
    print('Update user error: $e');
    return false;
  }
}




  // String _generateSessionToken(String username) {
  //   return base64Encode(utf8.encode("$username-${DateTime.now().millisecondsSinceEpoch}"));
  // }





}
