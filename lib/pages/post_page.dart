import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinboard/controllers/post_controller.dart';
import 'package:intl/intl.dart';
import './sign_in_page.dart';

class PostPage extends StatefulWidget {
  final String userId;
  const PostPage({super.key, required this.userId});

  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  final PostController _postController = PostController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate;

  bool _isPosting = false;

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitPost() async{
    if(_titleController.text.isEmpty || _contentController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Content are required")),
      );
      return;
    }

    setState(() => _isPosting = true);

    String formattedDate = _selectedDate != null
      ? DateFormat ('yyyy-MM-dd').format(_selectedDate!)
      : DateFormat('yyyy-MM-dd').format(DateTime.now());

    bool success = await _postController.createPost(
      userId: widget.userId, 
      title: _titleController.text, 
      content: _contentController.text, 
      date: formattedDate, 
      location: _locationController.text.isNotEmpty ?_locationController.text: "No Location",
    );

    setState(() => _isPosting = false);

    if(success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post Created Successfully")),
      );
      Navigator.pop(context);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create post. Please try again.")),
      );
    }

  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: LayoutBuilder( 
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _buildBackButton(context),
                        ],
                      ),
                      Column(
                        children: [
                          _buildUser()
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    "Create a post...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 10),
                  _buildTitleField(),
                  const SizedBox(height: 10),
                  _buildContentField(),
                  const SizedBox(height: 30),
                  _buildOptionalText(),
                  const SizedBox(height: 25),
                  _buildEventText(),
                  const SizedBox(height: 5),
                  _buildDateField(context),
                  const SizedBox(height: 30),
                  _buildLocationText(),
                  _buildLocationField(),
                  const SizedBox(height: 90),

                
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildPostButton(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

  SizedBox _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitPost,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Button background color
          foregroundColor: Colors.white, // Text color
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            side: BorderSide(color: Colors.white, width: 1), // Red border
          ),
        ),
        child: const Text("Post", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
      ),
    );
  }

  TextField _buildLocationField() {
    return TextField(
      controller: _locationController,
      decoration: InputDecoration(
        hintText: "Type here...",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.location_on, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black, width: 6)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.black, width: 2), // Normal state border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.redAccent, width: 2), // When clicked (focused)
          ),
      ),
    );
  }

  Text _buildLocationText() {
    return const Text(
      "Location",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextField _buildDateField(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () => _pickDate(context),
      decoration: InputDecoration(
        hintText: _selectedDate != null
            ? "${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}"
            : "Select event date",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.calendar_today, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.black, width: 6)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.black, width: 2), // Normal state border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.redAccent, width: 2), // When clicked (focused)
          ),
      ),
    );
  }

  Text _buildEventText() {
    return const Text(
      "Event Date",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _buildOptionalText() {
    return const Text(
      "Additional Information (optional)",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  TextField _buildContentField() {
    return TextField(
      controller: _contentController,
      style: TextStyle(color: Colors.white),
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Content here...",
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white, width: 2), // Normal state border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.redAccent, width: 2), // When clicked (focused)
          ),
      ),
    );
  }

  TextField _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Add a title...",
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: Colors.white, width: 6)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.white, width: 2), // Normal state border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.redAccent, width: 2), // When clicked (focused)
          ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Moves button to the leftmost side
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0), // Remove extra padding
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
                  'assets/icons/back-icon.svg',
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
      ),
    );
  }

  Widget _buildUser() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()), 
      (route) => false, 
    );
  }

}
