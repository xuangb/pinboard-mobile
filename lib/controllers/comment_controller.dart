import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CommentController {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final String _baseCommentsUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/Comment";
  final String _baseUserUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/User";
  final String _basePostUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/Post"; // Added for fetching post details

  // Fetch user details
  Future<String> fetchUserDetails(int userId) async {
    try {
      final response = await http.get(Uri.parse(_baseUserUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        final List<dynamic> userArray = userData['data']['\$values'] ?? [];
        final user = userArray.firstWhere(
          (u) => u['userId'] == userId,
          orElse: () => null,
        );

        return user != null ? user['fullName'] : "Unknown User";
      } else {
        throw Exception("Failed to fetch user details");
      }
    } catch (e) {
      print("Error fetching user details: $e");
      return "Unknown User";
    }
  }

  // Fetch post details using postId
  Future<Map<String, dynamic>> fetchPostDetails(String postId) async {
    try {
      final response = await http.get(Uri.parse(_basePostUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> allPosts = data['\$values'] ?? []; // Extract list of posts

        // Find the post that matches the given postId
        final post = allPosts.firstWhere(
          (p) => p['postId'].toString() == postId,
          orElse: () => null, // Handle case when post is not found
        );

        if (post != null) {
          final int userId = post['userId'];
          final String fullName = await fetchUserDetails(userId); // Get full name

          return {
            ...post, // Spread existing post details
            'fullName': fullName, // Add full name of post creator
            'dateCreated': post['dateCreated'], // Ensure dateCreated is included
          };
        }

        return {}; // Return empty if no post found
      } else {
        throw Exception("Failed to fetch post details");
      }
    } catch (e) {
      print("Error fetching post details for postId $postId: $e");
      return {};
    }
  }

  // Fetch comments for a specific post
  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
  try {
    final userId = await secureStorage.read(key: 'userId'); // Get logged-in user ID

    final response = await http.get(Uri.parse(_baseCommentsUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> allComments = data['\$values'] ?? [];

      final List<Map<String, dynamic>> commentsWithUser = [];

      for (var comment in allComments) {
        if (comment['postId'] == int.parse(postId)) {
          final fullName = await fetchUserDetails(comment['userId']);
          
          commentsWithUser.add({
            'commentId': comment['commentId'].toString(),
            'userId': comment['userId'].toString(),
            'fullName': fullName,
            'content': comment['content'],
            'dateCreated': comment['dateCreated'],
            'isOwner': comment['userId'].toString() == userId, // Check if user owns comment
          });
        }
      }

      return commentsWithUser;
    } else {
      throw Exception("Failed to load comments");
    }
  } catch (e) {
    print("Error fetching comments: $e");
    return [];
  }
}

  //Add comments
  Future<void> addComment(String postId, String content) async {
  try {
    // Get userId from secure storage
    final userId = await secureStorage.read(key: 'userId');
    
    final response = await http.post(
      Uri.parse('$_baseCommentsUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'postId': int.parse(postId),
        'userId': int.parse(userId!), // Convert stored string to int
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  } catch (e) {
    throw Exception('Error adding comment: $e');
  }
}

  //Update user comments
  Future<bool> editComment(String commentId, String postId, String newContent) async {
  try {
    final userId = await secureStorage.read(key: 'userId');

    // Step 1: Fetch all comments
    final response = await http.get(Uri.parse(_baseCommentsUrl));

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch comments");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> allComments = data['\$values'] ?? [];

    // Step 2: Find the comment that matches `commentId`
    final comment = allComments.firstWhere(
      (c) => c['commentId'].toString() == commentId,
      orElse: () => null,
    );

    if (comment == null) {
      print("Comment not found!");
      return false;
    }

    // Step 3: Update the comment via PUT request
    final updateResponse = await http.put(
      Uri.parse(_baseCommentsUrl), // API does not support filtering via URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'commentId': int.parse(commentId), // Send original ID
        'postId': int.parse(postId),
        'userId': int.parse(userId!), // Ensure the user owns the comment
        'content': newContent,
        'dateUpdated': DateTime.now().toIso8601String(), // ✅ Include update timestamp
      }),
    );

    if (updateResponse.statusCode == 200 || updateResponse.statusCode == 204) {
      print("Comment updated successfully!");
      return true; // Return success
    } else {
      print("Failed to update comment. Status: ${updateResponse.statusCode}");
      return false; // Return failure
    }
  } catch (e) {
    print("Error updating comment: $e");
    return false;
  }
}



}
