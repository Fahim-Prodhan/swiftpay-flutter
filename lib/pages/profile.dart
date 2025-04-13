import 'package:flutter/material.dart';

import 'login.dart';
// Import your LoginPage

class ProfilePage extends StatelessWidget {
  final String name = "Test user";
  final String email = "TestUser@gmail.com";
  final String role = "user";
  final String phone = "01303679371";
  final String address = "N/A";
  final bool isActive = true; // User's active status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC107), // Yellow background for AppBar
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Profile Picture
            CircleAvatar(
              radius: 60,  // Size of the circle
              backgroundImage: AssetImage('assets/images/profile_picture.png'),  // Profile image path
            ),
            SizedBox(height: 20),

            // User Name
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
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

            // Edit Profile Button (Blue)
            ElevatedButton(
              onPressed: () {
                // Handle edit profile action
                print("Edit Profile clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,  // Blue button color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
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

            // Logout Button (Red)
            ElevatedButton(
              onPressed: () {
                // Handle logout action
                print("Logout clicked");

                // Navigate to the LoginPage and remove ProfilePage from the stack
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),  // Navigate to LoginPage
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,  // Red button color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
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
