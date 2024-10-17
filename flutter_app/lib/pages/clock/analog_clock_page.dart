import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnalogClockPage extends StatefulWidget {
  const AnalogClockPage({Key? key}) : super(key: key);

  @override
  _AnalogClockPageState createState() => _AnalogClockPageState();
}

class _AnalogClockPageState extends State<AnalogClockPage> {
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
        title: const Text('アナログ時計'),
      ),
      body: Center(
        child: Container(
          color: Colors.black, // 背景色を黒に設定
          child: CustomPaint(
            size: const Size(300, 300),
            painter: ClockPainter(_currentTime),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime time;
  ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // 時計の外枠を描画
    canvas.drawCircle(center, radius, borderPaint);

    // 時針を描画
    final hourAngle = (time.hour % 12 + time.minute / 60) * 30 * pi / 180;
    final hourHand = Offset(
      center.dx + 0.5 * radius * cos(hourAngle - pi / 2),
      center.dy + 0.5 * radius * sin(hourAngle - pi / 2),
    );
    final hourPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round; // 端を丸くする
    canvas.drawLine(center, hourHand, hourPaint);

    // 分針を描画
    final minuteAngle = (time.minute + time.second / 60) * 6 * pi / 180;
    final minuteHand = Offset(
      center.dx + 0.7 * radius * cos(minuteAngle - pi / 2),
      center.dy + 0.7 * radius * sin(minuteAngle - pi / 2),
    );
    final minutePaint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round; // 端を丸くする
    canvas.drawLine(center, minuteHand, minutePaint);

    // 秒針を描画
    final secondAngle = time.second * 6 * pi / 180;
    final secondHand = Offset(
      center.dx + 0.9 * radius * cos(secondAngle - pi / 2),
      center.dy + 0.9 * radius * sin(secondAngle - pi / 2),
    );
    final secondPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round; // 端を丸くする
    canvas.drawLine(center, secondHand, secondPaint);

    // 時計の中心点を描画
    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5.0, centerDotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
