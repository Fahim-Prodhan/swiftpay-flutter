import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/pages/login.dart';
import 'package:swiftpay/service/baseUrl.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await getUserDetails();
  }

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
  Widget build(BuildContext context) {
    final name = userDetails?['name'] ?? 'N/A';
    final email = userDetails?['email'] ?? 'N/A';
    final phone = userDetails?['phone'] ?? 'N/A';
    final address = userDetails?['address'] ?? 'N/A';
    final role = userDetails?['role'] ?? 'N/A';
    final isActive = (userDetails?['isActive'] ?? 'false').toString().toLowerCase() == 'true';


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC107),
        title: Text('Profile'),
      ),
      body: userDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage:
              AssetImage('assets/man.png'),
            ),
            SizedBox(height: 20),

            // User Name
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // User Email
            Text(
              email,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Active Status (Green Indicator)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status: ',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ],
            ),
            SizedBox(height: 20),

            // User Role
            Text(
              'Role: $role',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),

            // User Phone Number
            Text(
              'Phone Number: $phone',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),

            // User Address
            Text(
              'Address: $address',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Handle edit profile action
                print("Edit Profile clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
