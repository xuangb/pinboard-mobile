import 'package:flutter/material.dart';
import './sign_in_page.dart';
import './sign_up_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              _buildTitle(),
              const SizedBox(height: 30),
              _buildDescriptionWithDots(),
              const SizedBox(height: 100),
              _buildAuthButtons(context),
              const Spacer(),
              Center(
                child: _buildFooter(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'THE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w100
          ),
        ),
        SizedBox(height: 5),
        Text(
          'COMMUNITY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 15.0,
            fontWeight: FontWeight.w300,
            
          ),
        ),
        Text(
          'PINBOARD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: 8.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionWithDots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // First Column with bullets
            Column(
              children: List.generate(5, (rowIndex) =>
                Row(
                  children: List.generate(3, (colIndex) =>
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        '•',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 10.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second Column with wrapped text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: const Text(
                      'Your digital hub for local news, events, and announcements that keep neighbors connected and informed.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1.0,
                      ),
                      maxLines: null,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'SIGN IN',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SignUpPage(),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'SIGN UP',
            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'THE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w400
          ),
        ),
        Text(
          'COMMUNITY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 10.0,
            fontWeight: FontWeight.w500
          ),
        ),
        Text(
          'PINBOARD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w700
          ),
        ),
        SizedBox(height: 5),
        Text(
          'All Rights Reserved',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
