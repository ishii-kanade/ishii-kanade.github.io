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
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2列表示に設定
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 16 / 9, // アスペクト比を16:9に設定
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
                    description:
                        _videoList[index]['description'] ?? 'No Description',
                    videoUrl: _videoList[index]['videoUrl'] ?? '',
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // サムネイル画像（16:9 の比率で表示）
                  AspectRatio(
                    aspectRatio: 16 / 9, // アスペクト比を16:9に設定
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        _videoList[index]['thumbnailUrl'] ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // タイトルと詳細情報
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _videoList[index]['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      _videoList[index]['description'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 動画リストのデータ
  final List<Map<String, String>> _videoList = [
    {
      'title': 'Beautiful Nature in 4K',
      'description':
          'A stunning nature video with beautiful scenery in 4K resolution.',
      'videoUrl':
          'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_5MB.mp4',
      'thumbnailUrl':
          'https://images.pexels.com/photos/3584826/pexels-photo-3584826.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    },
    {
      'title': 'Time-lapse of City Traffic',
      'description':
          'A mesmerizing time-lapse video showcasing city traffic at night.',
      'videoUrl':
          'https://player.vimeo.com/external/412840922.hd.mp4?s=57e5b96c61dc391d89e6639629f5971b2c2df83e&profile_id=174',
      'thumbnailUrl':
          'https://images.pexels.com/photos/255379/pexels-photo-255379.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    },
    {
      'title': 'Relaxing Beach Waves',
      'description':
          'Enjoy the soothing sound and visuals of waves gently hitting the beach.',
      'videoUrl':
          'https://player.vimeo.com/external/143984392.hd.mp4?s=1890b21e48b8fa07c34ba67c71f0515b98b4a86c&profile_id=174',
      'thumbnailUrl':
          'https://images.pexels.com/photos/240225/pexels-photo-240225.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    },
    {
      'title': 'Forest Waterfall',
      'description':
          'Experience the tranquility of a hidden waterfall deep in the forest.',
      'videoUrl':
          'https://player.vimeo.com/external/310883155.hd.mp4?s=b60707a7f4c306a3aa53d02878a06b7fa5e6b2e1&profile_id=174',
      'thumbnailUrl':
          'https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    },
    {
      'title': 'Sunset Over the Mountains',
      'description':
          'Watch the sun set over a mountain range with dramatic clouds.',
      'videoUrl':
          'https://player.vimeo.com/external/279424607.hd.mp4?s=36b22e7b9ad57e2bb3c5c92d55b3a2e03c9b7c17&profile_id=174',
      'thumbnailUrl':
          'https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    },
  ];
}
