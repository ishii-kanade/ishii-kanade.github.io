import 'package:flutter/material.dart';
import 'video_player_page.dart';

class VideoDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String videoUrl;

  const VideoDetailPage(
      {super.key,
      required this.title,
      required this.description,
      required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Watch Video'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
