import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  final List<TransactionModel> transactions = [
    TransactionModel(type: 'Send Money', toFrom: 'To: 01568451182', id: 'SFTID-140779', amount: -100, date: '11/15/2024'),
    TransactionModel(type: 'Fee', toFrom: '', id: 'SFTID-122464', amount: -5, date: '11/15/2024'),
    TransactionModel(type: 'Send Money', toFrom: 'From: 01568451182', id: 'SFTID-122164', amount: 100, date: '11/15/2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
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
  final int amount;
  final String date;

  TransactionModel({
    required this.type,
    required this.toFrom,
    required this.id,
    required this.amount,
    required this.date,
  });
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