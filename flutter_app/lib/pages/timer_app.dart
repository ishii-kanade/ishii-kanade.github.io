import 'package:flutter/material.dart';

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
      ),
      body: const Center(
        child: Text('Here is a simple timer app.'),
      ),
    );
  }
}
