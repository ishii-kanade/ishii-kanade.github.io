---

layout: post
title: "Clean Architecture × Flutter: An Example Implementation of a Maintainable and Simple Memo App"
date: 2025-01-15
categories: blog

---

Clean Architecture is a design approach that improves code maintainability, testability, and extensibility by clearly dividing the roles (responsibilities) of each component in the system. In this article, we will explain the concept using simple language and avoiding overly technical terms. If you are interested in learning more, please search for the "SOLID principles."

In this article, we introduce an example implementation of Clean Architecture using Flutter. We explain the specific roles of each layer and the benefits of this design philosophy, using the following repository as our example:

[Repository](https://github.com/ishii-kanade/memoapp)

---

## 1. Basic Structure of Clean Architecture

Clean Architecture generally divides the system into the following three layers:

- **Domain Layer**
  This layer represents the core business logic of the application. It includes the definitions of various entities (concepts) and the implementation of use cases (business rules) while staying independent from technical details.

- **Data Layer**
  This layer handles the implementation of data input/output and persistence. It is responsible for file operations, database connections, API communications, etc. It also provides concrete implementations for the abstractions (such as repositories) defined in the Domain layer.

- **Presentation Layer (UI Layer)**
  This layer is responsible for user interactions. It handles user input using Flutter widgets and state management (such as ChangeNotifier, Bloc, Provider, etc.) and calls use cases from the Domain layer to reflect the latest state on the screen.

In this design, the inner layer (Domain layer) is the most stable, while the outer layers (Data and Presentation layers) can adapt more flexibly to changes. The Domain layer defines "what" to do, and the outer layers focus on "how" to do it, thereby localizing changes in the overall system.

### Diagram

Below is a Mermaid diagram showing the relationship between the layers:

<div class="mermaid">
    graph TD
        A[Presentation Layer<br/>UI, Notifier, MemoPage]
        B[Domain Layer<br/>MemoEntity, UseCases, Repository Abstraction]
        C[Data Layer<br/>MemoModel, DataSource, Repository Concrete Implementation]

        A -->|Calls UseCases| B
        B -->|Abstract Repository| C
</div>

---

### An Analogy: Clean Architecture as Movie Production

To make it easier to understand, imagine Clean Architecture in the context of movie production, where each layer’s role is clearly defined, thereby enhancing overall quality and maintainability. Consider the following analogy:

- **Domain Layer (Screenwriter and Director)**
  - **Role:** The screenwriter and director decide the core story, theme, and characters of the movie. They focus on "what" the movie will convey without worrying about the sets or special effects.
  - **Correspondence:** The Domain layer defines the business logic and rules of the app (for example, creating, editing, and deleting memos). It specifies "what" to do, independent of "how" it is implemented later.

- **Data Layer (Art and Special Effects Team)**
  - **Role:** The art and special effects teams are responsible for creating the sets and special effects that bring the director’s vision to life. They focus on the practical aspects of how to realize the story.
  - **Correspondence:** The Data layer implements the concrete data operations (such as file I/O, JSON conversion, database access, or API communication) based on the instructions coming from the Domain layer. It also handles interactions with external systems.

- **Presentation Layer (Actors and Stage Crew)**
  - **Role:** Actors and the stage crew directly communicate the story to the audience. They perform based on the script, ensuring that the audience can follow the narrative.
  - **Correspondence:** The Presentation layer handles direct interactions with the user. It uses Flutter widgets and state management to capture user input and call the Domain layer’s use cases, updating the screen to reflect the latest state.

---

## 2. Examples of Each Layer in the Memo App

Below, we explain the specific roles and implementation examples for each layer.

### 2.1 Domain Layer

#### Role

- This layer defines the business rules of the application—that is, what the app is supposed to do. It delegates the "how" part to other layers, making overall system management easier.
- It captures the fundamental operations of a memo app, such as creating, editing, and pinning memos.
- By remaining independent of technical implementations (UI, data persistence, etc.), it provides a design that is resilient to future changes.

#### Implementation Examples

- **MemoEntity**

  In the Domain layer, `MemoEntity` represents the concept of a memo. It is defined as the basic model used throughout the application’s business logic.

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

- **Use Cases (GetMemos, SaveMemos)**

  Each use case encapsulates a specific business process. For example, the use case for retrieving a list of memos (`GetMemos`) is implemented as follows:

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

  Similarly, `SaveMemos` would use `MemoRepository` to implement memo saving.

- **Dependency Inversion (Abstraction)**

  In the Domain layer, we define the repository interface as an abstraction for data retrieval and storage. This way, the business logic depends only on the abstraction rather than the concrete implementation.

  ```dart
  // domain/repositories/memo_repository.dart
  import '../entities/memo_entity.dart';

  abstract class MemoRepository {
    Future<List<MemoEntity>> getMemos();
    Future<void> saveMemos(List<MemoEntity> memos);
  }
  ```

  This design ensures that the use cases work solely based on the contract defined by the interface, independent of the Data layer's concrete implementations.

### 2.2 Data Layer

#### Role

- The Data layer provides concrete implementations of data operations (such as file I/O, JSON conversion, and API communication) according to the abstractions defined in the Domain layer.
- By consolidating the implementation in the Data layer, the Domain layer remains unaffected by changes to technical details.

#### Key Implementation Examples

- **MemoLocalDataSourceImpl**

  This is an example of an implementation that reads and writes JSON files from local storage.

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
        // Implement appropriate error handling
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

  In the Data layer, the DTO (Data Transfer Object) called `MemoModel` is responsible for converting between JSON and the Domain layer’s `MemoEntity`. It extends `MemoEntity` and simplifies the conversion process with external data.

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

  This concrete implementation of the `MemoRepository` interface (defined in the Domain layer) retrieves data from the Data layer’s data sources, converts it into Domain entities, and vice versa for saving data.

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

### 2.3 A Concrete Example of Dependency Inversion

Since the Domain layer depends only on the abstraction (i.e., the repository interface) and not on the concrete implementations in the Data layer, it is possible to change the data source (for example, from a local file to a cloud service) without modifying the Domain layer or the use cases. Here’s how the dependency inversion works:

1. **Abstraction in the Domain Layer**

   As shown earlier, the Domain layer defines `MemoRepository` as follows:

   ```dart
   // domain/repositories/memo_repository.dart
   import '../entities/memo_entity.dart';

   abstract class MemoRepository {
     Future<List<MemoEntity>> getMemos();
     Future<void> saveMemos(List<MemoEntity> memos);
   }
   ```

2. **Use Case Dependency**

   The use cases rely on this abstraction, so they can operate without knowing the concrete implementation.

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

3. **Concrete Implementation in the Data Layer**

   The Data layer implements the interface using `MemoRepositoryImpl`, which handles the actual data operations. Because the use cases interact with the interface, replacing the implementation is seamless.

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

4. **Dependency Injection in the Presentation Layer**

   In the Presentation layer, the use cases are accessed through dependency injection. For example, the following `MemoNotifier` makes use of the use cases:

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

     // Additional methods like updateMemo, deleteMemo, togglePin can be added
   }
   ```

With this approach, the Domain layer depends only on the repository abstraction, so even if the concrete implementation in the Data layer changes, the business logic and UI (Presentation layer) remain unaffected. This also allows for easily swapping in a mock repository during testing.

### 2.4 Presentation Layer

#### Role

- The Presentation layer handles user interactions. It uses Flutter widgets and state management (Notifier, Bloc, Provider, etc.) to capture user input and call the Domain layer’s use cases.
- Since the business logic is encapsulated in the Domain layer, changes to the UI are localized, making maintenance easier.

#### Key Implementation Examples

- **MemoNotifier**

  This class manages the state in response to user actions. For example, when a user adds a new memo, it calls the Domain layer’s use case to update the state.

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

    // Additional methods like updateMemo, deleteMemo, togglePin can be added
  }
  ```

- **Flutter Widget (MemoPage)**

  This widget is responsible for building the actual UI. It combines text input, buttons, and lists to display the memos based on the state provided by the `MemoNotifier`. For detailed code examples, please refer to [memo_page.dart](https://github.com/ishii-kanade/memoapp/blob/main/lib/presentation/pages/memo_page.dart).

---

## 3. Summary

Using the example of the memo app, we have covered the following key points:

- **Domain Layer**
  - Defines the essential concepts (such as `MemoEntity`) and business logic (use cases like `GetMemos` and `SaveMemos`), keeping it independent from technical implementations.
  - Due to dependency inversion (relying only on the repository abstraction), changes in the Data layer do not affect the business logic.

- **Data Layer**
  - Handles concrete implementations like JSON conversion and file I/O, providing implementations for the abstractions defined in the Domain layer.
  - Even if the implementation changes, the impact on the Domain and Presentation layers remains minimal.

- **Presentation Layer**
  - Responsible for building the UI and managing state. It triggers Domain layer use cases based on user input to always reflect the latest state on the screen.
  - Dependency injection of use cases makes testing and implementation swapping easier.

- **Dependency Inversion**
  - The Domain layer depends only on abstractions (repository interfaces), not on the concrete implementations of the Data or Presentation layers.
  - This allows for easy substitution of implementations (e.g., swapping in a mock repository for testing or replacing a local storage with a cloud service), enhancing the overall maintainability and extensibility of the system.

---

By adopting Clean Architecture, your application is divided into well-defined layers that can adapt flexibly to future changes. In particular, the dependency inversion pattern enables the Domain layer to focus solely on business logic while allowing the Data and Presentation layers to be easily exchanged. We hope that this article serves as a helpful example for both practical implementation and learning about maintainable app design.
