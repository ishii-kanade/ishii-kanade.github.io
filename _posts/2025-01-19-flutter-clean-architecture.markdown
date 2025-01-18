---
layout: post
title: "クリーンアーキテクチャ×Flutter：保守性に優れたシンプルメモアプリの実装例"
date: 2025-01-10
categories: blog
---

クリーンアーキテクチャは、システムの各部品の役割（責務）を明確に分割することで、コードの保守性、テスト容易性、拡張性を向上させる設計手法です。
この記事では、以下のリポジトリを例に、Flutterを用いたクリーンアーキテクチャの実装例を紹介し、各層の具体的な役割と、その設計思想がもたらすメリットについて解説します。

[リポジトリ](https://github.com/ishii-kanade/memoapp)


---

## 1. クリーンアーキテクチャの基本構造

クリーンアーキテクチャでは、一般的に以下の 3 つのレイヤーに分割して設計します。

- **Domain層（ドメイン層）**
  アプリケーションの本質的なビジネスロジックを表現します。ここでは、各エンティティ（概念）の定義やユースケース（業務ルール）を実装し、外部の技術的な実装から独立させます。

- **Data層**
  データの入出力や永続化の実装を担います。ファイル操作、データベース接続、API 通信など、外部環境との連携部分がここに含まれ、Domain層で定義された抽象（リポジトリなど）に対して具体的な実装を提供します。

- **Presentation層（UI層）**
  ユーザーとのインタラクションを担当する部分です。Flutter のウィジェット、状態管理（ChangeNotifier、Bloc、Provider など）を用いて、ユーザー入力を処理し、Domain層のユースケースを呼び出すことで、最新の状態を画面に反映させます。

これらのレイヤーは、原則として内側（Domain層）が最も安定しており、外側（Data層、Presentation層）は変化に柔軟に対応できる設計となっています。Domain層は「何をするか」を定義し、外側は「どうやって実現するか」にフォーカスすることで、システム全体の変更を局所化できます。

### イメージ図

以下は、各レイヤーの関係性を表す Mermaid の図です。

<div class="mermaid">
    graph TD
        A[Presentation 層<br/>UI, Notifier, MemoPage]
        B[Domain 層<br/>MemoEntity, UseCases]
        C[Data 層<br/>MemoModel, DataSource, Repository]

        A -->|UseCase 呼び出し| B
        B -->|抽象化されたリポジトリ| C
</div>

---

## 2. メモアプリの各レイヤーの具体例

ここでは、各層ごとの具体的な役割と実装例を詳しく説明します。

### 2.1 Domain層

#### 役割

- アプリケーションのビジネスルール、つまり「何をするか」を定義します。
- この層は、ユーザーがメモアプリを使って行う基本操作（「メモの記録」「編集」「ピン留め」など）のルールを表現します。
- UI やデータ保存方法など技術的な詳細から独立しているため、将来的な変更に強い設計となります。

#### 主な実装例

- **MemoEntity**
  「メモ」という概念をシンプルに表現します。
  ```dart
  class MemoEntity {
    final String text;
    final bool isPinned;

    const MemoEntity({
      required this.text,
      this.isPinned = false,
    });
  }
  ```
  このクラスは、アプリのビジネスロジックにおける基本モデルであり、どの層からも同じ形で利用されます。

- **ユースケース（GetMemos, SaveMemos）**
  各ユースケースは、具体的な業務処理をカプセル化したクラスです。
  例として、「メモ一覧の取得」を担う `GetMemos` は以下のように定義されます。
  ```dart
  class GetMemos {
    final MemoRepository repository;

    GetMemos(this.repository);

    Future<List<MemoEntity>> call() async {
      return repository.getMemos();
    }
  }
  ```
  ユースケースは、外部の技術的な実装（ファイル操作や API コール）には触れず、ただ「リポジトリ」を通じてデータ操作を行います。

### 2.2 Data層

#### 役割

- Domain層で定義された抽象に対して、具体的なデータ操作を実装します。
- ファイルの読み書き、JSON 変換、データベース接続、API 通信など、外部システムとの連携部分が該当します。
- Data層に実装を集約することで、Domain層は技術的な変更に左右されず、ビジネスロジックだけに集中できます。

#### 主な実装例

- **MemoLocalDataSourceImpl**
  ローカルストレージでファイルから JSON を読み書きする実装例です。
  ```dart
  import 'dart:convert';
  import 'dart:io';
  import 'package:path_provider/path_provider.dart';

  class MemoLocalDataSourceImpl implements MemoLocalDataSource {
    Future<File> _getMemoFile() async {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/memos.json');
    }

    @override
    Future<List<Map<String, dynamic>>> loadMemos() async {
      try {
        final file = await _getMemoFile();
        if (await file.exists()) {
          final content = await file.readAsString();
          final List<dynamic> jsonList = jsonDecode(content);
          return jsonList.cast<Map<String, dynamic>>();
        }
      } catch (e) {
        // 適切なエラーハンドリングを実装
      }
      return [];
    }

    @override
    Future<void> saveMemos(List<Map<String, dynamic>> memos) async {
      try {
        final file = await _getMemoFile();
        final content = jsonEncode(memos);
        await file.writeAsString(content);
      } catch (e) {
        rethrow;
      }
    }
  }
  ```

- **MemoModel**
  Data層における DTO（Data Transfer Object）として、JSON との変換を担当します。
  Domain層の `MemoEntity` を継承することで、ドメインの基本的な属性はそのまま利用しつつ、外部データとの相互変換のためのメソッドを提供します。
  ```dart
  class MemoModel extends MemoEntity {
    const MemoModel({
      required super.text,
      super.isPinned,
    });

    factory MemoModel.fromJson(Map<String, dynamic> json) {
      return MemoModel(
        text: json['text'] as String,
        isPinned: (json['isPinned'] ?? false) as bool,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'text': text,
        'isPinned': isPinned,
      };
    }
  }
  ```

- **MemoRepositoryImpl**
  Domain層で定義されたリポジトリ（抽象）の具象実装です。
  Data層のデータソースからデータを取得し、それを Domain層で利用できる形に変換して返します。また、データの保存も同様に行います。
  ```dart
  class MemoRepositoryImpl implements MemoRepository {
    final MemoLocalDataSource localDataSource;

    MemoRepositoryImpl(this.localDataSource);

    @override
    Future<List<MemoEntity>> getMemos() async {
      final memosJson = await localDataSource.loadMemos();
      return memosJson.map((json) => MemoModel.fromJson(json)).toList();
    }

    @override
    Future<void> saveMemos(List<MemoEntity> memos) async {
      final memoModels = memos.map((entity) {
        return MemoModel(text: entity.text, isPinned: entity.isPinned);
      }).toList();

      final memosJson = memoModels.map((m) => m.toJson()).toList();
      return localDataSource.saveMemos(memosJson);
    }
  }
  ```

### 2.3 Presentation層

#### 役割

- ユーザーとのインタラクションを処理する層です。
- Flutter のウィジェットや状態管理（Notifier、Bloc、Provider など）を用いて、ユーザー入力を受け付け、Domain層のユースケースを呼び出すことでビジネスロジックを実行します。
- UI の変更があっても、ビジネスルール自体は Domain層に集約されているため、改修の範囲を局所化できます。

#### 主な実装例

- **MemoNotifier**
  アプリの状態変更を管理するクラスです。
  例えば、ユーザーが新しいメモを追加したときに、以下のように Domain層のユースケースを呼び出し、状態を更新します。
  ```dart
  import 'package:flutter/foundation.dart';
  import '../../domain/entities/memo_entity.dart';
  import '../../domain/usecases/get_memos.dart';
  import '../../domain/usecases/save_memos.dart';

  class MemoNotifier extends ChangeNotifier {
    final GetMemos getMemosUseCase;
    final SaveMemos saveMemosUseCase;

    MemoNotifier({
      required this.getMemosUseCase,
      required this.saveMemosUseCase,
    });

    List<MemoEntity> memos = [];

    Future<void> loadMemos() async {
      // Domain層のユースケースから取得した結果を List<MemoEntity> 型に変換
      memos = List<MemoEntity>.from(await getMemosUseCase());
      notifyListeners();
    }

    Future<void> addMemo(String text) async {
      memos.add(MemoEntity(text: text));
      await saveMemosUseCase(memos);
      notifyListeners();
    }

    // updateMemo, deleteMemo, togglePin などの実装は同様
  }
  ```
  これにより、ユーザーの操作がビジネスロジックに正しく反映され、UI は常に最新の状態で再描画されます。

- **Flutter Widget（MemoPage）**
  実際の画面表示部分を担当するウィジェットです。
  ここでは、テキスト入力、ボタン、リスト表示などを組み合わせ、MemoNotifier から状態を受け取り、ユーザー操作（メモ追加、編集、削除）をトリガーします。
  ビジネスロジックは直接記述せず、Notifier 経由で Domain層のユースケースを呼び出すことで、設計の分離を実現しています。

---

## 3. 依存関係の逆転とそのメリット

クリーンアーキテクチャで特に注目すべき点のひとつに、**依存関係の逆転の原則**があります。これにより、次のようなメリットが得られます。

- **Domain層の独立性**
  Domain層は、具体的なデータアクセス（Data層）や UI 実装（Presentation層）の詳細に依存せず、抽象（リポジトリのインターフェイスやユースケース）にのみ依存します。
  これにより、例えばデータソースをローカルファイルから API に変更したい場合でも、Domain層のコードを変更する必要がなくなります。

- **テスト容易性**
  Domain層が抽象に依存するため、ユースケースやビジネスロジックの単体テストが容易です。
  モックやスタブを用いて、Data層の具体的な実装を差し替えれば、UI や外部環境に依存せずにロジックだけを検証できます。

- **拡張性の向上**
  将来的に新たな機能（例：メモへのタグ付け、検索機能）を追加する場合でも、既存の Domain層に影響を与えずに、Data層や Presentation層を個別に拡張可能です。
  また、アーキテクチャが層ごとに分離されているため、各層の修正箇所も明確になり、メンテナンス性が向上します。

---

## 4. まとめ

今回のメモアプリの例を通じて、以下のポイントを確認しました。

- **Domain層**
  - アプリの本質的な概念（MemoEntity）やビジネスロジック（ユースケース：GetMemos, SaveMemos）を定義。
  - 技術的な実装から独立しており、変更の影響を受けにくい設計。

- **Data層**
  - JSON変換、ファイル入出力など具体的な実装を担当。
  - Domain層で定義した抽象（リポジトリ）に対する実装を提供し、外部システムとの連携を隠蔽する。

- **Presentation層**
  - UI の構築と状態管理を担当し、ユーザーの入力を Domain層のユースケースに橋渡しする。
  - 画面再描画や操作のトリガーを通じ、常に最新のデータを表示。

- **依存関係の逆転**
  - Domain層が外部の具体的な実装に依存せず、抽象にのみ依存することで、保守性、テスト容易性、拡張性が向上。

このように、各層の明確な分離と依存関係の逆転により、システム全体の変更が局所化され、長期的なメンテナンスや機能拡張が容易になります。
Flutter とクリーンアーキテクチャの組み合わせは、シンプルながらも堅牢なアプリケーション設計を実現する非常に強力なアプローチであり、複雑なビジネスロジックを管理する際にも多大なメリットを提供します。

---
