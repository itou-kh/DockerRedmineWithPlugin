FROM redmine:5.1

# 必要なパッケージをインストール
USER root
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# プラグインディレクトリに移動
WORKDIR /usr/src/redmine/plugins

# Mermaidプラグインをインストール
RUN git clone https://github.com/redmica/redmica_ui_extension.git

# DrawIOプラグインをインストール
RUN git clone https://github.com/mikitex70/redmine_drawio.git

# プラグインの依存関係をインストール
WORKDIR /usr/src/redmine
RUN bundle install --without development test

# カスタムエントリーポイントスクリプトをコピー
COPY docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Redmineユーザーに戻す
USER redmine

# 公式エントリーポイントを保持しつつ、カスタムスクリプトを実行
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
