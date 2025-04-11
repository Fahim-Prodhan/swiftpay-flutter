import 'package:flutter/material.dart';
import 'package:swiftpay/components/custom_input_field.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  bool obscurePin = true;

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
              Image.network('https://i.ibb.co.com/XZqVVVxv/logo-1.png', height: 60),
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
                onPressed: () {
                  // You can add login validation here later
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Login", style: TextStyle(color: Colors.white)),
              ),

              const SizedBox(height: 10),
              TextButton(onPressed: () {}, child: const Text("Forgot password?")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text("Register", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
