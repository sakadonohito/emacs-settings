;;; init.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 設定でやりたいこと
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
;;    8-3. Flycheck
;;    8-4. LSP
;;      - Eglot
;;      - eldoc-box
;;    8-5. 入力補完
;;      - Orderless
;;      - Corfu
;;      - Kind-icon
;;      - Cape
;;    8-6. AI(Codeium:不使用)
;; 9. 各プログラミング言語の設定
;;10. 自動で編集されるcustom-set-variables
;;11. 起動後にGC閾値を実用的な値（1MB〜16MB程度）に戻す
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
(defun add-to-load-path (&rest paths)
  "Add specified PATHS to the 'load-path'.
Each path in PATHS is relative to 'user-emacs-directory',
and subdirectories are also added if applicable.
PATHS: List of directory paths to add to 'load-path'."
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	     (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf")
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
;; Emacsが自動編集しちゃうcustom-set-variablesを別ファイルに隔離する
;; --------------------------------------------------
;; 1. Emacsに「今後の自動書き込みはこのファイル（custom.el）に」と指定
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; 2. もしそのファイルが既に存在していれば、中身を読み込む
(when (file-exists-p custom-file)
  (load custom-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 6.GUI他基本設定
;; ====================================================================

;; --------------------------------------------------
;; 基本設定のファイルを読み込み
;; 画面、キーバインド、SSH設定など
;; --------------------------------------------------
(require 'base)
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
;;; 8-3.flycheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)  ;; Flycheckをグローバルで有効化
  :custom
  (flycheck-check-syntax-automatically '(save idle-change mode-enabled))  ;; 自動チェックのタイミング
  (flycheck-idle-change-delay 2.0) ;; チェックを2秒遅延
  (flycheck-python-flake8-executable "flake8") ;; flake8を利用した構文チェック
  :config
  ;; 特定モードでFlycheckを無効化
  (add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))
  (add-hook 'markdown-mode-hook (lambda () (flycheck-mode -1)))
  ;; Flycheckのキーバインドを設定
  (define-key flycheck-mode-map (kbd "C-c ! n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-c ! p") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "C-c ! l") 'flycheck-list-errors))

;;; Emacs30 かつuse-packageを使うので以下の記述は無効に :2026-02-19

;; eslint 用の linter を登録
;(leaf :config
;  (flycheck-add-mode 'javascript-eslint 'web-mode))

;; 作業しているプロジェクトの node-modules を考慮
;(leaf add-node-modules-path
;  :ensure t
;  :hook (web-mode-hook . add-node-modules-path))

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
;;; 8-6. Codeium (コード生成AI)
;(leaf codeium
;  ;; MELPAに登録されていない
;  ;:ensure t
;  ;; :vcキーワードが使えない
;  ;:vc ( :url "https://github.com/Exafunction/codeium.el"
;  ;      :lisp-dir "elisp")
;  :require t
;  :init
;  ;; 補完機能を追加
;  ;; completion-at-point-functions に codeium-completion-at-point を追加
;  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;  ;; 起動時に Codeium を初期化（オプション）
;  (add-hook 'emacs-startup-hook
;            (lambda () (run-with-timer 0.1 nil #'codeium-init)))
;  :config
;  ;; ポップアップダイアログを使用しない
;  (setq use-dialog-box nil)
;  ;; モードラインに Codeium のステータスを表示
;  (setq codeium-mode-line-enable
;        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;  ;; 有効な API を制限
;  (setq codeium-api-enabled
;        (lambda (api)
;          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;  ;; パフォーマンス向上のために送信文字列を制限
;  (defun my-codeium/document/text ()
;    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;  (defun my-codeium/document/cursor_offset ()
;    (codeium-utf8-byte-length
;     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;  (setq codeium/document/text 'my-codeium/document/text)
;  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)
;
;  ;; 必要な初期セットアップを実行(導入後1回手動で実行すればよい。設定の中にある必要はない)
;  ;(codeium-install)
;  )

;; 必要に応じて API キーを設定
;; (setq codeium-api-key "YOUR_CODEIUM_API_KEY")

;; ただのテキストエディットの時は作動しないようにする
;(defun my-disable-codeium-in-markdown-and-org ()
;  "Disable Codeium in markdown-mode and org-mode."
;  (when (member major-mode '(markdown-mode org-mode))
;    (codeium-mode -1)))
;
;(add-hook 'markdown-mode-hook #'my-disable-codeium-in-markdown-and-org)
;(add-hook 'org-mode-hook #'my-disable-codeium-in-markdown-and-org)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 9.各プログラミング言語の設定

;;;;; テキスト、設定ファイル系

;;org
(require 'org-settings)

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
;(require 'terraform)

;;;;; Web系(フロントエンド系)

;;web-mode
(require 'html-css)

;;javascript
(require 'js-jsx-ts)

;;;;; 他プログラミング言語

;;shell-pop
(require 'shell-settings)

;;php
;(require 'php)

;;perl
;(require 'perl)

;;ruby
;(require 'ruby)

;;python
(require 'python)

;;Groovy
;(require 'groovy)

;;JVM(Java,Kotlin,Clojure)
;(require 'jvm)

;;MS(C#,F#)
;(require 'ms)

;;C/C++
;(require 'ccpp)

;;golang
;; golangがインストールされているMacでのみ動作させる
;(when (eq system-type 'darwin)
;  (require 'golang)
;)

;;Rust
;(require 'rust)

;;BEAM(Erlang,Elixir)
;(require 'beam)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 10.自動で編集されるcustom-set-variables

;; 「5.独自変数の設定」セクションに読込み先を記述

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 11. 起動後にGC閾値を実用的な値（1MB〜16MB程度）に戻す
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; init.el ends here
