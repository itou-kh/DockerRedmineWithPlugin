#!/bin/bash

# プラグインのインストールとマイグレーション用スクリプト

echo "プラグインのインストールを開始します..."

# データベースの準備ができるまで待機
echo "データベースの準備を待機中..."
until PGPASSWORD=$REDMINE_DB_PASSWORD psql -h "$REDMINE_DB_MYSQL" -U "$REDMINE_DB_USERNAME" -d "$REDMINE_DB_DATABASE" -c '\q' 2>/dev/null; do
  echo "データベースに接続できません。5秒後に再試行します..."
  sleep 5
done

echo "データベースに接続できました。"

# Redmineのデータベースマイグレーション
echo "Redmineのデータベースマイグレーションを実行中..."
bundle exec rake db:migrate RAILS_ENV=production

# プラグインのマイグレーション
echo "プラグインのマイグレーションを実行中..."
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

# アセットのプリコンパイル
echo "アセットのプリコンパイルを実行中..."
bundle exec rake assets:precompile RAILS_ENV=production

echo "プラグインのインストールが完了しました。"
