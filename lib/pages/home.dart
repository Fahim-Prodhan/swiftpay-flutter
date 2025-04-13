import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swiftpay/service/baseUrl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBalance = false;

  void _toggleBalance() {
    setState(() {
      _showBalance = !_showBalance;
    });
  }


  Map<String, dynamic>? userDetails; // Declare at the top of your State class

  Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final Uid = prefs.getString('userId');
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/auth/user/$Uid'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userDetails = data;
        });
      } else {
        throw Exception("User Not Found");
      }
    } catch (e) {
      _showError('Something went wrong: $e');
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
  void initState()  {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavBar(),
      body: Column(
        children: [
          Container(
            color: Colors.amber[300],
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            width: double.infinity,
            child: Column(
              children: [
                Image.network('https://i.ibb.co.com/XZqVVVxv/logo-1.png', height: 60),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _toggleBalance,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _showBalance
                          ? 'Balance: ${userDetails?["balance"] ?? 0} ৳'
                          : 'Check Balance',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  CustomButton(icon: Icons.send, label: "Send Money"),
                  CustomButton(icon: Icons.upload, label: "Cash Out"),
                  CustomButton(icon: Icons.phone_android, label: "Recharge"),
                  CustomButton(icon: Icons.receipt, label: "Bill Pay"),
                  CustomButton(icon: Icons.add, label: "Add Money"),
                  CustomButton(icon: Icons.more_horiz, label: "Others"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CustomButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          // TODO: Implement navigation
        },
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.amber[300],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
