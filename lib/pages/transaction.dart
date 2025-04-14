import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftpay/service/baseUrl.dart';

class TransactionsScreen extends StatefulWidget {

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<TransactionModel> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await getUserDetails();
    await fetchTransactions();
  }

  Map<String, dynamic>? userDetails;

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


  Future<void> fetchTransactions() async {
    final url = Uri.parse('$baseUrl/api/transaction/get-transaction/${userDetails?['phone']}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          transactions = data.map((json) => TransactionModel.fromJson(json, "${userDetails?['phone']}","${userDetails?['role']}")).toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? Center(child: Text("No transactions found"))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(transaction: transactions[index]),
      ),
    );
  }
}

class TransactionModel {
  final String type;
  final String toFrom;
  final String id;
  final double amount;
  final String date;
  final bool isPositive;

  TransactionModel({
    required this.type,
    required this.toFrom,
    required this.id,
    required this.amount,
    required this.date,
    required this.isPositive,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json,  String userPhone, String role) {
    String type = json['tType'];
    double amount = (json['amount'] as num).toDouble();
    String from = json['from'];
    String to = json['to'];
    String displayType = type;
    String toFrom = '';
    bool isPositive = false;

    if (type == 'Fee' && role != 'agent' && userPhone != '01303687632') {
      toFrom = 'Service Charge';
      isPositive = false;
    } else if (type == 'Agent Transaction') {
      if (from == userPhone) {
        displayType = 'Cash Out';
        toFrom = 'To Agent: $to';
        isPositive = false;
      } else {
        displayType = 'Cash In';
        toFrom = 'From Agent: $from';
        isPositive = true;
      }
    } else if (type == 'Send Money') {
      if (from == userPhone) {
        displayType = 'Send Money';
        toFrom = 'To: $to';
        isPositive = false;
      } else {
        displayType = 'Received Money';
        toFrom = 'From: $from';
        isPositive = true;
      }
    } else {
      toFrom = from == userPhone ? 'To: $to' : 'From: $from';
      isPositive = from != userPhone;
    }

    return TransactionModel(
      type: displayType,
      toFrom: toFrom,
      id: json['transactionId'],
      amount: amount,
      date: DateTime.parse(json['createdAt']).toLocal().toString().split(' ')[0],
      isPositive: isPositive,
    );
  }

}

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isPositive = transaction.amount > 0;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              transaction.isPositive ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.isPositive ? Colors.green : Colors.red,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.type, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text(transaction.toFrom, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 4),
                  Text("ID: ${transaction.id}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  SizedBox(height: 2),
                  Text(transaction.date, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            Text(
              "${transaction.isPositive ? '+' : '-'} ৳${transaction.amount.abs()}",
              style: TextStyle(
                color: transaction.isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
