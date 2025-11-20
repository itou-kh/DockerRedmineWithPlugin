#!/bin/bash
set -e

# データベースの準備ができるまで待機
echo "データベースの準備を待機中..."
until mysqladmin ping -h"$REDMINE_DB_MYSQL" -u"$REDMINE_DB_USERNAME" -p"$REDMINE_DB_PASSWORD" --silent; do
  echo "データベースに接続できません。5秒後に再試行します..."
  sleep 5
done

echo "データベースに接続できました。"

# 初回起動時のみプラグインのインストールを実行
if [ ! -f /usr/src/redmine/plugins_installed ]; then
  echo "初回起動: プラグインのセットアップを実行します..."
  
  # データベースの初期化
  bundle exec rake db:create RAILS_ENV=production 2>/dev/null || echo "データベースは既に存在します"
  
  # Redmineのデータベースマイグレーション
  echo "Redmineのデータベースマイグレーションを実行中..."
  bundle exec rake db:migrate RAILS_ENV=production
  
  # プラグインのマイグレーション
  echo "プラグインのマイグレーションを実行中..."
  bundle exec rake redmine:plugins:migrate RAILS_ENV=production
  
  # デフォルトデータの読み込み
  echo "デフォルトデータを読み込み中..."
  bundle exec rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=ja
  
  # アセットのプリコンパイル
  echo "アセットのプリコンパイルを実行中..."
  bundle exec rake assets:precompile RAILS_ENV=production
  
  # プラグインインストール完了フラグを作成
  touch /usr/src/redmine/plugins_installed
  
  echo "プラグインのセットアップが完了しました。"
else
  echo "プラグインは既にインストール済みです。"
fi

# 元のエントリーポイントを実行
exec "$@"
