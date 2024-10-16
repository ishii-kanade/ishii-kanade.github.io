# ベースイメージとしてFlutterを指定
FROM cirrusci/flutter:latest

# 必要な追加のパッケージをインストール
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    lib32stdc++6 \
    libglu1-mesa

# Flutter SDKのパスを設定
ENV PATH="$PATH:/flutter/bin"
