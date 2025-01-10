---
layout: post
title: "MinescriptでChatGPTを使い、MinecraftをAIに操作させる"
date: 2025-01-10
categories: blog
---

Minecraft内でPythonを用いた自動建築を実現するために、MinescriptとChatGPT APIを組み合わせたプロジェクトを紹介します。

---

## Minescriptとは？

Minescriptは、Minecraft内でPythonスクリプトを実行できるModです。これにより、プレイヤーの位置取得やブロック配置などの操作を簡単にスクリプトで実現できます。

---

## 導入方法

1. **Minecraft Forgeのインストール**
   [Minecraft Forge公式サイト](https://files.minecraftforge.net/)から、対応するバージョンのインストーラをダウンロードしてインストール。

2. **Minescriptの導入**
   MinescriptのJARファイルを[公式サイト](https://minescript.net/)からダウンロードし、`.minecraft/mods`ディレクトリに配置。

3. **Python環境の準備**
   Python3をインストールし、必要なライブラリをインストールします。
   ```bash
   pip install openai
   ```

4. **Minecraftの起動**
   ForgeでMinecraftを起動し、Minescriptが有効であることを確認。

---

## 実装の概要

1. **プレイヤーの位置を取得**
   Minescriptを使用して、プレイヤーの座標情報を取得。

2. **ChatGPT APIを呼び出し**
   取得した座標情報を元に、ChatGPTに建築プランを生成させる。

3. **ブロック配置**
   生成された建築プランに従って、Minecraft内に自動でブロックを配置。

---

## 実際のコード

以下のコードは、プレイヤーの位置を取得し、ChatGPT APIを通じて建築プランを生成するスクリプトの例です。

<script src="https://gist.github.com/ishii-kanade/4939a84f9c476333d517de466e1b8ee0.js"></script>

---

## 実行結果

このスクリプトを実行すると、ChatGPTが生成した建築プランを基に、Minecraft内でAIが自動的にブロックを配置します。例えば、「小さなおしゃれな家を作ってほしい」と指示した場合、以下のような家が完成しました。

```
\minescript-chatgpt 小さなおしゃれな家を作ってほしい
```

<img src="{{ '/assets/images/tiny_house.png' | relative_url }}" alt="小さなおしゃれな家">

建築センスはまだまだみたいですね、、。

---

## 挑戦と課題

- **ChatGPTの出力制御**
  建築プランが複雑すぎる場合、再現が困難。
- **リアルタイム性**
  APIのレスポンス時間がボトルネックとなる場合がある。

---
