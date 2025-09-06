#!/bin/bash

# Go Workshop 2025 日本語対応開発環境セットアップスクリプト

echo "🚀 Go Workshop 2025 日本語対応開発環境のセットアップを開始します..."

# ロケール設定（日本語対応）
echo "🌐 日本語ロケール設定中..."
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8

# Go環境確認
echo "📦 Go言語環境の確認中..."
go version
if [ $? -eq 0 ]; then
    echo "✅ Go言語の準備完了"
    echo "   - バージョン: $(go version | cut -d' ' -f3)"
    echo "   - GOPATH: $GOPATH"
    echo "   - GOROOT: $GOROOT"
else
    echo "❌ Go言語の設定に問題があります"
    exit 1
fi

# Node.js環境確認
echo "📦 Node.js環境の確認中..."
node --version
npm --version
if [ $? -eq 0 ]; then
    echo "✅ Node.js環境の準備完了"
    echo "   - Node.js: $(node --version)"
    echo "   - npm: $(npm --version)"
else
    echo "❌ Node.js環境の設定に問題があります"
fi

# GitHub CLI確認
echo "📦 GitHub CLI の確認中..."
gh --version
if [ $? -eq 0 ]; then
    echo "✅ GitHub CLI の準備完了"
    echo "   - バージョン: $(gh --version | head -n1)"
else
    echo "❌ GitHub CLI の設定に問題があります"
fi

# Docker環境確認
echo "📦 Docker環境の確認中..."
docker --version
if [ $? -eq 0 ]; then
    echo "✅ Docker環境の準備完了"
    echo "   - バージョン: $(docker --version)"
else
    echo "⚠️ Docker環境が利用できません（一部機能に制限があります）"
fi

# Go開発ツールのインストール
echo "🔧 Go開発ツールをインストール中..."
go install -v golang.org/x/tools/gopls@latest
go install -v github.com/go-delve/delve/cmd/dlv@latest
go install -v honnef.co/go/tools/cmd/staticcheck@latest
go install -v golang.org/x/tools/cmd/goimports@latest
go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest

echo "✅ Go開発ツールのインストール完了"

# プロジェクト依存関係の初期化
echo "📚 プロジェクト依存関係を初期化中..."
if [ -f "go.mod" ]; then
    go mod tidy
    echo "✅ go mod tidy 完了"
else
    echo "⚠️ go.modが見つかりません（後で個人化の際に作成されます）"
fi

# 各phaseディレクトリの依存関係確認
echo "🔍 各Phaseディレクトリの確認中..."
for phase_dir in phase*; do
    if [ -d "$phase_dir" ]; then
        echo "   - $phase_dir ディレクトリを確認"
        if [ -f "$phase_dir/go.mod" ]; then
            echo "     → go.modが存在：依存関係を更新中..."
            cd "$phase_dir"
            go mod tidy
            cd ..
        else
            echo "     → go.modなし：通常の課題ディレクトリ"
        fi
    fi
done

# Git設定の確認・調整
echo "🔧 Git設定を確認中..."
git config --global --add safe.directory /workspaces/*
git config --global init.defaultBranch main
git config --global pull.rebase false

# Git設定の表示
echo "📋 現在のGit設定:"
echo "   - ユーザー名: $(git config --global user.name || echo '未設定')"
echo "   - メール: $(git config --global user.email || echo '未設定')"
echo "   - デフォルトブランチ: $(git config --global init.defaultBranch)"

# Welcomeメッセージファイルの作成
echo "📝 環境情報ファイルを作成中..."
cat > CODESPACE_WELCOME.md << EOF
# 🎉 Go Workshop 2025 Codespacesへようこそ！

このファイルは自動生成されています。削除しても問題ありません。

## 📋 環境確認

### 言語・ツール環境
- **Go言語**: $(go version | cut -d' ' -f3)
- **GitHub CLI**: $(gh --version | head -n1 | cut -d' ' -f3)

### ワークスペース情報
- **作業ディレクトリ**: $(pwd)
- **Git設定**:
  - ユーザー名: $(git config --global user.name || echo '未設定')
  - メール: $(git config --global user.email || echo '未設定')

## 🚀 最初にやること

### 1. 環境確認（Phase 0）
\`\`\`bash
cd phase0-environment
go run main.go
\`\`\`

### 2. Goモジュールの個人化 ⚠️重要⚠️
現在のgo.modを個人用に変更してください：

\`\`\`bash
# 現在のモジュール名を確認
cat go.mod

# 個人用に変更（[USERNAME]と[STUDENT_ID]を実際の値に置き換え）
go mod edit -module github.com/[USERNAME]/go-workshop-2025-[STUDENT_ID]
go mod tidy
\`\`\`

**例**:
\`\`\`bash
# 学籍番号AXY29123の田中太郎さんの場合
go mod edit -module github.com/tanaka-taro-AXY29123/go-workshop-2025-s2025001
go mod tidy
\`\`\`

### 3. Git設定（初回のみ）
\`\`\`bash
git config --global user.name "あなたの名前"
git config --global user.email "your.email@example.com"
\`\`\`

## 💡 便利なコマンド

### 基本操作
- \`make help\`: 利用可能なコマンド一覧
- \`make test\`: 全テストの実行
- \`make format\`: コードフォーマット
- \`make check\`: 静的解析

### Phase別実行
- \`make run-phase0\`: Phase 0の実行
- \`make run-hello\`: Hello Worldの実行

### トラブルシューティング
- \`make verify\`: 環境・設定の確認
- \`make clean\`: 生成ファイルの削除
- \`make deps\`: 依存関係の更新

## 🆘 困ったときは

1. **GitHubでIssueを作成**：
   - 「🆘 質問・ヘルプ要請」テンプレートを使用
   - 具体的な問題内容を記載

2. **よくある問題**：
   - go.modのモジュール名が正しく変更されているか確認
   - \`go mod tidy\`を実行したか確認
   - Codespacesを再起動してみる

## 📚 学習の進め方

1. **Phase 0**: 環境確認
2. **Phase 1**: Go言語基礎
3. **Phase 2**: Web開発応用

各Phaseの詳細は、対応するディレクトリのREADME.mdをご確認ください。

---

**頑張って学習しましょう！** 🚀
プログラミングの世界へようこそ！
EOF

# Makefileの存在確認
if [ -f "Makefile" ]; then
    echo "✅ Makefileが利用可能です"
    echo "   → 'make help' で利用可能なコマンドを確認できます"
else
    echo "⚠️ Makefileが見つかりません（開発効率化コマンドが利用できません）"
fi

# 完了メッセージ
echo ""
echo "🎉 セットアップ完了！"
echo ""
echo "📝 次のステップ:"
echo "   1. CODESPACE_WELCOME.md ファイルをご確認ください"
echo "   2. go.mod の個人化を実行してください"
echo "   3. phase0-environment で環境確認を行ってください"
echo ""
echo "🔗 重要なリンク:"
echo "   - 🆘 問題が発生した場合：GitHubでIssueを作成"
echo "   - 📚 学習ガイド：各PhaseディレクトリのREADME.md"
echo "   - 💡 便利コマンド：make help"
echo ""
echo "頑張って学習を進めてください！ 🚀"
