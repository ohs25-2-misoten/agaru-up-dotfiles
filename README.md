# agaru-up-dotfiles - Raspberry Pi Setup

Raspberry Piの初期設定をdotfilesで管理し、Gitから簡単にセットアップできるリポジトリです。

## 📋 概要

Bashスクリプトを使用して、システム設定やアプリケーション設定を自動化・管理するためのdotfiles コレクションです。

## 📁 ディレクトリ構成

```
agaru-up-dotfiles/
├── lib.sh                    # 共有ユーティリティ関数
├── setup.sh                  # メインセットアップスクリプト
├── LICENSE                   # ライセンス
├── README.md                 # このファイル
└── dotfiles/
    ├── cloudflared/          # Cloudflare Tunnel設定
    ├── git/                  # Git設定
    ├── python/               # Python環境設定
    └── ssh/                  # SSH設定
```

## 🚀 セットアップ

### 必要条件

- Linux または macOS
- Bash 4.0+
- `git` コマンド

### インストール手順

1. リポジトリをクローンします：
```bash
git clone https://github.com/ohs25-2-misoten/agaru-up-dotfiles.git
cd agaru-up-dotfiles
```

2. セットアップスクリプトを実行します：
```bash
./setup.sh
```

## 🔧 各モジュール

### Git設定 (`dotfiles/git/`)

Git コマンドの設定を管理します。
```bash
./dotfiles/git/setup.git.sh
```

### SSH設定 (`dotfiles/ssh/`)

SSH鍵と設定ファイルを管理します。
- `authorized_keys`: 公開鍵の管理
- `99-raspberry-pi.conf`: ラズベリーパイ用SSH設定

```bash
./dotfiles/ssh/setup.ssh.sh
```

### Python環境 (`dotfiles/python/`)

Python環境の設定を管理します。
```bash
./dotfiles/python/setup.python.sh
```

### Cloudflare Tunnel (`dotfiles/cloudflared/`)

Cloudflare Tunnelの設定を管理します。
```bash
./dotfiles/cloudflared/setup.cloudflared.sh
```

## 📝 カスタマイズ

各 `setup.*.sh` スクリプトは独立して実行できます。
必要なモジュールのみを選択してセットアップしてください。

## 🔄 開発ワークフロー

このプロジェクトでは、Trunk-Based Development を採用しています。

### ブランチ規則

- `main`: 本番環境用の安定したコード
- `feat/*`: 新機能開発用ブランチ
- `fix/*`: バグ修正用ブランチ
- `hotfix/*`: 緊急修正用ブランチ

### 開発フロー

1. mainブランチから短命ブランチを作成：
```bash
git checkout main
git pull origin main
git checkout -b feat/your-feature-name
```

2. 開発・コミット：
```bash
git add .
git commit -m "feat: 新機能の説明"
```

3. プルリクエストを作成してmainにマージ
4. マージ後、短命ブランチを削除

## 📝 コーディング規約

### コミットメッセージ

Conventional Commits形式を採用：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**タイプ**:
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメント
- `style`: スタイル変更
- `refactor`: リファクタリング
- `test`: テスト
- `chore`: その他

## 🚢 リリース

### バージョニング

Semantic Versioning (SemVer) を採用：
- `MAJOR.MINOR.PATCH` (例: 1.0.0)

### リリースプロセス

1. devからreleaseブランチを作成
2. バージョン更新とリリース準備
3. mainにマージしてタグ付け

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feat/amazing-feature`)
3. 変更をコミット (`git commit -m 'feat: 素晴らしい機能を追加'`)
4. ブランチにプッシュ (`git push origin feat/amazing-feature`)
5. プルリクエストを作成

### プルリクエストガイドライン

- [ ] 適切なブランチから作成
- [ ] テストの追加・更新
- [ ] コードレビューの実施
- [ ] コンフリクトの解決
- [ ] ドキュメントの更新（必要な場合）

## 📄 ライセンス

GNU Affero General Public License v3.0 (AGPL-3.0) ライセンスの下で提供されています。詳細は [LICENSE](./LICENSE) ファイルを参照してください。

## 👥 メンテナー

- [tomo3101](mailto:tacstomo.sub@gmail.com)

## 📞 サポート

質問や問題がある場合は、以下の方法でお問い合わせください：

- [Issues](../../issues) - バグ報告や機能要望
- [Discussions](../../discussions) - 質問や議論

## 📚 追加リソース

- [Cloudflare Tunnel Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [uv - Python package installer](https://docs.astral.sh/uv/)

---

**最終更新**: 2025年12月2日
