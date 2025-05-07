import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> signupUser({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    var url = Uri.parse('http://127.0.0.1:5000/signup');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "username": username,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser({
    required String identifier,
    required String password,
  }) async {
    var url = Uri.parse('http://127.0.0.1:5000/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "identifier": identifier,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }
}
