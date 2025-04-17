import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/components/custom_input_field.dart';
import 'package:swiftpay/service/baseUrl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool obscurePin = true;
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final pin = pinController.text.trim();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': email, 'password': pin}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Save to local storage
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', data['_id']);
        // Navigate or show success
        print("Login successful! User ID saved: ${data['_id']}");
        Navigator.pushReplacementNamed(context, '/home'); // Optional
      } else {
        final error = jsonDecode(response.body);
        _showError(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      _showError('Something went wrong: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Image(image: AssetImage('assets/logo.png'),height: 100,),
              const SizedBox(height: 30),
              const Text('Login', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              CustomInputField(
                label: "Phone/Email",
                controller: emailController,
                hintText: "Enter phone/email",
              ),
              CustomInputField(
                label: "PIN",
                controller: pinController,
                hintText: "Your 5-digit pin",
                obscureText: obscurePin,
                keyboardType: TextInputType.number,
                suffixIcon: IconButton(
                  icon: Icon(obscurePin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscurePin = !obscurePin;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(onPressed: () {}, child: const Text("Forgot password?")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
