import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  late final AnimationController _fadeController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
        ..forward();
  late final Animation<double> _fade = CurvedAnimation(
      parent: _fadeController, curve: Curves.easeIn);

  @override
  void dispose() {
    _fadeController.dispose();
    _email.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      // 🔹 TODO: call backend endpoint to send reset link / OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password‑reset link sent! 📧")),
      );
      Navigator.pop(context); // return to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Image.asset("assets/images/signup_bg.png",
              fit: BoxFit.contain, width: double.infinity, height: double.infinity),
        ),
        Container(color: Colors.black.withOpacity(0.7)),

        Center(
          child: FadeTransition(
            opacity: _fade,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Enter your account email",
                          labelStyle: const TextStyle(color: Colors.orange),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.orange)),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Email required" : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _sendResetLink,
                        icon: const Icon(Icons.send),
                        label: const Text("Send Reset Link"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
