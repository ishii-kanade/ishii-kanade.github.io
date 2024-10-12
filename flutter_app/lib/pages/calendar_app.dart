import 'package:flutter/material.dart';

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
      ),
      body: const Center(
        child: Text('Here is a calendar app.'),
      ),
    );
  }
}
