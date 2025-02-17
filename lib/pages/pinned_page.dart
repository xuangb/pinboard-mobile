import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './post_page.dart';
import './update_profile.dart';
import './comment_page.dart';

class PinnedPage extends StatefulWidget {
  final List<Map<String, String>> pinnedPosts;
  
  const PinnedPage({super.key, required this.pinnedPosts});

  @override
  State<PinnedPage> createState() => _PinnedPageState();
}

class _PinnedPageState extends State<PinnedPage> {
  List<Map<String, String>> posts = [];
  Map<int, bool> expandedPosts = {};
  Map<int, bool> pinnedPosts = {};

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
                  _buildBackButton(context),
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
        floatingActionButton: _buildFloatingButtons(context),
    );
  }

  Container _buildFloatingButtons(BuildContext context) {
    return Container(
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
                // Handle Home button action
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
      );
  }

    Container _buildUser() {
    return Container(
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
            style: TextStyle(color: Colors.white, 
            fontSize: 14,
            letterSpacing: 2),
          ),
          const SizedBox(width: 5)
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: 0.65, 
          child: Icon(
            Icons.push_pin_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8), // Spacing between the icon and text
        const Text(
          "Pinned Posts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 3,
            fontWeight: FontWeight.w700,
          ),
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
                  Row(
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



}


void main() {
  runApp(MaterialApp(
    home: PinnedPage(pinnedPosts: [],),
  ));
}


