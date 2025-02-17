import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './dashboard_page.dart';
import './sign_up_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/auth_controller.dart'; 



class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final _authController = AuthController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleSignIn() async {
    setState(() {
      _isLoading = true;  // Show loading spinner
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    bool success = await _authController.signIn(username, password);

    setState(() {
      _isLoading = false;  // Stop loading spinner
    });

    if (success) {
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid credentials!")),
      );
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
              _buildBackButton(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: _buildTitle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: _buildDotGrid(Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10), 
            ],
          ),
          SizedBox(height: 100),
                    
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75, // Set height
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildFormFields(),
                    const SizedBox(height: 75),
                    _buildSignInButton(context),
                    const SizedBox(height: 40),
                    Center(child: _buildSignUpText(context)),
                    const SizedBox(height: 90),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: _buildDotGrid(Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: _buildFooter(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotGrid(Color color) {
    return Column(
      children: List.generate(
        6,
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
            'Hello',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w300,
              letterSpacing: 4.0
            ),
          ),
          Text(
            'Sign In',
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

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username', style: TextStyle(fontSize: 20, color: Colors.redAccent)),
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Enter your username',
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Password', style: TextStyle(
          fontSize: 20, 
          color: Colors.redAccent)),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context) {
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
          onPressed: _handleSignIn,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'SIGN IN',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }


  Widget _buildSignUpText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New User?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SignUpPage(),
                  ),
                );
              },
              child: const Text(
                'Create Account!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Text(
            'THE',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'COMMUNITY',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              letterSpacing: 10.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'PINBOARD',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 5),
        ],
      );
    }

  Future<void> _signIn(BuildContext context) async {
  final url = Uri.parse('https://your-api-url.com/auth/login'); // Replace with your API URL

  // Sample credentials
  final Map<String, String> credentials = {
    "username": _usernameController.text,  // Make sure you create these controllers
    "password": _passwordController.text,
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(credentials),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login Successful: ${data['token']}");

      // Navigate to the dashboard
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    } else {
      print("Login Failed: ${response.body}");
      _showErrorDialog(context, "Invalid username or password");
    }
  } catch (e) {
    print("Error: $e");
    _showErrorDialog(context, "An error occurred. Please try again.");
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Login Failed"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}


}
