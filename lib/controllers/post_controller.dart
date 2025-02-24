import 'dart:convert';
import 'package:http/http.dart' as http;

class PostController {
  // final String _baseUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/Post";
  //final String _basePostsUrl = "https://commpinboarddb-hchxgbe6hsh9fddx.southeastasia-01.azurewebsites.net/api/Post/withUsers";

  final String _baseUrl = "http://10.0.2.2:5062/api/Post";
  final String _basePostsUrl = "http://10.0.2.2:5062/api/Post/withUsers";

  Future<bool> verifyConnection() async {
    try {
      print('Testing API connection...');
      final response = await http.get(Uri.parse(_basePostsUrl));
      print('Connection test status code: ${response.statusCode}');
      print('Connection test response: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test error: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse(_basePostsUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(response.body);

      if (responseData.containsKey("\$values") && responseData["\$values"] is List) {
        List<dynamic> posts = responseData["\$values"];

        posts.sort((a, b) {
          DateTime dateA = DateTime.parse(a["dateCreated"]); 
          DateTime dateB = DateTime.parse(b["dateCreated"]);
          return dateB.compareTo(dateA);
        });

        return posts;
      } else {
        throw Exception("Unexpected response format");
      }
    } else {
      throw Exception("Failed to load posts");
    }
  } catch (e) {
    print("Error fetching posts: $e");
    return [];
  }
}

  Future<bool> createPost({
      required String userId,
      required String title,
      required String content,
      required String date,
      required String location,
    }) async {
      try {
        final response = await http.post(
          Uri.parse(_baseUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "userId":userId,
            "title": title,
            "content": content,
            "location": location,
            "date": date,
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          return true; // Success
        } else {
          print("Error: ${response.body}");
          return false; // Failed
        }
      } catch (e) {
        print("Exception: $e");
        return false;
      }
    }







}
