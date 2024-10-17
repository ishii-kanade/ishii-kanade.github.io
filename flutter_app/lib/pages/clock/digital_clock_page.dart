// TODO Implement this library.
import 'dart:async';
import 'package:flutter/material.dart';

class DigitalClockPage extends StatefulWidget {
  const DigitalClockPage({super.key});

  @override
  _DigitalClockPageState createState() => _DigitalClockPageState();
}

class _DigitalClockPageState extends State<DigitalClockPage> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('デジタル時計'),
      ),
      body: Center(
        child: Text(
          '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
