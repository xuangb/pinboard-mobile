import 'dart:convert';
import 'package:http/http.dart' as http;

class PinPostController {
  final String _baseUrl = "http://10.0.2.2:5062/api/PinnedPost";

  Future<List<Map<String, dynamic>>> getPinnedPosts(String userId) async {
  try {
    final response = await http.get(Uri.parse(_baseUrl));
    
    print("Raw Response Body: ${response.body}");
    
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      print("Decoded JSON: $json");

      // Access the nested array under "$values"
      List<dynamic> data = json['\$values'] ?? [];

      print("Data extracted: $data");

      // Filter the posts where 'isDeleted' is false and 'userId' matches
      List<Map<String, dynamic>> pinnedPosts = data
          .cast<Map<String, dynamic>>()
          .where((post) => 
              post['isDeleted'] == false && 
              post['userId'].toString() == userId)
          .toList();

      print("Filtered Pinned Posts: $pinnedPosts");
      return pinnedPosts;
    } else {
      print("Failed to fetch pinned posts. Status Code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Error fetching pinned posts: $e");
    return [];
  }
}


  Future<bool> pinPost(String postId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "postId": postId,
          "userId": userId,
          }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error pinning post: $e");
      return false;
    }
  }

  Future<bool> unpinPost(String postId, String userId) async {
    try {
      final response = await http.delete(
        Uri.parse("$_baseUrl"),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error unpinning post: $e");
      return false;
    }
  }
}