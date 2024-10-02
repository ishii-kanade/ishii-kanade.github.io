// lib/portfolio_page.dart

import 'package:flutter/material.dart';

// ポートフォリオのページ
class PortfolioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // 自己紹介セクション
              _buildSectionTitle('自己紹介'),
              Text(
                'フリーランスのモバイルアプリ開発者で、AndroidとiOSの両プラットフォームに対応したアプリケーション開発の経験が豊富です。'
                '多角的な視野で物事を捉え、ユーザー中心の設計とパフォーマンスの最適化を重視し、様々な業界で広範な経験を持ちます。',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // 技術スキルセクション
              _buildSectionTitle('技術スキル'),
              _buildSkillList([
                'プログラミング言語: Java, Kotlin, Swift',
                'フレームワークとライブラリ: Android SDK, iOS UIKit, Firebase, Retrofit, Dagger',
                'ツールとプラットフォーム: Android Studio, Xcode, GitLab, Jenkins, CircleCI',
              ]),
              SizedBox(height: 20),

              // プロジェクト経験セクション
              _buildSectionTitle('プロジェクト経験'),
              _buildProjectCard(
                '医療関連アプリ開発 (iOS)',
                '期間: 2017年5月 - 2017年10月',
                '技術: Swift, UIKit, CoreData, Alamofire',
                '医療情報の安全な管理とアクセスを提供するiOSアプリの開発。バックエンドとの連携やユーザーインターフェースの設計を担当。',
              ),
              _buildProjectCard(
                'ロードサービス関連アプリ開発 (Android/iOS)',
                '期間: 2019年5月 - 2019年12月',
                '技術: Kotlin, Swift, Android SDK, Firebase',
                'ロードサービスを提供するアプリのクーポン機能とプッシュ通知機能の設計と実装。',
              ),
              _buildProjectCard(
                '求人サービスアプリケーション開発 (Android)',
                '期間: 2020年1月 - 2020年4月',
                '技術: Java, Android SDK, Firebase',
                '求人サービスアプリのユーザーインターフェースとエクスペリエンスの全面的な改善。',
              ),
              _buildProjectCard(
                'ヘルスケアアプリ開発 (Android/Android TV)',
                '期間: 2020年4月 - 2020年6月',
                '技術: Kotlin, Android SDK, Firebase',
                'ヘルスケアコンテンツを提供するAndroid TVアプリの開発。コンテンツ管理システムの設計と実装を主導。',
              ),
              _buildProjectCard(
                'フィンテックアプリ開発 (Android)',
                '期間: 2020年6月 - 2020年12月',
                '技術: Kotlin, Android SDK, Retrofit, Dagger',
                '金融技術を活用した支払いシステムの開発。テーマ機能のカスタマイズとユーザービリティの向上に貢献。',
              ),
              _buildProjectCard(
                'ロケーションベースサービスアプリ開発 (Android)',
                '期間: 2021年10月 - 2022年1月',
                '技術: Java, Android SDK, Retrofit, Firebase',
                'ビーコン技術を用いた位置情報サービスの開発。ユーザーの位置に基づいた情報提供機能の設計と実装。',
              ),
              _buildProjectCard(
                'IoTデバイス管理アプリケーション開発',
                '期間: 2022年5月 - 2022年8月',
                '技術: Kotlin, Android SDK, Jetpack Compose, Retrofit, Dagger/Hilt',
                'IoTデバイスと連携するためのモバイルアプリのインターフェース設計および実装。ユーザープロファイル管理機能の設計と実装を行いました。',
              ),
              _buildProjectCard(
                'メディアストリーミングアプリケーション開発 (AndroidTV/FireTV)',
                '期間: 2022年9月 - 現在',
                '技術: Kotlin, Android SDK, Jetpack Compose, OkHttp, Retrofit',
                'メディアストリーミングサービス向けのアプリケーション開発。ユーザーインターフェースの改善、システム最適化、および新機能の実装。',
              ),
            ],
          ),
        ),
      ),
      // フッター
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[600],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© 2024 laamile',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // セクションタイトル用のウィジェット
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue[600],
      ),
    );
  }

  // スキルリスト用のウィジェット
  Widget _buildSkillList(List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skills.map((skill) => Text('• $skill', style: TextStyle(fontSize: 16))).toList(),
    );
  }

  // プロジェクトカード用のウィジェット
  Widget _buildProjectCard(String title, String duration, String technology, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[500],
              ),
            ),
            SizedBox(height: 8.0),
            Text(duration, style: TextStyle(color: Colors.grey[600])),
            Text(technology, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 8.0),
            Text(description, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}