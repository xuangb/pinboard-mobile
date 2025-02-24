import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinboard/controllers/auth_controller.dart';
import './update_profile.dart';
import './sign_in_page.dart';

import '../controllers/comment_controller.dart';
import '../controllers/user_controller.dart';

class CommentPage extends StatefulWidget {
  final int postId;

  const CommentPage({super.key, required this.postId});

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  final CommentController _commentController = CommentController();
  final AuthController _authController = AuthController();
  final TextEditingController _textEditingController = TextEditingController();
  final FlutterSecureStorage secure = const FlutterSecureStorage(); // Add this line

  List<Map<String, dynamic>> comments = [];
  Map<String, dynamic>? postDetails;
  String? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _fetchPostDetails();
    _getLoggedInUserId();
  }

  Future<void> _getLoggedInUserId() async {
    String? userId = await secure.read(key: 'userId');
    setState(() {
      loggedInUserId = userId;
    });
  }

  void _addComment() async {
    String newComment = _textEditingController.text.trim();
    if (newComment.isNotEmpty) {
      try {
        // First send the comment to server
        await _commentController.addComment(widget.postId.toString(), newComment);
        
        // Clear the input field
        _textEditingController.clear();
        
        // Refresh comments from server
        _fetchComments();
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment'))
        );
      }
    }
  }

  void _fetchPostDetails() async {
    try {
      final fetchedPost = await _commentController.fetchPostDetails(widget.postId.toString());
      setState(() {
        postDetails = fetchedPost;
      });
    } catch (e) {
      print("Error fetching post details: $e");
    }
  }

  void _fetchComments() async {
    try {
      final fetchedComments = await _commentController.fetchComments(widget.postId.toString());
      setState(() {
        comments = List<Map<String, dynamic>>.from(fetchedComments);
      });
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBackButton(context),
                  const SizedBox(width: 120),
                  _buildUser(),
                  _buildUpdateProfile(context),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildTitle(),
            const SizedBox(height: 10),
            // Post Section
            _buildPostSection(),
            const SizedBox(height: 10),
            _buildAllCommentText(),
            // Comments Section
            Expanded(child: _buildCommentSection()
            ),
            // Comment Input Box
            _buildCommentBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return comments.isEmpty
      ? const Center(
          child: Text(
            "No comments yet.",
            style: TextStyle(color: Colors.white70, fontSize: 25),
          ),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaQuery.removePadding( 
            context: context,
            removeTop: true, 
            child: ListView.builder(
              shrinkWrap: true, 
              physics: const ClampingScrollPhysics(), 
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final String commentId = comment["commentId"].toString();
                final String postId = widget.postId.toString();
                final String userId = comment["userId"].toString(); // Comment owner's userId

                return Card(
                  color: Colors.black54.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 22,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7.0),
                                  child: Container(
                                    width: 2,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          comments[index]["fullName"]??"Unknown User",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          getRelativeTime(comments[index]["dateCreated"] ?? DateTime.now().toString()),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  comment["content"] ?? "",
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                                if (loggedInUserId == userId) // Show edit button if user owns the comment
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => _editComment(commentId, postId, comment["content"] ?? ""),
                                      child: const Icon(Icons.edit),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
  }

  Widget _buildCommentBox() {
    return Container(
      color: Colors.grey.shade900.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                minLines: 1,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20
                  ),
                  hintText: "Write something...",
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _addComment,
              backgroundColor: Colors.transparent, 
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: -0.66, 
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                  const SizedBox(height: 2), 
                  const Text(
                    "Send",
                    style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCommentText() {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: const Text("All Comments", 
      style: TextStyle(
        color: Colors.white, 
        fontWeight: FontWeight.bold, 
        fontSize: 16)
      ),
    );
  }

  Widget _buildPostSection() {
    if(postDetails == null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text(
                    postDetails!["fullName"] ?? "Unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                      )
                    ),
                  Text(
                    getRelativeTime(postDetails!["dateCreated"] ?? DateTime.now().toString()),
                    style: TextStyle(
                      color: Colors.grey, 
                      fontSize: 12
                    )
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                postDetails!["title"] ?? "", 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 18)
                  ),
              const SizedBox(height: 5),
              Text(postDetails!["content"] ?? ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Background color
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/Arrow - Left 2.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              const Text(
                'Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUser() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_circle, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateProfile(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => UpdateProfilePage()),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: const Text(
            "POST DETAILS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 4,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ],
    );
  }

String getRelativeTime(String dateString) {
  DateTime postDate = DateTime.parse(dateString);
  Duration difference = DateTime.now().difference(postDate);

  if (difference.inSeconds < 60) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else {
    int years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, size: 60, color: Colors.red.shade700),
                const SizedBox(height: 10),
                const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to log out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Cancel"),
                    ),
                    // Logout Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your login page
      (route) => false, // Removes all previous routes
    );
  }

void _editComment(String commentId, String postId, String oldContent) {
  TextEditingController editController = TextEditingController(text: oldContent);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Edit Comment"),
        content: TextField(
          controller: editController,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Edit your comment...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String newContent = editController.text.trim();
              if (newContent.isNotEmpty && newContent != oldContent) {
                bool success = await _commentController.editComment(commentId, postId, newContent);
                if (success) {
                  Navigator.pop(context); // Close dialog
                  _fetchComments(); // Refresh comments
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update comment")),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}



}
