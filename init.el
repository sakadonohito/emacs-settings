;;; init.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 設定項目
;; 1. パッケージ管理の設定
;;    - use-package (Emacs 29+ 標準)
;; 2. 各種パッケージのインストール(事前インストールするもの)
;; 3. ロードパスの設定(配下のサブディレクトリも読み込む、自作のディレクトリもパスに含める)
;; 4. PATHの設定
;; 5. 独自変数の設定
;; 6. GUIの設定(見た目、色など/neotree)
;; 7. Gitの設定
;;    7-1. Magit
;;    7-2. Forge
;;    7-3. diff-hl
;;    7-4. git-timemachine
;;    7-5. blamer
;;    7-6. smerge-mode
;; 8. 自動補完機能と構文解析機能の設定
;;    8-1. & 8-2. ナビゲーション
;;      - Vertico
;;      - Marginalia
;;      - Consult
;;      - Embark
;;      - Embark-Consult
;;    8-3. 構文チェック (Flymake + Flycheck統合)
;;    8-4. LSP
;;      - Eglot
;;      - eldoc-box
;;    8-5. 入力補完
;;      - Orderless
;;      - Corfu
;;      - Kind-icon
;;      - Cape
;;    8-6. AIの設定
;;      - gptel
;;
;; 9. ターミナルの設定
;;10. 各プログラミング言語の設定
;;11. 自動で編集されるcustom-set-variables
;;12. 起動後にGC閾値を実用的な値（1MB〜16MB程度）に戻す
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 0.当面のエラー回避策
;;; (require 'cl) を見逃す
;; 現在は、clパッケージをcl-libに置き換えるのが推奨されているため、この設定不要。
;; どうしても(require 'cl)が必要になった時用に設定記述は残す。
;(setq byte-compile-warnings '(not cl-functions obsolete))
;; docstringが無くても警告出さない。
(setq byte-compile-warnings '(not docstrings))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 1.パッケージ管理の設定
;;; ====================================================================

(require 'package)

;; パッケージアーカイブにMELPAを追加
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; use-packageを有効化 (Emacs 29以降は標準搭載)
;(require 'use-package)

;; パッケージリストを更新（必要に応じてコメントアウト可）
;(unless package-archive-contents
;  (package-refresh-contents))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 2.パッケージのインストール(事前インストールするもの)
;;; ====================================================================

;; --------------------------------------------------
;; request-deferredはMELPAにないのでdeferred
;; --------------------------------------------------
(use-package deferred
  :ensure t
  :config
  ;; 必要に応じて初期設定をここに追加
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 3.ロードパスの設定
;;; ====================================================================

;; --------------------------------------------------
;; サブディレクトリも読み込む関数
;; load-pathを追加する関数の定義
;; --------------------------------------------------
(eval-and-compile
  (defun add-to-load-path (&rest paths)
    "Add specified PATHS to the `load-path`.
Each path in PATHS is relative to `'user-emacs-directory`,
and subdirectories are also added if applicable.
PATHS: List of directory paths to add to `load-path`."
    (let (path)
      (dolist (path paths paths)
        (let ((default-directory
	       (expand-file-name (concat user-emacs-directory path))))
	  (add-to-list 'load-path default-directory)
	  (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	      (normal-top-level-add-subdirs-to-load-path))))))

  ;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
  (add-to-load-path "elisp" "conf"))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 4.PATHの設定
;;; ====================================================================

;; --------------------------------------------------
;; 環境がmacの場合、念の為環境変数を読み込ませる(本来は自動で読み込むがGUI版でうまく行かない場合がある？)
;; --------------------------------------------------
(use-package exec-path-from-shell
  :ensure t
  :custom
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-variables '("PATH" "GOPATH" "JAVA_HOME"))
  (exec-path-from-shell-arguments '("-l"))
  :config
  (exec-path-from-shell-initialize))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5.独自変数の設定
;; 何か自作の変数を定義しておきたい場合はここに

;; --------------------------------------------------
;; OS判定処理と変数格納
;; --------------------------------------------------
(defconst IS-MAC "MacOS")
(defconst IS-LINUX "Linux")
(defconst IS-WINDOWS "Windows")
(defconst IS-UNKNOWN "Unknown OS")

;; --------------------------------------------------
;; 起動したPCのOSを判定して、該当する文字列を保持する変数を定義
;; --------------------------------------------------
(setq current-os
      (cond
       ((eq system-type 'darwin) IS-MAC)       ;; macOS
       ((eq system-type 'gnu/linux) IS-LINUX)  ;; Linux
       ((eq system-type 'windows-nt) IS-WINDOWS) ;; Windows
       (t IS-UNKNOWN)))  ;; その他、未対応のOS

;; --------------------------------------------------
;; OS判定用の真偽値（フラグ）定数
;; --------------------------------------------------
(defconst mac-p     (eq system-type 'darwin)     "MacOS環境なら t.")
(defconst linux-p   (eq system-type 'gnu/linux)  "Linux環境なら t.")
(defconst windows-p (eq system-type 'windows-nt) "Windows環境なら t.")

;; --------------------------------------------------
;; macOS ネイティブコンパイル環境設定 (Warning対策)
;; --------------------------------------------------

;(when (eq system-type 'darwin)
(when mac-p
  ;; SDKパスを取得してLIBRARY_PATHに設定（ld: library 'System' not found 対策）
  (let ((sdk-path (string-trim (shell-command-to-string "xcrun --show-sdk-path"))))
    (when (and sdk-path (not (string-empty-p sdk-path)))
      (setenv "LIBRARY_PATH"
              (concat (getenv "LIBRARY_PATH") ":" sdk-path "/usr/lib"))
      ;; コンパイラオプションにも追加
      (setq native-comp-driver-options (list (concat "-L" sdk-path "/usr/lib"))))))

;; ネイティブコンパイルの警告を抑制したい場合は、以下のコメントを外す
;; (setq native-comp-async-report-warnings-errors 'silent)

;; --------------------------------------------------
;; Emacsが自動編集しちゃうcustom-set-variablesを別ファイルに隔離する
;; --------------------------------------------------
;; 1. Emacsに「今後の自動書き込みはこのファイル（custom.el）に」と指定
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; 2. もしそのファイルが既に存在していれば、中身を読み込む
(when (file-exists-p custom-file)
  (load custom-file))

;; --------------------------------------------------
;; treesit用セットアップ
;; --------------------------------------------------

;(require 'treesit)
(use-package treesit
  ;; パッケージではないので ensure は不要
  :config
  ;; ここに共通の文法ソースリストなどを書く
  (setq treesit-font-lock-level 4)) ; ハイライトの精細度を最大に

;; URLリスト
(setq treesit-language-source-alist
      '(
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (yaml       "https://github.com/ikatyang/tree-sitter-yaml")
        (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src")
        (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")
        (toml       "https://github.com/tree-sitter/tree-sitter-toml")
        (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")

        ;; --- シェル系 ---
        (bash       "https://github.com/tree-sitter/tree-sitter-bash")

        ;; --- Webフロントエンド ---
        (html       "https://github.com/tree-sitter/tree-sitter-html")
        (css        "https://github.com/tree-sitter/tree-sitter-css")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        ;; --- 主要スクリプト言語 ---
        (python     "https://github.com/tree-sitter/tree-sitter-python")
        (php "https://github.com/tree-sitter/tree-sitter-php" "master" "php/src")
        (ruby       "https://github.com/tree-sitter/tree-sitter-ruby")

        ;; --- システム・コンパイル言語 ---
        (go         "https://github.com/tree-sitter/tree-sitter-go")
        (rust       "https://github.com/tree-sitter/tree-sitter-rust")
        (c          "https://github.com/tree-sitter/tree-sitter-c" "master" "src" nil nil)
        (cpp        "https://github.com/tree-sitter/tree-sitter-cpp" "master" "src" "c++" nil)
        (c-sharp    "https://github.com/tree-sitter/tree-sitter-c-sharp")

        ;; --- JVM系 ---
        (java       "https://github.com/tree-sitter/tree-sitter-java")
        (kotlin     "https://github.com/fwcd/tree-sitter-kotlin")
        (scala      "https://github.com/tree-sitter/tree-sitter-scala")
        ;; ts-mode使ってないから不要
        ;(groovy     "")

        ;; --- 関数型・その他 ---
        (clojure    "https://github.com/sogaiu/tree-sitter-clojure")
        (fsharp "https://github.com/KaranAhlawat/tree-sitter-fsharp")
        (erlang     "https://github.com/WhatsApp/tree-sitter-erlang")
        (elixir     "https://github.com/elixir-lang/tree-sitter-elixir")
        (heex   "https://github.com/phoenixframework/tree-sitter-heex") ;; ElixirのHTMLテンプレート
        (make   "https://github.com/alemuller/tree-sitter-make")        ;; ???makefile用???
        ;; swift用はまだない
        ;(swift      "")
        ;; F#はts-modeがまだ不完全？
        ;(fsharp     "https://github.com/KaranAhlawat/tree-sitter-fsharp")

        ;; --- Windows系 ---
        ;; powershell用はまだない?
        ;(powershell "https://github.com/Airbus-CyberSecurity/tree-sitter-powershell")
        ))

;; 自動インストール実行
;; 起動時に未インストールの文法があれば自動でビルドを試みる
(add-hook 'emacs-startup-hook
          (lambda ()
            (dolist (lang treesit-language-source-alist)
              (unless (treesit-language-available-p (car lang))
                (condition-case err
                    (treesit-install-language-grammar (car lang))
                  (error
                   (message "Tree-sitter install error (%s): %s"
                            (car lang) (error-message-string err))))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 6.GUI他基本設定
;; ====================================================================

;; --------------------------------------------------
;; 基本設定のファイルを読み込み
;; 画面、キーバインド、SSH設定など
;; --------------------------------------------------
(require 'base-settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 7. Gitの設定 (Magit + Forge + 関連ツール)
;; ====================================================================
(require 'git-settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-1 & 8-2. 検索・移動・アクション (Vertico + Consult + Marginalia + Embark)
;; ====================================================================
(require 'code-navigation)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-3. 構文チェック (Flymake + Flycheck統合)
;; ====================================================================
(require 'flymake-settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-4. Eglotの設定 (Built-in + eglot-booster)
;; ====================================================================
(require 'eglot-settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-5. Corfuの設定(Corfu + Orderless + Kind-icon + Cape)
;; ====================================================================
(require 'corfu-settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;;; 8-6. AIの設定(gptel)
;; ====================================================================
(require 'ai-assist)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 9. ターミナルの設定
;; ====================================================================
(require 'terminal)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10.各プログラミング言語の設定

;;;;; テキスト、設定ファイル系

;;org
(require 'org-settings)

;;xml
(require 'xml-settings)

;;yaml
(require 'yaml)

;;Markdown
(require 'markdown)

;;rst (Sphinx)
;;; 以下で設定している内容全て不要になった :2026-02-19
;(require 'rst)

;;Docker
(require 'docker)

;;Terraform
(require 'terraform-settings)

;;;;; プログラミング言語

;;shell-pop
(require 'shell-settings)

;;C/C++
(require 'ccpp-settings)

;;Web(html,css/sass,json,js/jsx,ts,tsx,php)
(require 'web-dev)

;;perl
(require 'perl-settings)

;;ruby
(require 'ruby-settings)

;;python
(require 'python-settings)

;;JVM(Java,Kotlin,Clojure,Scala,Groovy)
(require 'jvm)

;;MS(C#,F#,powershell)
(require 'ms-settings)

;;golang
(require 'golang-settings)

;;Rust
(require 'rust-settings)

;;BEAM(Erlang,Elixir)
(require 'beam-settings)

;;Swift
(require 'swift-settings)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11.自動で編集されるcustom-set-variables

;; 「5.独自変数の設定」セクションに読込み先を記述

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 12. 起動後にGC閾値を実用的な値（1MB〜16MB程度）に戻す
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; init.el ends here
