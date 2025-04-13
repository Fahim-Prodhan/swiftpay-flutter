import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/pages/transaction.dart';
import 'package:swiftpay/service/baseUrl.dart';
import 'cash_out.dart';
import 'recharge.dart';
import 'send_money.dart';  // Import the SendMoneyPage
import 'profile.dart';  // Import the ProfilePage

class HomePage extends StatefulWidget {

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  int _currentIndex = 0; // To keep track of selected item
  bool _isBalanceVisible = false;  // Control balance visibility

  // Function to handle Bottom Navigation Bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to Profile Page when Profile tab is selected
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),  // Navigate to ProfilePage
      );
    } if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransactionsScreen()),  // Navigate to ProfilePage
      );
    }
  }

  // Function to build a square button with white icons and border radius
  Widget _buildSquareButton(BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF6A4CFF), // Button color
        padding: EdgeInsets.all(16), // Padding for the button
        shape: RoundedRectangleBorder( // Square button shape with border radius
          borderRadius: BorderRadius.circular(12.0), // Rounded corners with radius of 12
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white), // White icons
          Text(
            label,
            style: TextStyle(color: Colors.white), // White text color
          ),
        ],
      ),
    );
  }

  // Function to toggle balance visibility for 1 second
  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = true;
    });

    // Hide the balance after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isBalanceVisible = false;
      });
    });
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Section
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
          // Button Grid with Square Buttons
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),  // Add horizontal padding
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <Widget>[
                  // Send Money Button
                  _buildSquareButton(
                    context,
                    'Send Money',
                    Icons.send,
                        () {
                      // Navigate to the SendMoneyPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SendMoneyPage()),  // Navigate to SendMoneyPage
                      );
                    },
                  ),
                  // Cash Out Button
                  _buildSquareButton(
                    context,
                    'Cash Out',
                    Icons.money_off,
                        () {
                      // Navigate to the CashOutPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CashOutPage()),  // Navigate to CashOutPage
                      );
                    },
                  ),
                  // Recharge Button
                  _buildSquareButton(
                    context,
                    'Recharge',
                    Icons.phone_android,
                        () {
                      // Navigate to the RechargePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RechargePage()),  // Navigate to RechargePage
                      );
                    },
                  ),
                  // Bill Pay Button
                  _buildSquareButton(
                    context,
                    'Bill Pay',
                    Icons.payment,
                        () {
                      print("Bill Pay clicked");
                    },
                  ),
                  // Add Money Button
                  _buildSquareButton(
                    context,
                    'Add Money',
                    Icons.add,
                        () {
                      print("Add Money clicked");
                    },
                  ),
                  // Others Button
                  _buildSquareButton(
                    context,
                    'Others',
                    Icons.more_horiz,
                        () {
                      print("Others clicked");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the selected tab index
        onTap: _onItemTapped, // Handle item taps
        backgroundColor: Color(0xFFFFC107),  // Yellow background color for footer
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.transfer_within_a_station, color: Colors.white), // Icon for Transaction
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),  // Icon for Profile
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
