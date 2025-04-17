import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/service/baseUrl.dart';

import '../components/custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isUser = true;
  bool obscurePin = true;
  bool isLoading = false;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();



  Future<void> registerUser() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final pin = pinController.text.trim();
    final role = isUser ? "user" : "agent";
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || pin.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final body = {
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "pin": pin,
        "role": role,
      };
      final res = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode >= 400 || data['error'] != null) {
        throw Exception(data['error'] ?? "Something went wrong");
      }

      print(jsonEncode(data["_id"]));

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', data['_id']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      Navigator.pushNamed(context, "/home"); // Change to your desired screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _roleButton(String role, bool active) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isUser = role == 'User';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.orange : Colors.grey[300],
        foregroundColor: active ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(role),
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
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 20),
              const Text('Register', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomInputField(
                label: "Full Name",
                controller: fullNameController,
                hintText: "Enter full name",
              ),
              CustomInputField(
                label: "Email",
                controller: emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),
              CustomInputField(
                label: "Phone",
                controller: phoneController,
                hintText: "Enter your phone number",
                keyboardType: TextInputType.phone,
              ),
              CustomInputField(
                label: "PIN",
                controller: pinController,
                hintText: "Your 5-digit pin",
                keyboardType: TextInputType.number,
                obscureText: obscurePin,
                suffixIcon: IconButton(
                  icon: Icon(obscurePin ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscurePin = !obscurePin;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _roleButton('User', isUser),
                  const SizedBox(width: 12),
                  _roleButton('Agent', !isUser),
                ],
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Register", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: const Text("Login", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
