---
layout: post
title: "クリーンアーキテクチャ×Flutter：保守性に優れたシンプルメモアプリの実装例"
date: 2025-01-15
categories: blog
---

クリーンアーキテクチャは、システムの各部品の役割（責務）を明確に分割することで、コードの保守性、テスト容易性、拡張性を向上させる設計手法です。この記事では、難しい用語はなるべく使わず、できるだけ簡単な言葉で解説していきます。もし詳しく知りたい方は、ぜひ「SOLID原則」で調べてみてください。

この記事では、以下のリポジトリを例に、Flutter を用いたクリーンアーキテクチャの実装例を紹介し、各層の具体的な役割と、その設計思想がもたらすメリットについて解説します。

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
        B[Domain 層<br/>MemoEntity, UseCases, リポジトリの抽象]
        C[Data 層<br/>MemoModel, DataSource, Repository の具象実装]

        A -->|UseCase 呼び出し| B
        B -->|抽象化されたリポジトリ| C
</div>

---

### クリーンアーキテクチャを映画制作に例える

クリーンアーキテクチャを映画制作に例えると、各層の役割が明確に分割され、全体の品質や保守性が向上している様子がイメージしやすくなります。以下のように考えてみてください。

- **Domain層（シナリオライターと監督）**
  - **役割:** 映画の核となるストーリーやテーマ、キャラクターの本質などを決めるのはシナリオライターや監督です。彼らは映画の「何を伝えるか」というビジョンに集中し、どのようなセットや特殊効果を使うかなどは意識しません。
  - **対応例:** Domain層は、アプリの本質的なビジネスロジックやルール（例えば、メモの作成、編集、削除など）を定義します。ここでは「何をするか」が決まっており、そのルールは後でどのように実現されるかには依存しません。

- **Data層（美術や特殊効果チーム）**
  - **役割:** 映画で使われるセットや特殊効果、実際の撮影技術を担当するのが美術や特殊効果のチームです。彼らはシナリオライターや監督のビジョンに沿って、具体的な映像を作り上げます。
  - **対応例:** Data層は、Domain層の指示（つまり、どのようなデータ操作が必要か）に基づいて、実際のデータの読み書きや変換、API 通信などの具体的な技術的実装を行います。ここでは外部システムとの連携も担います。

- **Presentation層（俳優と演出スタッフ）**
  - **役割:** 俳優や演出スタッフは、観客に物語を伝える最前線の存在です。シナリオに基づいて演技をし、観客がストーリーを理解しやすいように演出を行います。
  - **対応例:** Presentation層は、ユーザーと直接対話する部分です。Flutter のウィジェットや状態管理を用いて、ユーザー入力を受け、Domain層のユースケースを呼び出すことでデータを画面に反映します。

---

## 2. メモアプリの各レイヤーの具体例

ここでは、各層ごとの具体的な役割と実装例を詳しく説明します。

### 2.1 Domain層

#### 役割

- アプリケーションのビジネスルール、つまり「何をするか」を定義する層です。「どうやるか」は他の層に任せるため、システム全体が管理しやすくなります。
- この層は、ユーザーがメモアプリで行う「メモの記録」「編集」「ピン留め」などの基本操作のルールを表現します。
- 技術的な実装（UI やデータ保存方法）から独立しているため、将来的な変更に強い設計です。

#### 実装例

- **MemoEntity**

  Domain層で「メモ」という概念を表現するクラスです。アプリ全体のビジネスロジックで利用する基本モデルとして定義されます。

  ```dart
  // domain/entities/memo_entity.dart
  class MemoEntity {
    final String text;
    final bool isPinned;

    const MemoEntity({
      required this.text,
      this.isPinned = false,
    });
  }
  ```

- **ユースケース（GetMemos, SaveMemos）**

  各ユースケースは、業務処理をカプセル化したクラスです。例えば、「メモ一覧の取得」を担当する `GetMemos` の実装例は以下の通りです。

  ```dart
  // domain/usecases/get_memos.dart
  import '../entities/memo_entity.dart';
  import '../repositories/memo_repository.dart';

  class GetMemos {
    final MemoRepository repository;

    GetMemos(this.repository);

    Future<List<MemoEntity>> call() async {
      return await repository.getMemos();
    }
  }
  ```

  ※SaveMemosも同様に、`MemoRepository` を利用して実装します。

- **依存関係の逆転（Dependency Inversion）の抽象**

  Domain層では、データ取得・保存のための抽象としてリポジトリのインターフェースを定義します。これにより、ビジネスロジックは具体的なデータソースの実装に依存せず、抽象に対してのみ依存します。

  ```dart
  // domain/repositories/memo_repository.dart
  import '../entities/memo_entity.dart';

  abstract class MemoRepository {
    Future<List<MemoEntity>> getMemos();
    Future<void> saveMemos(List<MemoEntity> memos);
  }
  ```

  このように定義することで、ユースケースはリポジトリの具象実装（後述する Data層側の実装）に依存せず、インターフェースが提供する契約内容だけで動作するようになります。

### 2.2 Data層

#### 役割

- Domain層の抽象に対して、具体的なデータ操作（ファイル読み書き、JSON変換、データベース接続、API 通信など）を実装します。
- Data層に実装を集約することで、Domain層は技術的な変更に左右されず、ビジネスロジックのみに集中できます。

#### 主な実装例

- **MemoLocalDataSourceImpl**

  ローカルストレージでファイルから JSON を読み書きする実装例です。

  ```dart
  // data/datasources/memo_local_data_source_impl.dart
  import 'dart:convert';
  import 'dart:io';
  import 'package:path_provider/path_provider.dart';

  abstract class MemoLocalDataSource {
    Future<List<Map<String, dynamic>>> loadMemos();
    Future<void> saveMemos(List<Map<String, dynamic>> memos);
  }

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

  Data層における DTO（Data Transfer Object）として JSON との変換を担当します。Domain層の `MemoEntity` を継承し、外部データとの相互変換を簡単に行います。

  ```dart
  // data/models/memo_model.dart
  import '../../domain/entities/memo_entity.dart';

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

  Domain層で定義した `MemoRepository` インターフェースの具体的実装です。Data層のデータソースからデータを取得し、Domain層のエンティティに変換して返します。また、データ保存も同様に行います。

  ```dart
  // data/repositories/memo_repository_impl.dart
  import '../../domain/entities/memo_entity.dart';
  import '../../domain/repositories/memo_repository.dart';
  import '../datasources/memo_local_data_source_impl.dart';
  import '../models/memo_model.dart';

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
      await localDataSource.saveMemos(memosJson);
    }
  }
  ```

### 2.3 依存関係の逆転の具体例

Domain層はリポジトリの抽象（インターフェース）に依存するため、Data層の具象実装に直接依存しません。これにより、たとえばデータの保存先をローカルファイルからクラウドサービスに変更する場合でも、Domain層やユースケースの変更を最小限に抑えることができます。

以下は、依存関係の逆転がどのように動作しているかの例です。

1. **Domain層の抽象**

   すでに示した通り、Domain層では以下のように `MemoRepository` を定義しています。

   ```dart
   // domain/repositories/memo_repository.dart
   import '../entities/memo_entity.dart';

   abstract class MemoRepository {
     Future<List<MemoEntity>> getMemos();
     Future<void> saveMemos(List<MemoEntity> memos);
   }
   ```

2. **ユースケースの依存関係**

   ユースケースはこの抽象に依存しているため、具体的な実装を知らなくても利用できます。

   ```dart
   // domain/usecases/get_memos.dart
   import '../entities/memo_entity.dart';
   import '../repositories/memo_repository.dart';

   class GetMemos {
     final MemoRepository repository;

     GetMemos(this.repository);

     Future<List<MemoEntity>> call() async {
       return await repository.getMemos();
     }
   }
   ```

3. **Data層の具象実装**

   Data層では、`MemoRepositoryImpl` が `MemoRepository` を実装しており、実際のデータ操作を担当します。ユースケースからはインターフェースとして扱われるため、差し替えが容易です。

   ```dart
   // data/repositories/memo_repository_impl.dart
   import '../../domain/entities/memo_entity.dart';
   import '../../domain/repositories/memo_repository.dart';
   import '../datasources/memo_local_data_source_impl.dart';
   import '../models/memo_model.dart';

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
       await localDataSource.saveMemos(memosJson);
     }
   }
   ```

4. **Presentation層での依存性注入**

   Presentation層は、ユースケースを通して Domain層にアクセスします。たとえば、以下のように `MemoNotifier` でユースケースを利用します。

   ```dart
   // presentation/notifiers/memo_notifier.dart
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
       memos = await getMemosUseCase();
       notifyListeners();
     }

     Future<void> addMemo(String text) async {
       memos.add(MemoEntity(text: text));
       await saveMemosUseCase(memos);
       notifyListeners();
     }

     // updateMemo, deleteMemo, togglePin などの追加処理
   }
   ```

このように、Domain層が抽象（インターフェース）のみを知ることで、Data層の具体的な実装が後から変更されても、ユースケースや UI に影響を及ぼさずにシステムの保守性が向上します。また、テスト時にモックのリポジトリを差し替えるなど、柔軟な設計が実現できます。

### 2.4 Presentation層

#### 役割

- ユーザーとのインタラクションを処理する層です。Flutter のウィジェットや状態管理（Notifier、Bloc、Provider など）を用いて、ユーザー入力を受け付け、Domain層のユースケースを呼び出します。
- UI の変更があっても、ビジネスロジック自体は Domain層に集約されているため、改修の範囲が局所化されます。

#### 主な実装例

- **MemoNotifier**

  ユーザー操作に応じた状態管理を行うクラスです。例えば、ユーザーが新しいメモを追加したとき、Domain層のユースケースを呼び出して状態を更新します。

  ```dart
  // presentation/notifiers/memo_notifier.dart
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
      memos = await getMemosUseCase();
      notifyListeners();
    }

    Future<void> addMemo(String text) async {
      memos.add(MemoEntity(text: text));
      await saveMemosUseCase(memos);
      notifyListeners();
    }

    // updateMemo, deleteMemo, togglePin などのメソッドも追加可能
  }
  ```

- **Flutter Widget（MemoPage）**

  実際の画面表示を担当するウィジェットです。テキスト入力、ボタン、リスト表示などを組み合わせ、`MemoNotifier` から最新状態を受け取りユーザーの操作をトリガーします。
  詳細なコード例は [memo_page.dart](https://github.com/ishii-kanade/memoapp/blob/main/lib/presentation/pages/memo_page.dart) を参照してください。

---

## 3. まとめ

今回のメモアプリの例を通じて、以下のポイントを確認しました。

- **Domain層**
  - アプリの本質的な概念（MemoEntity）やビジネスロジック（ユースケース：GetMemos, SaveMemos）を定義し、技術的な実装から独立。
  - 依存関係の逆転により、抽象（リポジトリインターフェース）のみを利用するため、Data層の変更がビジネスロジックに影響を与えない。

- **Data層**
  - JSON変換、ファイル入出力など具体的な実装を担当し、Domain層で定義した抽象に対する実装を提供。
  - 実装が変更されても、Domain層および Presentation層への影響を最小限に抑える設計となっている。

- **Presentation層**
  - UI の構築と状態管理を担当。ユーザーの入力を Domain層のユースケースに橋渡しし、常に最新の状態を画面に反映する。
  - ユースケースを通じた依存注入により、テストや実装差し替えが容易になっている。

- **依存関係の逆転**
  - Domain層は、外部の具体的な実装（Data層や Presentation層）に依存せず、あくまで抽象（リポジトリインターフェース）にのみ依存する設計を採用。
  - この結果、テスト時にモックの実装を差し替えたり、機能拡張やデータソースの変更が容易になり、システム全体の保守性、拡張性が向上します。

---

クリーンアーキテクチャを採用することで、アプリケーションが各層に明確に分割され、将来的な変更にも柔軟に対応できる設計となります。特に依存関係の逆転の仕組みを利用することで、Domain層はビジネスロジックに専念でき、Data層や Presentation層の具体的な実装を簡単に入れ替えることが可能です。この記事が、シンプルなメモアプリの実装例として、実務や学習の参考になれば幸いです。
