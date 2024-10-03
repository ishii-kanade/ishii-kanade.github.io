import 'package:flutter/material.dart';
import 'pages/overview_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/video_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'laamile',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansJpTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/112748642?s=400&u=ffb7443a9714c280cbeaf2abc9d0a35f51339129&v=4',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ishii Kanade',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mobile App Developer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // PortfolioPage へのリンクを設定
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OverviewPage()),
                    );
                  },
                  child: const Text('RESUME'),
                ),

                const SizedBox(height: 8),

                // 動画サンプルページへのリンクボタン
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // ボタンの背景色を指定
                  ),
                  child: const Text('Video Subscription Sample'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
