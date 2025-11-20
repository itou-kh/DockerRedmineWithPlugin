FROM redmine:5.1

# 必要なパッケージをインストール
USER root
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# プラグインディレクトリに移動
WORKDIR /usr/src/redmine/plugins

# Mermaidプラグインをインストール
RUN git clone https://github.com/mikitex70/redmine_mermaid_macro.git

# DrawIOプラグインをインストール
RUN git clone https://github.com/mikitex70/redmine_drawio.git

# プラグインの依存関係をインストール
WORKDIR /usr/src/redmine
RUN bundle install --without development test

# データベースマイグレーションとプラグインのインストールスクリプトをコピー
COPY install_plugins.sh /usr/src/redmine/
RUN chmod +x /usr/src/redmine/install_plugins.sh

# Redmineユーザーに戻す
USER redmine

# エントリーポイントスクリプトをコピー
COPY docker-entrypoint.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
USER redmine

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
