// import 'package:flutter/material.dart';
// import './pages/sign_in_page.dart';
// import './pages/sign_up_page.dart';


// void main() {
//   runApp(const MyApp());
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6D0900), Color(0xFFD83F31)],
//               begin: Alignment.centerRight,
//               end: Alignment.centerLeft,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 150), // Increased space from the top
//                 _buildTitle(),
//                 const SizedBox(height: 30),
//                 _buildDescriptionWithDots(),
//                 const SizedBox(height: 100),
//                 _buildAuthButtons(context),
//                 const Spacer(),
//                 Center(
//                   child: _buildFooter(),
//                 ),
                
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           'THE',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             letterSpacing: 2.0,
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           'COMMUNITY',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 28,
//             letterSpacing: 4.0,
//           ),
//         ),
//         Text(
//           'PINBOARD',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 4.0,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDescriptionWithDots() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           // First Column with bullets
//           Column(
//             children: List.generate(5, (rowIndex) => // 5 rows of bullets
//               Row(
//                 children: List.generate(3, (colIndex) => // 3 bullets per row
//                   const Padding(
//                     padding: EdgeInsets.only(right: 5.0),
//                     child: Text(
//                       '•',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 7.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Second Column with wrapped text
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Your digital hub for local news, events, and announcements that keep neighbors connected and informed.',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 17,
//                   ),
//                   maxLines: null, // Allow infinite lines if necessary
//                   softWrap: true, // Ensure the text wraps at the boundary
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

//   Widget _buildAuthButtons(BuildContext context) {
//   return Column(
//     children: [
//       OutlinedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SignInPage()),
//           );
//         },
//         style: OutlinedButton.styleFrom(
//           side: const BorderSide(color: Colors.white),
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: const Text(
//           'SIGN IN',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       ),
//       const SizedBox(height: 15),
//       ElevatedButton(
//         onPressed: () => Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (_) => const SignInPage(),
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: const Text(
//           'SIGN UP',
//           style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     ],
//   );
// }

//   Widget _buildFooter() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: const [
//         Text(
//           'THE',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             letterSpacing: 2.0,
//             fontWeight: FontWeight.w400
//           ),
//         ),
//         Text(
//           'COMMUNITY',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             letterSpacing: 10.0,
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         Text(
//           'PIN BOARD',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             letterSpacing: 2.0,
//             fontWeight: FontWeight.w700
//           ),
//         ),
//         SizedBox(height: 5),
//         Text(
//           'All Rights Reserved',
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import './pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
