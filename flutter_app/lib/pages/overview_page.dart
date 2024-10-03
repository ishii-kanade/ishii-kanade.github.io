import 'package:flutter/material.dart';
import 'detail_page.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RESUME Overview'),
        backgroundColor: Colors.blue[600],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // 各プロジェクトを表示（プロジェクト名と使用言語のみ）
          _buildProjectItem(
            context,
            title: '医療関連アプリ開発 (iOS)',
            technology: 'Swift, UIKit',
            duration: '期間: 2017年5月 - 2017年10月',
            description: '医療情報の安全な管理とアクセスを提供するiOSアプリの開発。'
                'バックエンドとの連携やユーザーインターフェースの設計を担当。',
          ),
          _buildProjectItem(
            context,
            title: 'ロードサービス関連アプリ開発 (Android/iOS)',
            technology: 'Kotlin, Swift',
            duration: '期間: 2019年5月 - 2019年12月',
            description: 'ロードサービスを提供するアプリのクーポン機能とプッシュ通知機能の設計と実装。',
          ),
          _buildProjectItem(
            context,
            title: '求人サービスアプリケーション開発 (Android)',
            technology: 'Java, Android SDK',
            duration: '期間: 2020年1月 - 2020年4月',
            description: '求人サービスアプリのユーザーインターフェースとエクスペリエンスの全面的な改善。',
          ),
          _buildProjectItem(
            context,
            title: 'ヘルスケアアプリ開発 (Android/Android TV)',
            technology: 'Kotlin, Android SDK',
            duration: '期間: 2020年4月 - 2020年6月',
            description:
                'ヘルスケアコンテンツを提供するAndroid TVアプリの開発。コンテンツ管理システムの設計と実装を主導。',
          ),
          _buildProjectItem(
            context,
            title: 'フィンテックアプリ開発 (Android)',
            technology: 'Kotlin, Android SDK',
            duration: '期間: 2020年6月 - 2020年12月',
            description: '金融技術を活用した支払いシステムの開発。テーマ機能のカスタマイズとユーザービリティの向上に貢献。',
          ),
          _buildProjectItem(
            context,
            title: 'ロケーションベースサービスアプリ開発 (Android)',
            technology: 'Java, Android SDK',
            duration: '期間: 2021年10月 - 2022年1月',
            description: 'ビーコン技術を用いた位置情報サービスの開発。ユーザーの位置に基づいた情報提供機能の設計と実装。',
          ),
          _buildProjectItem(
            context,
            title: 'IoTデバイス管理アプリケーション開発',
            technology: 'Kotlin, Android SDK, Jetpack Compose',
            duration: '期間: 2022年5月 - 2022年8月',
            description: 'IoTデバイスと連携するためのモバイルアプリのインターフェース設計および実装。'
                'ユーザープロファイル管理機能の設計と実装を行いました。',
          ),
          _buildProjectItem(
            context,
            title: 'メディアストリーミングアプリケーション開発 (AndroidTV/FireTV)',
            technology: 'Kotlin, Android SDK, Jetpack Compose',
            duration: '期間: 2022年9月 - 現在',
            description: 'メディアストリーミングサービス向けのアプリケーション開発。'
                'ユーザーインターフェースの改善、システム最適化、および新機能の実装。',
          ),
        ],
      ),
    );
  }

  // プロジェクトアイテムを生成するメソッド
  Widget _buildProjectItem(
    BuildContext context, {
    required String title,
    required String technology,
    required String duration,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(technology),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // タップすると詳細ページに遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                title: title,
                technology: technology,
                duration: duration,
                description: description,
              ),
            ),
          );
        },
      ),
    );
  }
}
