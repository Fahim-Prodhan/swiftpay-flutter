import 'package:flutter/material.dart';
import 'package:swiftpay/pages/home_page.dart';
import 'package:swiftpay/pages/login.dart';
import 'package:swiftpay/pages/register.dart';
import 'package:swiftpay/pages/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftPay',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) =>  HomePage(),
        '/transaction':(context) => TransactionsScreen(),
      },
    );
  }
}
