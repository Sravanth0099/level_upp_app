import 'package:flutter/material.dart';
import 'package:level_upp/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // Submit form and call backend
  void _submitSignup() async {
    if (_formKey.currentState!.validate()) {
      if (_password.text != _confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match.")),
        );
        return;
      }

      try {
        final response = await AuthService.signupUser(
          firstName: _firstName.text,
          lastName: _lastName.text,
          email: _email.text,
          username: _username.text,
          password: _password.text,
        );

        if (response['msg'] == 'user_created') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful!')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else if (response['error'] == 'email_exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email already exists.')),
          );
        } else if (response['error'] == 'username_exists') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Username already exists.')),
          );
        } else if (response['error'] == 'invalid_email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email format.')),
          );
        } else if (response['error'] == 'weak_password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password is too weak.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup failed. Try again later.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  // Build text fields with validation
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orange),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/signup_bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildTextField(_firstName, "First Name", validator: (v) => v == null || v.isEmpty ? "Required" : null),
                          const SizedBox(height: 16),

                          _buildTextField(_lastName, "Last Name", validator: (v) => v == null || v.isEmpty ? "Required" : null),
                          const SizedBox(height: 16),

                          _buildTextField(
                            _email,
                            "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Email is required";
                              if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            _username,
                            "Username",
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Username is required";
                              if (!RegExp(r"^[a-zA-Z0-9_]{3,}$").hasMatch(value)) {
                                return "Use at least 3 characters, no spaces";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            _password,
                            "Password",
                            obscure: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) return "Password is required";
                              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$')
                                  .hasMatch(value)) {
                                return "8+ chars, upper, lower, number, special char";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          _buildTextField(
                            _confirmPassword,
                            "Confirm Password",
                            obscure: true,
                            validator: (value) =>
                                value != _password.text ? "Passwords do not match" : null,
                          ),
                          const SizedBox(height: 30),

                          ElevatedButton.icon(
                            onPressed: _submitSignup,
                            icon: const Text("🔥"),
                            label: const Text("Start My Journey"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                              textStyle: const TextStyle(fontSize: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
