# ベースイメージにDev ContainersのDebianベースイメージを使用
FROM mcr.microsoft.com/devcontainers/base:debian

# Flutterのインストール
RUN apt-get update && apt-get install -y curl git unzip wget lib32stdc++6 libglu1-mesa && \
    git clone https://github.com/flutter/flutter.git /flutter && \
    /flutter/bin/flutter doctor

# 環境変数の設定
ENV PATH="/flutter/bin:/flutter/.pub-cache/bin:${PATH}"
