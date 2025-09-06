# =============================================================================
# Go Workshop Makefile - Go言語学習特化版
# 学習者向けタスク自動化（最適化版）
# =============================================================================

.PHONY: help setup test clean run-phase0 run-phase1 format lint verify deps

# デフォルトターゲット
help:
	@echo "🚀 Go Workshop 2025 - 利用可能なコマンド（Go言語特化版）"
	@echo ""
	@echo "📋 基本コマンド:"
	@echo "  make setup      - 初期設定実行"
	@echo "  make verify     - 環境・設定の確認"
	@echo "  make test       - 全テスト実行"
	@echo "  make format     - コードフォーマット"
	@echo "  make lint       - コード解析"
	@echo "  make clean      - 一時ファイル削除"
	@echo "  make deps       - 依存関係の更新"
	@echo ""
	@echo "🏃 Phase別実行:"
	@echo "  make run-phase0 - Phase 0 環境確認"
	@echo "  make run-phase1 - Phase 1 Hello World"
	@echo ""
	@echo "🔧 開発支援:"
	@echo "  make server     - Go Webサーバー起動（ポート8080）"
	@echo "  make build      - 全モジュールのビルド確認"
	@echo ""

# 初期設定
setup:
	@echo "🔧 Go言語環境の初期設定を実行中..."
	@echo "📦 Go moduleの整理..."
	go mod tidy
	@echo "🔍 Go環境の確認..."
	@$(MAKE) verify
	@echo "✅ 初期設定完了"

# 環境確認
verify:
	@echo "🔍 Go言語開発環境の確認中..."
	@echo "Go version: $$(go version)"
	@echo "GOPATH: $$(go env GOPATH)"
	@echo "GOROOT: $$(go env GOROOT)"
	@echo "Module: $$(go list -m 2>/dev/null || echo 'モジュール未設定')"
	@echo "作業ディレクトリ: $$(pwd)"

# Phase 0実行（環境確認）
run-phase0:
	@echo "🔧 Phase 0: 環境確認を実行中..."
	@if [ -f "phase0-environment/main.go" ]; then \
		cd phase0-environment && go run main.go; \
	elif [ -f "hello-test.go" ]; then \
		go run hello-test.go; \
	else \
		echo "❌ 環境確認用ファイルが見つかりません"; \
		echo "   以下のファイルを確認してください:"; \
		echo "   - phase0-environment/main.go"; \
		echo "   - hello-test.go"; \
	fi

# Phase 1実行（Hello World）
run-phase1:
	@echo "👋 Phase 1: Hello World を実行中..."
	@if [ -f "phase1-go-basics/01-hello-world/hello.go" ]; then \
		cd phase1-go-basics/01-hello-world && go run hello.go; \
	elif [ -f "phase1-go-basics/01-hello-world/main.go" ]; then \
		cd phase1-go-basics/01-hello-world && go run main.go; \
	else \
		echo "❌ Hello Worldファイルが見つかりません"; \
		echo "   phase1-go-basics/01-hello-world/ を確認してください"; \
	fi

# Webサーバー起動
server:
	@echo "🌐 Go Webサーバーを起動中（ポート8080）..."
	@if [ -f "phase1-go-basics/03-web-server/main.go" ]; then \
		cd phase1-go-basics/03-web-server && go run main.go; \
	elif [ -f "phase2-web-development/01-static-files/main.go" ]; then \
		cd phase2-web-development/01-static-files && go run main.go; \
	else \
		echo "❌ Webサーバーファイルが見つかりません"; \
		echo "   以下のディレクトリを確認してください:"; \
		echo "   - phase1-go-basics/03-web-server/"; \
		echo "   - phase2-web-development/01-static-files/"; \
	fi

# 全テスト実行
test:
	@echo "🧪 Go言語テストを実行中..."
	@echo "📁 テスト対象の検索..."
	@find . -name "*_test.go" -type f | head -5 | while read file; do \
		echo "   - $$file"; \
	done
	@echo "🚀 テスト実行..."
	go test ./... -v

# ビルド確認
build:
	@echo "🔨 全モジュールのビルド確認中..."
	@for dir in $$(find . -name "*.go" -not -path "./.git/*" -exec dirname {} \; | sort -u); do \
		echo "📂 $$dir をビルド確認中..."; \
		(cd $$dir && go build . 2>/dev/null && echo "   ✅ ビルド成功" || echo "   ⚠️  ビルドスキップ"); \
	done

# コードフォーマット
format:
	@echo "📝 Goコードのフォーマット実行中..."
	@echo "🔧 gofmt実行..."
	gofmt -s -w .
	@echo "📦 goimports実行（利用可能な場合）..."
	@if command -v goimports >/dev/null 2>&1; then \
		goimports -w .; \
		echo "✅ goimports完了"; \
	else \
		echo "⚠️  goimportsが見つかりません（gofmtのみ実行）"; \
	fi

# コード解析
lint:
	@echo "🔍 Goコードの静的解析実行中..."
	@echo "🔧 go vet実行..."
	go vet ./...
	@echo "🔧 golangci-lint実行（利用可能な場合）..."
	@if command -v golangci-lint >/dev/null 2>&1; then \
		golangci-lint run ./...; \
		echo "✅ golangci-lint完了"; \
	else \
		echo "⚠️  golangci-lintが見つかりません（go vetのみ実行）"; \
	fi

# 依存関係更新
deps:
	@echo "📦 Go依存関係の更新中..."
	go mod tidy
	go mod download
	@echo "📋 モジュール情報:"
	go list -m all

# 一時ファイル削除
clean:
	@echo "🧹 一時ファイルのクリーンアップ実行中..."
	go clean ./...
	rm -f *.log *.tmp
	find . -name "*.test" -delete 2>/dev/null || true
	find . -name "debug" -type f -delete 2>/dev/null || true
	@echo "✅ クリーンアップ完了"

# 開発環境の完全確認
check-env:
	@echo "🔍 Go開発環境の詳細確認..."
	@echo ""
	@echo "📋 システム情報:"
	@echo "  OS: $$(uname -s)"
	@echo "  アーキテクチャ: $$(uname -m)"
	@echo ""
	@echo "📋 Go環境:"
	@echo "  Go version: $$(go version)"
	@echo "  GOPATH: $$(go env GOPATH)"
	@echo "  GOROOT: $$(go env GOROOT)"
	@echo "  GOOS: $$(go env GOOS)"
	@echo "  GOARCH: $$(go env GOARCH)"
	@echo ""
	@echo "📋 プロジェクト:"
	@echo "  作業ディレクトリ: $$(pwd)"
	@echo "  Module: $$(go list -m 2>/dev/null || echo 'モジュール未設定')"
	@echo ""
	@echo "📋 利用可能なツール:"
	@command -v goimports >/dev/null && echo "  ✅ goimports" || echo "  ❌ goimports"
	@command -v golangci-lint >/dev/null && echo "  ✅ golangci-lint" || echo "  ❌ golangci-lint"
	@command -v gh >/dev/null && echo "  ✅ GitHub CLI" || echo "  ❌ GitHub CLI"

# 学習進捗確認
progress:
	@echo "📊 学習進捗の確認..."
	@echo ""
	@echo "📁 Phase 0 (環境確認):"
	@[ -f "phase0-environment/main.go" ] && echo "  ✅ main.go" || echo "  ❌ main.go"
	@[ -f "hello-test.go" ] && echo "  ✅ hello-test.go" || echo "  ❌ hello-test.go"
	@echo ""
	@echo "📁 Phase 1 (Go言語基礎):"
	@[ -d "phase1-go-basics/01-hello-world" ] && echo "  ✅ 01-hello-world" || echo "  ❌ 01-hello-world"
	@[ -d "phase1-go-basics/02-variables-functions" ] && echo "  ✅ 02-variables-functions" || echo "  ❌ 02-variables-functions"
	@[ -d "phase1-go-basics/03-web-server" ] && echo "  ✅ 03-web-server" || echo "  ❌ 03-web-server"
	@echo ""
	@echo "📁 Phase 2 (Web開発実践):"
	@[ -d "phase2-web-development" ] && echo "  ✅ ディレクトリ存在" || echo "  ❌ ディレクトリ未作成"
	@echo ""
	@echo "📋 Git状況:"
	@git status --porcelain 2>/dev/null | wc -l | xargs -I {} echo "  変更ファイル数: {}"
	@git branch --show-current 2>/dev/null | xargs -I {} echo "  現在のブランチ: {}"
