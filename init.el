;;; init.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 設定でやりたいこと
;; 1. パッケージ管理の設定
;; 	- straight.el
;; 2. 各種パッケージのインストール
;; 3. ロードパスの設定(配下のサブディレクトリも読み込む、自作のディレクトリもパスに含める)
;; 4. 環境変数の読み込み
;; 5. GUIの設定(見た目、色など/neotree)
;; 6. 独自変数の設定
;; 7. Gitの設定
;; 8. 自動補完機能と構文解析機能の設定
;; 	- Ivy
;; 	- Counsel
;;      - Flycheck
;; 	- Company
;; 	- Eglot
;; 	- AI?
;; 9. 各プログラミング言語の設定
;;10. 自動で編集されるcustom-set-variables
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
;;; 1.パッケージ管理の設定
;; straight.elを使用(require 'package)はしないので以下の設定は不要。
;; straight.elをやめる時用にコメントアウトで設定を残す。
(require 'package)
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; エイリアスの設定みたいなもの
;; 2024年10月現在も必要な処理か不明
;(fset 'package-desc-vers 'package-ac-desc-version)

;; パッケージリストの初期化
;; ver27以降は不要な処理(起動時に自動で実行されているはず)
;(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1-1.use-packageの設定
;; straight.elを利用するのでこの設定は不要
;(require 'use-package)
;(setq use-package-always-ensure t)  ;; パッケージがなければ自動インストール
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1-2.straight.elの設定
;; straight.elのブートストラップコード

;(defvar bootstrap-version)
;(let ((bootstrap-file
;       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;      (bootstrap-version 6))
;  (unless (file-exists-p bootstrap-file)
;    (with-current-buffer
;        (url-retrieve-synchronously
;         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;         'silent 'inhibit-cookies)
;      (goto-char (point-max))
;      (eval-print-last-sexp)))
;  (load bootstrap-file nil 'nomessage))

;; straight.elでuse-packageを管理
;; これでuse-package単独の設定は不要(1-1の設定が不要)
;(straight-use-package 'use-package)
;; use-packageが自動的にstraight.elを使用するように設定
;(setq straight-use-package-by-default t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1-3.leafの設定
;; leafのインストールとブートストラップコード
(eval-and-compile
  ;; パッケージアーカイブを設定
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))

  ;; パッケージの初期化
  (package-initialize)

  ;; パッケージリストを更新（必要に応じてコメントアウト可）
  (unless package-archive-contents
    (package-refresh-contents))

  ;; leaf をインストール
  (unless (package-installed-p 'leaf)
    (package-install 'leaf))
  (use-package leaf :ensure t)

  ;; leaf-keywords をインストール
  (leaf leaf-keywords
    :ensure t
    :init
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2.straight.elを使用したパッケージのインストール(事前インストールするもの)

;(use-package request-deferred
;  :straight t
;  :config
;  ;; 必要に応じた設定を追加
;  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2.leafを使用したパッケージのインストール(事前インストールするもの)
;(leaf request-deferred
;  :ensure t
;  :config
;  ;; 必要に応じた設定を追加
;  )
;; request-deferredはMELPAにないのでdeferred
(leaf deferred
  :ensure t
  :doc "Simple and powerful deferred library for Emacs"
  :config
  ;; 必要に応じて初期設定をここに追加
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3.ロードパスの設定

;;サブディレクトリも読み込む関数
;;load-pathを追加する関数の定義
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

;;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4.環境変数の設定など
;; 環境がmacの場合、念の為環境変数を読み込ませる(本来は自動で読み込むがGUI版でうまく行かない場合がある？)

;; OS判定処理と変数格納
(defconst IS-MAC "MacOS")
(defconst IS-LINUX "Linux")
(defconst IS-WINDOWS "Windows")
(defconst IS-UNKNOWN "Unknown OS")

;; 起動したPCのOSを判定して、該当する文字列を保持する変数を定義
(setq current-os
      (cond
       ((eq system-type 'darwin) IS-MAC)       ;; macOS
       ((eq system-type 'gnu/linux) IS-LINUX)  ;; Linux
       ((eq system-type 'windows-nt) IS-WINDOWS) ;; Windows
       (t IS-UNKNOWN)))  ;; その他、未対応のOS

;; straight.elを使ってインストール
;(straight-use-package 'exec-path-from-shell)

;(when (memq window-system '(mac ns x))
;  (exec-path-from-shell-initialize))

;; leaf版
(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :ensure t
  :defun (exec-path-from-shell-initialize)
  :custom ((exec-path-from-shell-check-startup-files)
           (exec-path-from-shell-variables . '("PATH" "GOPATH" "JAVA_HOME")))
  :config
  (exec-path-from-shell-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5.GUI他基本設定
;; 基本設定のファイルを読み込み
;; 画面、キーバインド、SSH設定など
(load "init-base")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 6.独自変数の設定
;; 何か自作の変数を定義しておきたい場合はここに

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7.Gitの設定

;; git操作
(leaf magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :custom
  ((magit-display-buffer-function . 'magit-display-buffer-fullframe-status-v1))
  :config
  (setq magit-save-repository-buffers 'dontask))

;; GitHubやGitLabのリポジトリをEmacsから直接操作
(leaf forge
  :ensure t
  :after magit
  :config
  (setq forge-topic-list-limit '(60 . 0)))

;; Git差分表示
(leaf diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode t))

;; 履歴をさかのぼる
(leaf git-timemachine
  :ensure t
  :bind ("C-x t" . git-timemachine))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 8.自動補完機能と構文解析機能の設定
;;; 8-1.ivy
;(use-package ivy
;  :diminish
;  :bind (("C-s" . swiper)
;         :map ivy-minibuffer-map
;         ("TAB" . ivy-alt-done))
;  :config
;  (ivy-mode 1)
;  (setq ivy-use-virtual-buffers t
;        ivy-count-format "(%d/%d) "
;        enable-recursive-minibuffers t
;	ivy-height 20
;	ivy-extra-directories nil
;	ivy-re-builders-alist '((t . ivy--regex-plus))))

;; leaf版
;(leaf ivy
;  :ensure t
;  :diminish t
;  :bind (("C-s" . swiper)  ;; SwiperをC-sにバインド
;         :map ivy-minibuffer-map
;         ("TAB" . ivy-alt-done))  ;; TABでivy-alt-doneを実行
;  :custom ((ivy-use-virtual-buffers . t)  ;; 仮想バッファを有効化
;           (ivy-count-format . "(%d/%d) ") ;; ミニバッファの表示形式
;           (enable-recursive-minibuffers . t) ;; 再帰的ミニバッファを有効化
;           (ivy-height . 20)  ;; ivyの高さを20行に設定
;           (ivy-extra-directories . nil)  ;; `.`と`..`を非表示にする
;           (ivy-re-builders-alist . '((t . ivy--regex-plus)))) ;; 再構築関数をivy--regex-plusに設定
;  :config
;  (ivy-mode 1))  ;; ivyを有効化

(leaf ivy
  :ensure t
  ;;:diminish t
  :bind (("C-s" . swiper))  ;; SwiperをC-sにバインド
  :custom ((ivy-use-virtual-buffers . t)  ;; 仮想バッファを有効化
           (ivy-count-format . "(%d/%d) ") ;; ミニバッファの表示形式
           (enable-recursive-minibuffers . t) ;; 再帰的ミニバッファを有効化
           (ivy-height . 20)  ;; ivyの高さを20行に設定
           (ivy-extra-directories . nil)  ;; `.`と`..`を非表示にする
           (ivy-re-builders-alist . '((t . ivy--regex-plus)))) ;; 再構築関数をivy--regex-plusに設定
  :config
  (ivy-mode 1)  ;; ivyを有効化
  ;; 特定のキーマップにバインドを追加
  (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-alt-done))  ;; TABでivy-alt-doneを実行


;; use-packageを使っていなかった頃の設定
;(require 'ivy)
;(ivy-mode 1)
;(setq ivy-use-virtual-buffers t)
;(setq enable-recursive-minibuffers t)
;(setq ivy-height 20) ;; minibufferのサイズを拡大！（重要）
;(setq ivy-extra-directories nil)
;(setq ivy-re-builders-alist
;      '((t . ivy--regex-plus)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 8-2.counsel
;(use-package counsel
;  :after ivy
;  :bind (("M-x" . counsel-M-x)
;         ("C-x C-f" . counsel-find-file)
;         ("C-c k" . counsel-rg)
;         ("C-c g" . counsel-git)
;         ("C-c j" . counsel-file-jump)
;         ("C-x b" . ivy-switch-buffer)
;         ("C-x C-b" . ivy-switch-buffer)))

;(counsel-mode 1)
;;; 下記は任意で有効化
;(global-set-key "\C-s" 'swiper)
;(global-set-key (kbd "C-c C-r") 'ivy-resume)
;(global-set-key (kbd "<f6>") 'ivy-resume)
;(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;(global-set-key (kbd "C-c g") 'counsel-git)
;(global-set-key (kbd "C-c j") 'counsel-git-grep)
;(global-set-key (kbd "C-c k") 'counsel-ag)
;(global-set-key (kbd "C-x l") 'counsel-locate)
;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

;; これらは counsel-mode で自動で設定されるため、明示的に設定しなくてよい
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "<f1> f") 'counsel-describe-function)
;;(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;;(global-set-key (kbd "<f1> l") 'counsel-load-library)
;;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

;(defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))

;; leaf版
(leaf counsel
  :ensure t
  :after ivy  ;; ivyの後に読み込む
  :bind (("M-x" . counsel-M-x)                ;; M-xにcounsel-M-xをバインド
         ("C-x C-f" . counsel-find-file)     ;; C-x C-fでcounsel-find-file
         ("C-c k" . counsel-rg)              ;; C-c kでcounsel-rg
         ("C-c g" . counsel-git)             ;; C-c gでcounsel-git
         ("C-c j" . counsel-file-jump)       ;; C-c jでcounsel-file-jump
         ("C-x b" . ivy-switch-buffer)       ;; C-x bでivy-switch-buffer
         ("C-x C-b" . ivy-switch-buffer))    ;; C-x C-bでもivy-switch-buffer
  :config
  (counsel-mode 1)  ;; counselを有効化
  ;; 任意の追加キーバインド
  (global-set-key (kbd "C-s") 'swiper)             ;; C-sでswiper
  (global-set-key (kbd "C-c C-r") 'ivy-resume)     ;; C-c C-rでivy-resume
  ;; 隠しファイル/ディレクトリを無視する設定（例: "./", "../"）
  (setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7-3.flycheck
;(use-package flycheck
;  :straight t
;  :init (global-flycheck-mode)
;  :config
;  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled) ;; 自動起動
;        flycheck-idle-change-delay 2.0)  ;; コード変更後のチェックを遅延を2秒に設定
;  ;; 特定モードで無効化(org, markdown)
;  (add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))
;  (add-hook 'markdown-mode-hook (lambda () (flycheck-mode -1)))
;  ;; キーバインドを設定
;  (define-key flycheck-mode-map (kbd "C-c ! n") 'flycheck-next-error)
;  (define-key flycheck-mode-map (kbd "C-c ! p") 'flycheck-previous-error)
;  (define-key flycheck-mode-map (kbd "C-c ! l") 'flycheck-list-errors))

;; eslint 用の linter を登録
;(flycheck-add-mode 'javascript-eslint 'web-mode)

;; 作業している projectの node-module をみて、適切にlinterの設定を読み込む
;(eval-after-load 'web-mode
;  '(add-hook 'web-mode-hook #'add-node-modules-path))

;; leaf版
(leaf flycheck
  :ensure t
  :init
  (global-flycheck-mode)  ;; Flycheckをグローバルで有効化
  :custom
  ((flycheck-check-syntax-automatically . '(save idle-change mode-enabled))  ;; 自動チェックのタイミング
   (flycheck-idle-change-delay . 2.0) ;; チェックを2秒遅延
   (flycheck-python-flake8-executable . "flake8") ;; flake8を利用した構文チェック
   )
  :config
  ;; 特定モードでFlycheckを無効化
  (add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))
  (add-hook 'markdown-mode-hook (lambda () (flycheck-mode -1)))
  ;; Flycheckのキーバインドを設定
  (define-key flycheck-mode-map (kbd "C-c ! n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-c ! p") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "C-c ! l") 'flycheck-list-errors))

;; eslint 用の linter を登録
;(leaf :config
;  (flycheck-add-mode 'javascript-eslint 'web-mode))

;; 作業しているプロジェクトの node-modules を考慮
;(leaf add-node-modules-path
;  :ensure t
;  :hook (web-mode-hook . add-node-modules-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7-4.company (LSP & corfuにするので不要)
;(use-package company
;  :straight t
;  :hook (after-init . global-company-mode)
;  :config
;  (setq company-idle-delay 0.2                    ; 補完が表示されるまでの遅延時間
;        company-minimum-prefix-length 1            ; 補完が始まるまでの入力文字数
;        company-tooltip-align-annotations t        ; 右側を揃える
;        company-selection-wrap-around t)           ; 候補の一番下の次は一番上に戻る
;
;  ;; Eglotとの統合のため、company-backendsに'company-capfを設定
;  (setq company-backends '(company-capf))
;
;  ;; キーバインド設定
;  (define-key company-active-map (kbd "C-n") 'company-select-next)    ;; C-n, C-pで補完候補を次/前の候補を選択
;  (define-key company-active-map (kbd "C-p") 'company-select-previous)
;  (define-key company-search-map (kbd "C-n") 'company-select-next)
;  (define-key company-search-map (kbd "C-p") 'company-select-previous)
;  (define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む
;  (define-key company-active-map [tab] 'company-complete-selection)    ;; TABで候補を設定
;  (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)     ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
;  )
;
;
;(global-set-key (kbd "C-M-i") 'company-complete)

;; 自分は使わない
;(setq company-show-quick-access t)  ;; 必要に応じて無効化
;(setq company-tooltip-flip-when-above nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 8-5.Eglotの設定
;; 基本的なEgloのt設定
;(use-package eglot
;  :straight t
;  :hook ((html-mode . eglot-ensure)
;         (css-mode . eglot-ensure)
;         (web-mode . eglot-ensure)
;	 (sh-mode . eglot-ensure)
;         (js-mode . eglot-ensure)
;         (typescript-mode . eglot-ensure)
;         (java-mode . eglot-ensure)
;         (kotlin-mode . eglot-ensure)
;         (php-mode . eglot-ensure)
;         (perl-mode . eglot-ensure)
;         (ruby-mode . eglot-ensure)
;         (python-mode . eglot-ensure)
;         (erlang-mode . eglot-ensure)
;         (go-mode . eglot-ensure)
;         (rust-mode . eglot-ensure)
;         (csharp-mode . eglot-ensure)
;         (fsharp-mode . eglot-ensure)
;         (clojure-mode . eglot-ensure)
;	 ((c-mode c++-mode) . eglot-ensure)
;	 )
;  :config
;  ;; flymakeを無効にして、flycheckを使う
;  (add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
;  (add-to-list 'eglot-server-programs '(perl-mode . ("perl" "-MPerl::LanguageServer" "-e" "Perl::LanguageServer::run" "--" "--port" "13603"))))

;; eldocの設定
;(setq eldoc-echo-area-use-multiline-p nil)  ;; 複数行のエラーメッセージを無効化

;; Ivyとの連携
;(use-package ivy-xref
;  :straight t
;  :init
;  ;; xrefのUIをivyに変更
;  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

;; leaf版
;; Eglotの設定
(leaf eglot
  :ensure t
  ;:hook ()
  :custom
  (eldoc-echo-area-use-multiline-p . nil) ;; 複数行エラーメッセージ無効化
  :config
  ;; Flymakeを無効化してFlycheckを利用
  (add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1)))
  ;(add-to-list 'eglot-server-programs
  ;             '(perl-mode . ("perl" "-MPerl::LanguageServer" "-e" "Perl::LanguageServer::run" "--" "--port" "13603"))) ;; Perl用LSPサーバーを登録
  ;(add-to-list 'eglot-server-programs
  ;             '(css-mode . ("vscode-css-languageserver" "--stdio"))) ;; CSS他LSPサーバー
  ;(add-to-list 'eglot-server-programs
  ;             '(js2-mode . ("vscode-css-languageserver" "--stdio"))) ;; JS他LSPサーバー
  ;(add-to-list 'eglot-server-programs
  ;             '(terraform-mode . ("terraform-ls" "serve")))  ;; terraform-lsを使用

  ;; eglotがロードされた後にLSPサーバーを登録
  (eval-after-load 'eglot
    '(dolist (server '((perl-mode . ("perl" "-MPerl::LanguageServer" "-e" "Perl::LanguageServer::run" "--" "--port" "13603"))
                       (css-mode . ("vscode-css-languageserver" "--stdio"))
                       (js2-mode . ("vscode-eslint-language-server" "--stdio"))
                       (terraform-mode . ("terraform-ls" "serve"))))
       (add-to-list 'eglot-server-programs server))))


;; Corfuの設定
(leaf corfu
  :ensure t
  :init
  (global-corfu-mode)
  (setq corfu-auto t                   ;; 自動補完を有効化
        corfu-auto-delay 0.1           ;; 自動補完の遅延
        corfu-auto-prefix 1)           ;; 補完を始める文字数
  :hook (prog-mode . corfu-mode)
  :custom
  ((corfu-cycle . t))                 ;; 候補を循環
  :config
  ;; ミニバッファではCorfuを無効化
  (add-hook 'minibuffer-setup-hook
            (lambda () (setq-local corfu-auto nil))))

;; Ivyとxrefの連携
(leaf ivy-xref
  :ensure t
  :custom
  (xref-show-xrefs-function . #'ivy-xref-show-xrefs)) ;; xrefのUIをivyに変更

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 実験: Codeium API (コード生成AI)
(leaf codeium
  ;; MELPAに登録されていない
  ;:ensure t
  ;; :vcキーワードが使えない
  ;:vc ( :url "https://github.com/Exafunction/codeium.el"
  ;      :lisp-dir "elisp")
  :require t
  :init
  ;; 補完機能を追加
  ;; completion-at-point-functions に codeium-completion-at-point を追加
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  ;; 起動時に Codeium を初期化（オプション）
  (add-hook 'emacs-startup-hook
            (lambda () (run-with-timer 0.1 nil #'codeium-init)))
  :config
  ;; ポップアップダイアログを使用しない
  (setq use-dialog-box nil)
  ;; モードラインに Codeium のステータスを表示
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; 有効な API を制限
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
  ;; パフォーマンス向上のために送信文字列を制限
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)

  ;; 必要な初期セットアップを実行(導入後1回手動で実行すればよい。設定の中にある必要はない)
  ;(codeium-install)
  )

;; 必要に応じて API キーを設定
;; (setq codeium-api-key "YOUR_CODEIUM_API_KEY")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 9.各プログラミング言語の設定

;;;;; テキスト、設定ファイル系

;;org
(load "init-org")

;;yaml
(load "init-yaml")

;;Markdown
(load "init-markdown")

;;rst (Sphinx)
(load "init-rst")

;;Docker
(load "init-docker")

;;Terraform
(load "init-terraform")

;;;;; Web系(フロントエンド系)

;;web-mode
(load "init-html")

;;javascript
(load "init-js-jsx-ts")

;;;;; 他プログラミング言語

;;shell-pop
(load "init-shell")

;;php
(load "init-php")

;;perl
(load "init-perl")

;;ruby
(load "init-ruby")

;;python
(load "init-python")

;;Groovy
(load "init-groovy")

;;JVM(Java,Kotlin,Clojure)
(load "init-jvm")

;;MS(C#,F#)
(load "init-ms")

;;C/C++
(load "init-ccpp")

;;golang
;; golangがインストールされているMacでのみ動作させる
(when (eq system-type 'darwin)
  (load "init-golang")
)

;;Rust
(load "init-rust")

;;BEAM(Erlang,Elixir)
(load "init-beam")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 10.自動で編集されるcustom-set-variables
;; straight.elを利用しているので不要だが、straight.elをやめた時に備え残している
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(codeium/metadata/api_key "2699fb82-d815-443d-8b8e-709ed2e72d60")
 '(package-selected-packages
   '(valign solarized-theme rainbow-delimiters magit leaf-keywords flycheck diff-hl blackout)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
