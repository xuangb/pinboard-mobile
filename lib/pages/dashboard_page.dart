import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './sign_in_page.dart';
import './update_profile.dart';
import './post_page.dart';
import './pinned_page.dart';
import './comment_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  List<Map<String, String>> posts = [];
  Map<int, bool> expandedPosts = {};
  Map<int, bool> pinnedPosts = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose controller to prevent memory leaks
    super.dispose();
  }

  void _addPost(Map<String, String> newPost) {
    setState(() {
      posts.insert(0, newPost); // Insert new post at the top
    });
  }

  void _navigateToPostPage(BuildContext context) async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostPage()),
    );
    if (newPost != null) {
      _addPost(newPost); // Add new post if data is returned
    }
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
            const SizedBox(height: 50),
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
              // Home Button (SVG)
              IconButton(
                icon: SvgPicture.asset("assets/icons/home.svg", width: 30, height: 30),
                onPressed: () {
                  _scrollController.animateTo(
                    0.0, // Scroll to the top
                    duration: const Duration(milliseconds: 500), // Smooth scroll
                    curve: Curves.easeInOut,
                  );
                },
              ),

              const SizedBox(width: 15), 

              // Add Button (Prominent Floating Button)
            IconButton(
              icon: SvgPicture.asset("assets/icons/circle-plus.svg", width: 40, height: 40),
              onPressed: () => _navigateToPostPage(context),
            ),

              const SizedBox(width: 15), 

              // Pin Button (SVG)
              Transform.rotate(
                angle: 0.65, 
                child: IconButton(
                  icon: Icon(
                    Icons.push_pin_outlined,
                    size: 30, 
                  ),
                  color: Colors.white.withOpacity(0.7),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PinnedPage(pinnedPosts: [],),
                    ),
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
            const Text(
              "John Doe Jr.",
              style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2),
            ),
            const SizedBox(width: 5)
          ],
        ),
      ),
    );
  }


  IconButton _buildUpdateProfile(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings, color: Colors.white),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => UpdateProfilePage()),
        );
      },
    );
  }

  Row _buildTitle() {
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
                "BULLETIN",
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

  Expanded _buildPostBox() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: posts.length,
        itemBuilder: (context, index){
          String fullContent = posts[index]["content"]??"";
          bool isExpanded = expandedPosts[index]??false;
          bool isPinned = pinnedPosts[index]?? false;

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
                Text(
                  posts[index]["title"]??"",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 5),

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
                    child: Row(
                      children: [
                        Text(
                          posts[index]["commentCount"]??"24",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CommentPage(
                            post: posts[index], // Pass the selected post
                            comments: [], // Pass an empty list or retrieve comments dynamically
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
                                expandedPosts[index] = !isExpanded;
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
                            size: 24, // Adjust size if needed
                          ),
                          color: Colors.white, // White base to blend with the gradient
                          onPressed: () {
                            setState(() {
                              pinnedPosts[index] = !isPinned; // Toggle pin state
                            });
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
  // Perform logout logic (e.g., Firebase sign out)
  
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your login page
    (route) => false, // Removes all previous routes
  );
}




}

void main() {
  runApp(MaterialApp(
    home: DashboardPage(),
  ));
}
