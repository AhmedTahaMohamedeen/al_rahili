import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  static const String route='RateScreen/';
  const RateScreen({Key? key}) : super(key: key);

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقييم')),
    );
  }
}