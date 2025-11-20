# Redmine with Mermaid and DrawIO Plugins

このプロジェクトは、DockerとDocker Composeを使用してMermaidとDrawIOプラグインが組み込まれたRedmine環境を構築します。

## 含まれるプラグイン

- **Mermaid Macro Plugin**: Mermaid記法を使用してフローチャートやダイアグラムを作成できます
- **DrawIO Plugin**: Draw.ioを使用してダイアグラムを作成・編集できます

## 必要な環境

- Docker
- Docker Compose

## セットアップ手順

1. このリポジトリをクローンまたはダウンロードします
2. プロジェクトディレクトリに移動します
3. 以下のコマンドでコンテナを起動します：

```bash
docker-compose up -d
```

## 初回起動について

初回起動時は以下の処理が自動的に実行されます：

- データベースの作成と初期化
- Redmineのデータベースマイグレーション
- プラグインのインストールとマイグレーション
- デフォルトデータの読み込み（日本語）
- アセットのプリコンパイル

初回起動には数分かかる場合があります。

## アクセス方法

Redmineが起動したら、以下のURLでアクセスできます：

- URL: http://localhost:3000
- 管理者ユーザー: admin
- 初期パスワード: admin

## プラグインの使用方法

### Mermaidプラグイン

Wiki記法で以下のように記述することでMermaidダイアグラムを表示できます：

```
{{mermaid
graph TD
    A[開始] --> B{条件}
    B -->|Yes| C[処理1]
    B -->|No| D[処理2]
    C --> E[終了]
    D --> E
}}
```

### DrawIOプラグイン

1. 管理 > プラグイン > DrawIO plugin の設定を開く
2. DrawIO URLを設定（デフォルト: https://app.diagrams.net/）
3. Wiki記法で以下のように記述：

```
{{drawio(diagram_name)}}
```

## ファイル構成

- `docker-compose.yml`: Docker Composeの設定ファイル
- `Dockerfile`: Redmineコンテナのビルド設定
- `docker-entrypoint.sh`: コンテナ起動時のエントリーポイント
- `install_plugins.sh`: プラグインインストール用スクリプト
- `.env`: 環境変数設定ファイル

## データの永続化

以下のデータはDockerボリュームに保存され、コンテナを再起動しても保持されます：

- データベースデータ
- Redmineのファイル
- プラグインデータ
- テーマデータ

## コンテナの管理

### 起動
```bash
docker-compose up -d
```

### 停止
```bash
docker-compose down
```

### ログの確認
```bash
docker-compose logs -f redmine
```

### データベースのログ確認
```bash
docker-compose logs -f db
```

## トラブルシューティング

### データベース接続エラーの場合

**症状**: `Cannot load database configuration: No such file - ["config/database.yml"]`

**原因**: データベース設定ファイルが正しく生成されていない

**対処法**:
1. コンテナを完全に停止：
```bash
docker-compose down -v
```

2. イメージを再ビルド：
```bash
docker-compose build --no-cache
```

3. 再起動：
```bash
docker-compose up -d
```

### プラグインが表示されない場合

1. コンテナのログを確認：
```bash
docker-compose logs redmine
```

2. プラグインの再インストール：
```bash
docker-compose exec redmine bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

### 初回起動が遅い場合

データベースの初期化とプラグインのセットアップには5-10分程度かかる場合があります。以下のコマンドで進行状況を確認できます：

```bash
docker-compose logs -f redmine
```

### コンテナが起動しない場合

1. データベースのヘルスチェック状態を確認：
```bash
docker-compose ps
```

2. データベースログを確認：
```bash
docker-compose logs db
```

## カスタマイズ

### 環境変数の変更

`.env`ファイルを編集して、データベースのパスワードやその他の設定を変更できます。

### 追加プラグインのインストール

`Dockerfile`を編集して、追加のプラグインをインストールできます。

## セキュリティ注意事項

- 本番環境で使用する場合は、`.env`ファイルのパスワードを強力なものに変更してください
- 管理者の初期パスワードを必ず変更してください
- 必要に応じてファイアウォールの設定を行ってください
