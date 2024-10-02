import 'package:flutter/material.dart';
import 'video_detail_page.dart';

class VideoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Subscriptions'),
        backgroundColor: Colors.blue[600],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _videoList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoDetailPage(
                    title: _videoList[index]['title'] ?? 'No Title',
                    description: _videoList[index]['description'] ?? 'No Description',
                    videoUrl: _videoList[index]['videoUrl'] ?? '',
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_videoList[index]['thumbnailUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                _videoList[index]['title'] ?? 'No Title',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final List<Map<String, String>> _videoList = [
  {
    'title': 'Beautiful Nature in 4K',
    'description': 'A stunning nature video with beautiful scenery in 4K resolution.',
    'videoUrl': 'https://www.youtube.com/watch?v=RK1RRVR9A2g&list=PL4Gr5tOAPttJ247vzkv1ZbUEm_YtKLejH',
    'thumbnailUrl': 'https://images.pexels.com/photos/3584826/pexels-photo-3584826.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  },
  {
    'title': 'Time-lapse of City Traffic',
    'description': 'A mesmerizing time-lapse video showcasing city traffic at night.',
    'videoUrl': 'https://player.vimeo.com/external/412840922.hd.mp4?s=57e5b96c61dc391d89e6639629f5971b2c2df83e&profile_id=174',
    'thumbnailUrl': 'https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  },
  {
    'title': 'Relaxing Beach Waves',
    'description': 'Enjoy the soothing sound and visuals of waves gently hitting the beach.',
    'videoUrl': 'https://player.vimeo.com/external/143984392.hd.mp4?s=1890b21e48b8fa07c34ba67c71f0515b98b4a86c&profile_id=174',
    'thumbnailUrl': 'https://images.pexels.com/photos/240225/pexels-photo-240225.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  },
  {
    'title': 'Forest Waterfall',
    'description': 'Experience the tranquility of a hidden waterfall deep in the forest.',
    'videoUrl': 'https://player.vimeo.com/external/310883155.hd.mp4?s=b60707a7f4c306a3aa53d02878a06b7fa5e6b2e1&profile_id=174',
    'thumbnailUrl': 'https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  },
  {
    'title': 'Sunset Over the Mountains',
    'description': 'Watch the sun set over a mountain range with dramatic clouds.',
    'videoUrl': 'https://player.vimeo.com/external/279424607.hd.mp4?s=36b22e7b9ad57e2bb3c5c92d55b3a2e03c9b7c17&profile_id=174',
    'thumbnailUrl': 'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  },
];

}
