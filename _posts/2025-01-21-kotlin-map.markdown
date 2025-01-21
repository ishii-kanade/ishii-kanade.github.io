---
layout: post
title: "Kotlin: Map と ConcurrentHashMap の違いと比較"
date: 2025-01-21
categories: blog
---

## ConcurrentHashMapとCollections.synchronizedMapの違いについて

JavaでスレッドセーフなMapを実現する方法として、`ConcurrentHashMap`と`Collections.synchronizedMap`の2つが挙げられます。どちらもマルチスレッド環境下で安全にMapを操作できますが、内部実装やパフォーマンス特性に違いがあります。

### synchronizedMap

- `Collections.synchronizedMap`は、既存のMap（例: HashMap）をラップしてスレッドセーフにします。
- Map全体に1つのロックをかけるため、複数のスレッドが同時にアクセスしようとすると、ロック競合が発生し、パフォーマンスが低下する可能性があります。
- Java 1.2で導入されました。

### ConcurrentHashMap

- `ConcurrentHashMap`は、最初からスレッドセーフとして設計されたMapです。
- 内部的に複数のロックを使用する「ロックストライピング」と呼ばれる技術を採用し、複数のスレッドが同時にMapの異なる部分にアクセスできるようにすることで、ロック競合を軽減し、パフォーマンスを向上させています。
- Java 1.5で導入されました。

### パフォーマンス

一般的に、`ConcurrentHashMap`は`Collections.synchronizedMap`よりも高いパフォーマンスを発揮します。特に、競合が多い状況では、`ConcurrentHashMap`の方が大幅に高速です。

### 機能

- `ConcurrentHashMap`は、`Collections.synchronizedMap`にはない、アトミックな操作や並行処理に特化したメソッドを提供しています。
    - 例: `putIfAbsent`, `computeIfAbsent`, `forEach` など

### 反復処理

- `Collections.synchronizedMap`は、反復処理中にMapが変更されると`ConcurrentModificationException`をスローします。
- `ConcurrentHashMap`は、反復処理中でもMapの変更を許容し、`ConcurrentModificationException`をスローしません。

実験コード
<iframe src="https://pl.kotl.in/2Wusqe9ub"></iframe>

### まとめ

- スレッドセーフなMapが必要な場合は、`ConcurrentHashMap`を使用することをお勧めします。
- `ConcurrentHashMap`は、`Collections.synchronizedMap`よりも高いパフォーマンスと、より豊富な機能を提供します。
- `Collections.synchronizedMap`は、既存のMapを簡単にスレッドセーフにする場合に便利です。

| 機能 | ConcurrentHashMap | Collections.synchronizedMap |
|---|---|---|
| スレッドセーフ | ○ | ○ |
| パフォーマンス | 高い | 低い |
| ロック方式 | ロックストライピング | Map全体をロック |
| 並行処理向けメソッド | ○ | × |
| 反復処理中の変更 | 許容 | `ConcurrentModificationException` |
| 導入バージョン | Java 1.5 | Java 1.2 |
