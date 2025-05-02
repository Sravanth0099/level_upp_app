import 'package:flutter/material.dart';
import '../../widgets/level_upp_button.dart'; // Adjust path if needed

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Level Upp',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Your quest begins here!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              LevelUppButton(
                text: 'Start My Journey',
                onPressed: () {
                  // TODO: Add navigation to dashboard screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
