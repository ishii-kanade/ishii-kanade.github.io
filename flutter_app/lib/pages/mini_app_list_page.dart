import 'package:flutter/material.dart';
import 'package:flutter_app/pages/calendar/calendar_app.dart';
import 'package:flutter_app/pages/timer_app.dart';
import 'package:flutter_app/pages/clock/digital_clock_page.dart';
import 'package:flutter_app/pages/clock/analog_clock_page.dart';

class MiniAppListPage extends StatelessWidget {
  const MiniAppListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini App List'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          ListTile(
            title: const Text('ミニアプリ 1: タイマー'),
            subtitle: const Text('シンプルなタイマーアプリ'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerApp()),
              );
            },
          ),
          ListTile(
            title: const Text('ミニアプリ 2: カレンダー'),
            subtitle: const Text('カレンダー表示アプリ'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarApp()),
              );
            },
          ),
          ListTile(
            title: const Text('ミニアプリ 3: デジタル時計'),
            subtitle: const Text('現在の時刻を表示するシンプルなデジタル時計'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DigitalClockPage()),
              );
            },
          ),
          ListTile(
            title: const Text('ミニアプリ 4: アナログ時計'),
            subtitle: const Text('現在の時刻を表示するアナログ時計'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnalogClockPage()),
              );
            },
          ),

          // 他のミニアプリも同様に追加できます
        ],
      ),
    );
  }
}
