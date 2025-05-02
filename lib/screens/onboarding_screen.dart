import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Level Upp',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Start your gamified self-growth journey'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to dashboard later
              },
              child: Text('Begin Quest'),
            ),
          ],
        ),
      ),
    );
  }
}
