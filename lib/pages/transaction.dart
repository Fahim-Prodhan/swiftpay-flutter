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
          transactions = data.map((json) => TransactionModel.fromJson(json)).toList();
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

  TransactionModel({
    required this.type,
    required this.toFrom,
    required this.id,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    String type = json['tType'];
    double amount = (json['amount'] as num).toDouble();
    String from = json['from'];
    String to = json['to'];
    String userPhone = from; // You can dynamically use the logged-in phone number here
    String toFrom = (amount > 0 || from == userPhone)
        ? 'To: $to'
        : 'From: $from';

    return TransactionModel(
      type: type,
      toFrom: toFrom,
      id: json['transactionId'],
      amount: amount,
      date: DateTime.parse(json['createdAt']).toLocal().toString().split(' ')[0],
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
      elevation: 2,
      child: ListTile(
        title: Text(transaction.type, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.toFrom.isNotEmpty) Text(transaction.toFrom),
            Text("Transaction ID: ${transaction.id}"),
            Text(transaction.date),
          ],
        ),
        trailing: Text(
          "${isPositive ? '+' : '-'} ৳${transaction.amount.abs()}",
          style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
