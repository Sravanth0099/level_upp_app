import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Background image that fits the whole screen without cropping
          Center(
            child: Image.asset(
              "assets/images/signup_bg.png",
              fit: BoxFit.contain, // 🔄 Shows full image without cropping
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)), // dark overlay

          // 👋 Welcome content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Welcome to Level Upp",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text("Login"),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text("Sign Up", style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
