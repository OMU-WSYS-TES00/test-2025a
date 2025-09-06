package main

import (
	"fmt"
	"net/http"
	"os"
	"runtime"
	"time"
)

// 環境確認用のメイン関数
func main() {
	fmt.Println("🚀 Go Workshop 2025 - 環境確認プログラム")
	fmt.Println("=" + repeatString("=", 50))

	// Go言語環境の確認
	checkGoEnvironment()

	// ファイルシステムの確認
	checkFileSystem()

	// HTTP機能の確認
	checkHTTPCapability()

	// 学習者情報の入力促進
	promptStudentInfo()

	fmt.Println("\n✅ 環境確認完了!")
	fmt.Println("🎯 Phase 1のGo言語基礎学習を開始できます")
}

// Go言語環境の詳細確認
func checkGoEnvironment() {
	fmt.Println("\n📦 Go言語環境確認")
	fmt.Println("-" + repeatString("-", 30))

	// バージョン情報
	fmt.Printf("Go Version: %s\n", runtime.Version())
	fmt.Printf("OS/Architecture: %s/%s\n", runtime.GOOS, runtime.GOARCH)
	fmt.Printf("CPU Cores: %d\n", runtime.NumCPU())

	// 環境変数
	gopath := os.Getenv("GOPATH")
	if gopath == "" {
		gopath = "デフォルト値を使用"
	}
	fmt.Printf("GOPATH: %s\n", gopath)

	goroot := os.Getenv("GOROOT")
	if goroot == "" {
		goroot = "デフォルト値を使用"
	}
	fmt.Printf("GOROOT: %s\n", goroot)

	// 作業ディレクトリ
	workdir, err := os.Getwd()
	if err != nil {
		workdir = "取得エラー"
	}
	fmt.Printf("作業ディレクトリ: %s\n", workdir)
}

// ファイルシステムアクセスの確認
func checkFileSystem() {
	fmt.Println("\n📁 ファイルシステム確認")
	fmt.Println("-" + repeatString("-", 30))

	// 読み取りテスト
	testFile := "test-write.tmp"
	testContent := "Go Workshop 2025 環境テスト"

	// ファイル書き込みテスト
	err := os.WriteFile(testFile, []byte(testContent), 0644)
	if err != nil {
		fmt.Printf("❌ ファイル書き込みエラー: %v\n", err)
		return
	}
	fmt.Println("✅ ファイル書き込み: 成功")

	// ファイル読み取りテスト
	content, err := os.ReadFile(testFile)
	if err != nil {
		fmt.Printf("❌ ファイル読み取りエラー: %v\n", err)
	} else if string(content) == testContent {
		fmt.Println("✅ ファイル読み取り: 成功")
	} else {
		fmt.Println("❌ ファイル内容不一致")
	}

	// 一時ファイル削除
	os.Remove(testFile)
	fmt.Println("✅ ファイル削除: 成功")
}

// HTTP機能の確認（Webサーバー基本機能）
func checkHTTPCapability() {
	fmt.Println("\n🌐 HTTP機能確認")
	fmt.Println("-" + repeatString("-", 30))

	// 簡易HTTPサーバーのテスト
	// ポート8080が使用可能かチェック
	fmt.Println("📡 HTTPサーバー機能をテスト中...")

	// テスト用のHTTPハンドラー
	http.HandleFunc("/test", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Go Workshop 2025 HTTP Test - %s", time.Now().Format("2006-01-02 15:04:05"))
	})

	// 短時間でのサーバーテスト
	server := &http.Server{Addr: ":8080"}

	// 別ゴルーチンでサーバー起動
	go func() {
		err := server.ListenAndServe()
		if err != http.ErrServerClosed {
			fmt.Printf("⚠️  HTTPサーバーエラー: %v\n", err)
		}
	}()

	// 少し待ってからテストリクエスト
	time.Sleep(100 * time.Millisecond)

	// ローカルテストリクエスト
	resp, err := http.Get("http://localhost:8080/test")
	if err != nil {
		fmt.Printf("⚠️  HTTPテストリクエストエラー: %v\n", err)
		fmt.Println("   → Codespacesのポート設定で解決される場合があります")
	} else {
		resp.Body.Close()
		fmt.Println("✅ HTTP基本機能: 成功")
		fmt.Println("   → Webサーバー構築の準備完了")
	}

	// テストサーバー停止
	server.Close()
}

// 学習者情報の入力促進
func promptStudentInfo() {
	fmt.Println("\n👤 学習者情報の設定")
	fmt.Println("-" + repeatString("-", 30))

	fmt.Println("📝 次のステップ:")
	fmt.Println("   1. go.modファイルの個人化")
	fmt.Println("      → go mod edit -module github.com/[ユーザー名]/go-workshop-2025-[学籍番号]")
	fmt.Println("   2. Git設定の確認")
	fmt.Println("      → git config --global user.name \"あなたの名前\"")
	fmt.Println("      → git config --global user.email \"メールアドレス\"")
	fmt.Println("   3. Phase 1の学習開始")
	fmt.Println("      → cd phase1-go-basics/01-hello-world")
	fmt.Println("      → go run hello.go")

	// Git設定の確認
	checkGitConfig()
}

// Git設定の確認
func checkGitConfig() {
	fmt.Println("\n⚙️  Git設定確認")
	fmt.Println("-" + repeatString("-", 20))

	// 簡易的なGit設定確認（git command使用せず）
	home := os.Getenv("HOME")
	if home == "" {
		home = os.Getenv("USERPROFILE") // Windows対応
	}

	gitConfigPath := home + "/.gitconfig"
	if _, err := os.Stat(gitConfigPath); err == nil {
		fmt.Println("✅ Git設定ファイル: 存在")
	} else {
		fmt.Println("⚠️  Git設定ファイル: 未設定")
		fmt.Println("   → git config --global で設定してください")
	}
}

// 文字列繰り返しヘルパー関数
func repeatString(s string, count int) string {
	result := ""
	for i := 0; i < count; i++ {
		result += s
	}
	return result
}

// 学習用の追加情報表示
func showLearningTips() {
	fmt.Println("\n💡 学習のヒント")
	fmt.Println("-" + repeatString("-", 30))
	fmt.Println("🔧 便利なコマンド:")
	fmt.Println("   make help       - 利用可能なコマンド一覧")
	fmt.Println("   make verify     - 環境確認")
	fmt.Println("   make run-phase1 - Phase 1 Hello World実行")
	fmt.Println("   make server     - Webサーバー起動")
	fmt.Println("   make format     - コードフォーマット")

	fmt.Println("\n📚 学習リソース:")
	fmt.Println("   - Go言語公式ドキュメント: https://golang.org/doc/")
	fmt.Println("   - Go言語ツアー: https://tour.golang.org/")
	fmt.Println("   - 効果的なGo: https://golang.org/doc/effective_go.html")

	fmt.Println("\n🆘 困ったときは:")
	fmt.Println("   - GitHub Issueで質問・ヘルプ要請")
	fmt.Println("   - 進捗報告Issueで学習状況共有")
	fmt.Println("   - READMEファイルで詳細手順確認")
}

// プログラム実行時の時刻情報
func init() {
	// プログラム開始時刻をログに記録
	fmt.Printf("🕐 実行時刻: %s\n", time.Now().Format("2006年01月02日 15:04:05"))
	fmt.Printf("🏫 Go Workshop 2025 環境確認\n\n")
}
