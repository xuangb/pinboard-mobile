//dependencies
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:pinboard/controllers/auth_controller.dart';

//pages
import './sign_in_page.dart';
import './update_profile.dart';
import './post_page.dart';
import './pinned_page.dart';
import './comment_page.dart';

//controllers
import '../controllers/user_controller.dart';
import '../controllers/post_controller.dart';
import '../controllers/pinpost_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  final PostController _postController = PostController();
  final AuthController _authController = AuthController();
  final PinPostController _pinPostController = PinPostController();

  List<Map<String, dynamic>> posts = [];
  Map<String, bool> expandedPosts = {};
  List<Map<String, dynamic>> pinnedPosts = [];
  String _userName = "Loading....";
  String _userId = "0";


  @override
  void dispose() {
    _scrollController.dispose(); 
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _loadUserName();
_fetchPostsAndPinned();
    _checkConnection();
  }

  void _checkConnection() async {
    bool isConnected = await _postController.verifyConnection();
    print('API Connection status: ${isConnected ? 'Success' : 'Failed'}');
  }

  void _loadUserName() async {
    String? name = await _authController.getFullName();
    String? userId = await _authController.getUserId();

    setState(() {
      _userName = name ?? "Unknown User";
      _userId = userId ?? "0"; // Correct assignment
    });
    print("User name: $_userName");
    print("User ID: $_userId");
  }

  // void _fetchPosts() async {
  //   List<dynamic> fetchedPosts = await _postController.fetchPosts();
  //   setState(() {
  //     posts = List<Map<String, dynamic>>.from(fetchedPosts);
  //   });
  //   _loadUserName();
  //   _fetchPinnedPosts();
  // }

  // void _fetchPinnedPosts() async {
  //   print("Fetching pinned posts for User ID: $_userId");
  //   List<dynamic> fetchPinnedPosts = await _pinPostController.getPinnedPosts(_userId);
  //   setState(() {
  //     pinnedPosts = List<Map<String, dynamic>>.from(fetchPinnedPosts);
  //   });
  //   print("fetched pinned: $pinnedPosts");
  // }

  void _fetchPostsAndPinned() async {
  // Fetch posts first
  List<dynamic> fetchedPosts = await _postController.fetchPosts();
  setState(() {
    posts = List<Map<String, dynamic>>.from(fetchedPosts);
  });

  // Then fetch pinned posts
  List<dynamic> fetchedPinnedPosts = await _pinPostController.getPinnedPosts(_userId);
  setState(() {
    pinnedPosts = List<Map<String, dynamic>>.from(fetchedPinnedPosts);
  });

  print("fetched pinned: $pinnedPosts");
}

  void _togglePinStatus(String postId) async {
  bool isPinned = pinnedPosts.any((post) => post["postId"] == postId);

  if (isPinned) {
    await _pinPostController.unpinPost(postId, _userId);
  } else {
    await _pinPostController.pinPost(postId, _userId);
  }

  // Refresh the pinned posts to reflect the changes
  _fetchPostsAndPinned();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildUser(),
                  _buildUpdateProfile(context),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _buildTitle(),
            const SizedBox(height: 10),
            _buildPostBox(),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 10), // Adjust position
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black, // Semi-transparent white
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SvgPicture.asset("assets/icons/home.svg", width: 25, height: 25),
                onPressed: () {
                  _scrollController.animateTo(
                    0.0, 
                    duration: const Duration(milliseconds: 500), 
                    curve: Curves.easeInOut,
                  );
                  _fetchPostsAndPinned();
                },
              ),
            const SizedBox(width: 15), 

            IconButton(
              icon: SvgPicture.asset("assets/icons/circle-plus.svg", width: 28, height: 28),
              onPressed: () => 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostPage(userId: _userId,)),
              )
            ),

              const SizedBox(width: 15), 
              Transform.rotate(
                angle: 0.65, 
                child: IconButton(
                  icon: Icon(
                    Icons.push_pin_outlined,
                    size: 25, 
                  ),
                  color: Colors.white.withOpacity(0.7),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PinnedPage()),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildUser() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_circle, color: Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(
              "$_userId $_userName",
              style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2),
            ),
            const SizedBox(width: 5)
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateProfile(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined, color: Colors.white),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => UpdateProfilePage()),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "THE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const Text(
                "COMMUNITY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 10,
                ),
              ),
              const Text(
                "PIN BOARD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0), 
          child: _buildDotGrid(Colors.white), 
        ),
      ],
    );
  }

  Widget _buildPostBox() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        controller: _scrollController,
        itemCount: posts.length + 1,
        itemBuilder: (context, index){
          if(index == posts.length){
            return const SizedBox(height: 80);
          }

          String fullContent = posts[index]["content"]??"";
          final post = posts[index];
          final postId = post["postId"];

          bool isExpanded = expandedPosts[postId]??false;
          bool isPinned = pinnedPosts.any((post)=>post["id"] == postId);

          return Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle, color: Colors.black, size: 18),
                        Text(
                          posts[index]["user"]?["fullName"]??"",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500)
                        ),
                      ],
                    ),
                    Text(
                      getRelativeTime(posts[index]["dateCreated"] ?? DateTime.now().toString()),
                      style:TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  posts[index]["title"]??"",
                  style:TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 10),
                Text(
                  fullContent,
                  maxLines: isExpanded ? null: 3,
                  overflow: isExpanded ? TextOverflow.visible: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 3),
                          SvgPicture.asset(
                            "assets/icons/chat-bubble.svg",
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 5), // Space between icon and label
                          const Text(
                            "Comments",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CommentPage(
                            postId: postId, 
                          ),
                        ),
                      );
                    },
                  ),

                    LayoutBuilder(
                      builder: (context, constraints){
                      final textSpan = TextSpan(
                        text: fullContent,
                        style: const TextStyle(fontSize: 14),
                      );
                      
                      final textPainter = TextPainter (
                        text: textSpan,
                        maxLines: 3,
                        textDirection: TextDirection.ltr,
                      );

                      textPainter.layout(maxWidth: constraints.maxWidth);
                      
                      if (textPainter.didExceedMaxLines) {
                          return TextButton(
                            onPressed: () {
                              setState(() {
                                expandedPosts[postId] = !isExpanded;
                              });
                            },
                            child: Text(
                              isExpanded ? "View Less" : "View More",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        }
                        return const SizedBox();
                    }
                    ),
                    Transform.rotate(
                      angle: 0.65, // Tilt the pin diagonally (adjust as needed)
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: isPinned
                                ?  [Color(0xFF6D0900), Color(0xFFD83F31)] // Pinned gradient
                                : [Colors.black, Colors.black], // Default gradient
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ).createShader(bounds);
                        },
                        child: IconButton(
                          icon: Icon(
                            isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                            size: 24, 
                            color: isPinned ? const Color(0xFFD83F31) : Colors.black54,
                          ),
                          color: Colors.white, // White base to blend with the gradient
                          onPressed: () {
                            _togglePinStatus(postId);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDotGrid(Color color) {
    return Column(
      children: List.generate(
        3,
        (rowIndex) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (colIndex) => Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Text(
                '•',
                style: TextStyle(
                  color: color, // Use the passed color
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 10.0,
                ),
              ),
            ),
          ),
        ),
      ),
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

  void _logout() async {
    await _authController.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (route) => false,
    );
  }

}