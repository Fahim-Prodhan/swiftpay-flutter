import 'package:flutter/material.dart';

class CashOutPage extends StatefulWidget {
  @override
  _CashOutPageState createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  // Function to handle the cash out action
  void _cashOut() {
    String phone = _phoneController.text.trim();
    String amount = _amountController.text.trim();
    String pin = _pinController.text.trim();

    if (phone.isEmpty || amount.isEmpty || pin.isEmpty) {
      _showAlertDialog('Please fill in all fields');
    } else {
      // Handle the cash out process here
      print('Phone: $phone, Amount: $amount, Pin: $pin');
      // Optionally, navigate back or show success
    }
  }

  // Show alert dialog
  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC107), // Yellow background
        title: Text('Cash Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Label for 'To' and Recipient Phone
            Text(
              'To',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            // Recipient Phone
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "Enter agent's phone number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20),

            // Label for 'Amount'
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            // Amount Field
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),

            // Label for 'PIN'
            Text(
              'PIN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            // Pin Field
            TextField(
              controller: _pinController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your PIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 30),
            // Cash Out Button
            ElevatedButton(
              onPressed: _cashOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A4CFF), // SwiftPay button color (purple)
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 150),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
              ),
              child: Text(
                'Cash Out',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // White text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
