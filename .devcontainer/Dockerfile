# Flutterの公式Dockerイメージをベースにする
FROM cirrusci/flutter:latest

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    google-chrome-stable \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    curl \
    unzip \
    git \
    lib32stdc++6 \
    libglu1-mesa

# Chromeの環境変数を設定
ENV CHROME_EXECUTABLE=/usr/bin/google-chrome

# Android SDKの設定（既にFlutterイメージに含まれているが確認）
RUN flutter doctor --android-licenses

# Flutterのアップグレードとチャンネルの設定
RUN flutter channel stable && flutter upgrade

# デフォルトの作業ディレクトリを設定
WORKDIR /workspace

# 必要なポートを公開
EXPOSE 3000 8080
