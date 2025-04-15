import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/service/baseUrl.dart';

class SendMoneyPage extends StatefulWidget {
  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  Map<String, dynamic>? userDetails;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
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
      _showAlertDialog('Something went wrong: $e');
    }
  }

  void _sendMoney() async {
    String phone = _phoneController.text.trim();
    String amount = _amountController.text.trim();
    String pin = _pinController.text.trim();

    if (phone.isEmpty || amount.isEmpty || pin.isEmpty) {
      _showAlertDialog('Please fill in all fields');
      return;
    }

    double parsedAmount = double.tryParse(amount) ?? 0;

    if (parsedAmount < 10) {
      _showAlertDialog("Minimum amount to send is 10 Taka.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('$baseUrl/api/transaction/create-transaction');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "from": "${userDetails?['phone']}",
          "to": phone,
          "amount": parsedAmount,
          "pin": pin,
          "tType": "Send Money",
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        _showSuccessDialog("Money sent successfully.");
      } else {
        _showAlertDialog(data["error"] ?? "Something went wrong");
      }
    } catch (e) {
      _showAlertDialog("Failed to send money. Please check your network.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pushReplacementNamed(context, '/transaction');
              },
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
        backgroundColor: Color(0xFFFFC107),
        title: Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'To',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Enter recipient's phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              Text(
                'Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text(
                'PIN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _pinController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your PIN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _sendMoney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A4CFF),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
