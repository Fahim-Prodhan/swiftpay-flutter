import 'package:flutter/material.dart';
import 'cash_out.dart';
import 'recharge.dart';
import 'send_money.dart';  // Import the SendMoneyPage
import 'profile.dart';  // Import the ProfilePage

class HomePage extends StatefulWidget {
  final double balance;

  HomePage({required this.balance});  // Receive balance as a parameter

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Section
          Container(
            width: double.infinity,
            color: Color(0xFFFFC107), // Yellow background
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Logo (Centered)
                Image.asset(
                  'assets/images/swiftpay_logo.png',  // Path to your logo image
                  height: 80,  // Adjust the height of the logo
                ),
                SizedBox(height: 10, width: 10),
                // Balance Display as the title in the header
                GestureDetector(
                  onTap: _toggleBalanceVisibility,  // On tap, toggle balance visibility
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    width: double.infinity,  // Make the container take the full width
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for balance container
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Balance: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _isBalanceVisible
                            ? Text(
                          '${widget.balance} ৳',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : Text(
                          '****', // Placeholder when balance is hidden
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
