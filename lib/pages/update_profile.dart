import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinboard/controllers/auth_controller.dart';
import './sign_in_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  UpdateProfilePageState createState() => UpdateProfilePageState();
}

class UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = AuthController();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); 

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    userId = await authController.getUserId();
    print("Fetching user for ID: $userId");
    if (userId != null) {
      Map<String, dynamic>? user = await authController.getUserById(userId!);
      print("Fetched user: $user");
      if (user != null) {
        setState(() {
          _usernameController.text = user['userName'] ?? '';
          _fullNameController.text = user['fullName'] ?? '';
          _emailController.text = user['email'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.red),
        );
        return;
      }

      bool success = await authController.updateUser(
        userId!,
        _usernameController.text,
        _fullNameController.text,
        _emailController.text,
        _passwordController.text.isNotEmpty ? _passwordController.text : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? "Profile updated!" : "Update failed"),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
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
                      _buildUser(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 27),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: _buildTitle(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.77,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildTextField("Username", _usernameController),
                      _buildTextField("Full Name", _fullNameController),
                      _buildTextField("Email", _emailController),
                      _buildPasswordField("Password", _passwordController, true),
                      _buildPasswordField("Confirm Password", _confirmPasswordController, false),
                      const SizedBox(height: 50),
                      _buildUpdateButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

  Widget _buildTitle() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
            Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w300,
                letterSpacing: 4.0
              ),
            ),
          ],
        );
      }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.red,
            letterSpacing: 3.0
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          validator: (value) => value == null || value.isEmpty ? "Field required" : null,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.red,
            letterSpacing: 3.0
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : _obscureConfirmPassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                isPassword
                    ? (_obscurePassword ? Icons.visibility_off : Icons.visibility)
                    : (_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
              ),
              onPressed: () {
                setState(() {
                  if (isPassword) {
                    _obscurePassword = !_obscurePassword;
                  } else {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  }
                });
              },
            ),
            border: const UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
    width: double.infinity,
    height: 60,
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _updateUser,
        child: const Text(
          'Update',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
  }

  Widget _buildUser() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showLogoutDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white),
            ),
            child: const Icon(Icons.account_circle, color: Colors.white, size: 18),
          ),
        ),
        const SizedBox(width: 55),
      ],
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
    MaterialPageRoute(builder: (context) => SignInPage()), // Replace with your login page
    (route) => false, // Removes all previous routes
  );
}

}

