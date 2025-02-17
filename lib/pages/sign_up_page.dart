import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                      _buildTextField("Username"),
                      _buildTextField("Full Name"),
                      _buildTextField("Email"),
                      _buildPasswordField("Password", true),
                      _buildPasswordField("Confirm Password", false),
                      const SizedBox(height: 20),
                      _buildSignUpButton(),
                      const SizedBox(height: 30),
                      _buildSignInText(),
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
              'Create',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w300,
                letterSpacing: 4.0
              ),
            ),
            Text(
              'Account',
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

  Widget _buildTextField(String label) {
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
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildPasswordField(String label, bool isPassword) {
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

  Widget _buildSignUpButton() {
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
        onPressed: () {

        },
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.w700),
        ),
      ),
    ),
  );
  }

  Widget _buildSignInText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignInPage()
                  )
                );
              },
              
              child: const Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

