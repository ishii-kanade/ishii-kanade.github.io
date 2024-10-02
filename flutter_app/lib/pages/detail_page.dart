import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String technology;
  final String duration;
  final String description;

  DetailPage({
    required this.title,
    required this.technology,
    required this.duration,
    required this.description,
  });

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
            SizedBox(height: 16.0),
            Text(
              '使用技術:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(technology, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16.0),
            Text(
              '開発期間:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(duration, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16.0),
            Text(
              '詳細情報:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
