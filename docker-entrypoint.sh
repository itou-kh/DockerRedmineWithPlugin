#!/bin/bash
set -e

# 公式のRedmineエントリーポイントを最初に実行してデータベース設定を生成
echo "Redmineの初期化を開始します..."

# 公式エントリーポイントの処理を実行（データベース設定の生成など）
/docker-entrypoint.sh echo "Database configuration generated"

# データベースの準備ができるまで待機
echo "データベースの準備を待機中..."
until mysqladmin ping -h"$REDMINE_DB_MYSQL" -u"$REDMINE_DB_USERNAME" -p"$REDMINE_DB_PASSWORD" --silent 2>/dev/null; do
  echo "データベースに接続できません。5秒後に再試行します..."
  sleep 5
done

echo "データベースに接続できました。"

# 初回起動時のみプラグインのインストールを実行
if [ ! -f /usr/src/redmine/plugins_installed ]; then
  echo "初回起動: プラグインのセットアップを実行します..."
  
  # プラグインのマイグレーション
  echo "プラグインのマイグレーションを実行中..."
  bundle exec rake redmine:plugins:migrate RAILS_ENV=production
  
  # アセットのプリコンパイル
  echo "アセットのプリコンパイルを実行中..."
  bundle exec rake assets:precompile RAILS_ENV=production
  
  # プラグインインストール完了フラグを作成
  touch /usr/src/redmine/plugins_installed
  
  echo "プラグインのセットアップが完了しました。"
else
  echo "プラグインは既にインストール済みです。"
fi

# 公式エントリーポイントを実行してRedmineを起動
echo "Redmineを起動します..."
exec /docker-entrypoint.sh "$@"
