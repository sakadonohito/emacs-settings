;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 設定でやりたいこと
;; 1. ロードパスの設定(配下のサブディレクトリも読み込む、自作のディレクトリもパスに含める)
;; 2. 環境変数の読み込み
;; 3. パッケージ管理の設定
;; 	- use-package
;; 	- straight.el
;; 4. GUIの設定(見た目、色など/neotree)
;; 5. 独自変数の設定
;; 6. Gitの設定
;; 7. 自動補完機能の設定
;; 	- Ivy
;; 	- Counsel
;; 	- Company
;; 	- LSP
;; 	- GitHub Copilot
;; 8. 構文解析の設定(Flycheck)
;; 9. 各プログラミング言語の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 当面のエラー回避策
;;; (require 'cl) を見逃す
;; 現在は、clパッケージをcl-libに置き換えるのが推奨されているため、この設定はあえて無効にする。
;(setq byte-compile-warnings '(not cl-functions obsolete))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1.ロードパスの設定

;;サブディレクトリも読み込む関数
;;load-pathを追加する関数の定義
(defun add-to-load-path (&rest paths)
  (let (path)
	(dolist (path paths paths)
	  (let ((default-directory
			  (expand-file-name (concat user-emacs-directory path))))
		(add-to-list 'load-path default-directory)
		(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
			(normal-top-level-add-subdirs-to-load-path))))))

;;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
;(add-to-load-path "elisp" "conf" "public_repos")
(add-to-load-path "elisp" "conf")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2.環境変数の設定
;; 環境がmacの場合、念の為環境変数を読み込ませる(本来は自動で読み込むがGUI版でうまく行かない場合がある？)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3.パッケージ管理の設定
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; 2024年10月現在も必要な処理か不明
(fset 'package-desc-vers 'package-ac-desc-version)
;;
;; パッケージリストの初期化
(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3-1.use-packageの設定
;; straight.elを利用するのでこの設定は不要
;(require 'use-package)
;(setq use-package-always-ensure t)  ;; パッケージがなければ自動インストール
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3-2.straight.elの設定
;; straight.elのブートストラップコード
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; straight.elでuse-packageを管理
;; これでuse-package単独の設定は不要(3-1の設定が不要)
(straight-use-package 'use-package)

;; use-packageが自動的にstraight.elを使用するように設定
(setq straight-use-package-by-default t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4.GUI他基本設定
;; 基本設定のファイルを読み込み
;; 画面、キーバインド、SSH設定など
(load "init-base")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5.独自変数の設定

;(custom-set-variables
; ;; custom-set-variables was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
; '(package-selected-packages
;   (quote
;	(counsel ivy helm exec-path-from-shell go-autocomplete go-eldoc go-mode tss typescript-mode package-utils visual-regexp magit terraform-mode yaml-mode web-mode w3m shell-pop rjsx-mode rinari redo+ python-mode phpunit php-extras php-eldoc perl6-mode neotree mkdown magit-find-file json-mode haml-mode flymake-jshint flymake-go flymake flycheck emmet-mode elixir-mix dockerfile-mode company-web company-shell company-go company-ansible auto-install auto-complete-clang anything-show-completion anything-obsolete anything-match-plugin anything-ipython anything-git-goto anything-git anything-exuberant-ctags anything-extension anything-el-swank-fuzzy anything-config anything-complete ac-python ac-php ac-ja ac-html-bootstrap ac-html ac-alchemist))))
;(custom-set-faces
; ;; custom-set-faces was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
; )
;(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(use-package request request-deferred rjsx-mode typescript-mode php-mode yaml-mode haml-mode neotree rainbow-delimiters js2-mode tide go-autocomplete go-eldoc go-mode company-ghc haskell-mode dimmer color-identifiers-mode git-gutter+ flycheck company counsel visual-regexp terraform-mode rinari redo+ phpunit php-eldoc package-utils mkdown magit-find-file exec-path-from-shell elixir-mix dockerfile-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 6.Gitの設定
;; git gutter (git diff の差分表示設定)
(global-git-gutter+-mode 1)

;; modifyされた箇所で実行すると、diffをinlineでみることができる
(global-set-key (kbd "C-x C-v") 'git-gutter+-show-hunk-inline-at-point)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7.自動補完機能の設定

;;; 7-1.ivy
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 20) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))


;;; 7-2.counsel
(counsel-mode 1)
;;; 下記は任意で有効化
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

;; これらは counsel-mode で自動で設定されるため、明示的に設定しなくてよい
;;(global-set-key (kbd "M-x") 'counsel-M-x)
;;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;(global-set-key (kbd "<f1> f") 'counsel-describe-function)
;;(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;;(global-set-key (kbd "<f1> l") 'counsel-load-library)
;;(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)

;(defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))


;;; 7-3.company
(require 'company)
(global-company-mode) ;全バッファで有効
(setq company-selection-wrap-around t) ;候補の一番下の次は一番上に戻る

(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n, C-pで補完候補を次/前の候補を選択
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
;(define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む
;(define-key company-active-map (kbd "C-i") 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
;(define-key company-active-map (kbd "C-f") 'company-complete-selection) ;; C-fで候補を設定
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete) ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う


;;; 7-1.ivy ※元々はcompanyの後に記述していた
;(require 'ivy)
;(ivy-mode 1)
;(setq ivy-use-virtual-buffers t)
;(setq enable-recursive-minibuffers t)
;(setq ivy-height 20) ;; minibufferのサイズを拡大！（重要）
;(setq ivy-extra-directories nil)
;(setq ivy-re-builders-alist
;      '((t . ivy--regex-plus)))

;;; 7-2.counsel  ※元々はcompany,Ivyの後に記述していた
;(counsel-mode 1)
;;;; 下記は任意で有効化
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 実験: Codeium API (コード生成AI)
;(require 'request)
;
;(defvar codeium-api-key "your-api-key-here"
;  "Codeium API key.")
;
;(defun codeium-get-completion (prompt)
;  "Send a completion request to Codeium API with PROMPT."
;  (interactive "sPrompt: ")
;  (let ((url "https://api.codeium.com/v1/completions")
;        (data (json-encode `(("model" . "code-completion-model")
;                             ("prompt" . ,prompt)
;                             ("max_tokens" . 100)))))
;    (request
;     url
;     :type "POST"
;     :headers `(("Content-Type" . "application/json")
;                ("Authorization" . ,(concat "Bearer " codeium-api-key)))
;     :data data
;     :parser 'json-read
;     :success (cl-function
;               (lambda (&key data &allow-other-keys)
;                 (let ((completion (assoc-default 'text (aref (assoc-default 'choices data) 0))))
;                   (insert completion))))))))
;
;;; 実験: Codeium API (コード生成AI) company連携
;(defun company-codeium-backend (command &optional arg &rest ignored)
;  "Codeium backend for company-mode."
;  (interactive (list 'interactive))
;  (cl-case command
;    (interactive (company-begin-backend 'company-codeium-backend))
;    (prefix (company-grab-symbol))
;    (candidates
;     (let ((prompt arg)
;           (completions nil))
;       (codeium-get-completion prompt)
;       completions))))
;
;(add-to-list 'company-backends 'company-codeium-backend)
;(global-set-key (kbd "C-c C-o") 'codeium-get-completion)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7-5.Codeiumの設定
;; we recommend using use-package to organize your init.el
(use-package codeium
  :straight (:type git :host github :repo "Exafunction/codeium.el")
  :init
  ;; use globally
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  ;; or on a hook
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

  ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local completion-at-point-functions
  ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
  ;; an async company-backend is coming soon!

  ;; codeium-completion-at-point is autoloaded, but you can
  ;; optionally set a timer, which might speed up things as the
  ;; codeium local language server takes ~0.2s to start up
  ;; (add-hook 'emacs-startup-hook
  ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

  ;; :defer t ;; lazy loading, if you want
  :config
  (setq use-dialog-box nil) ;; do not use popup boxes

  ;; if you don't want to use customize to save the api-key
  ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

  ;; get codeium status in the modeline
  (setq codeium-mode-line-enable
        (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
  (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
  ;; alternatively for a more extensive mode-line
  ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

  ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
  (setq codeium-api-enabled
        (lambda (api)
          (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
  ;; you can also set a config for a single buffer like this:
  ;; (add-hook 'python-mode-hook
  ;;     (lambda ()
  ;;         (setq-local codeium/editor_options/tab_size 4)))

  ;; You can overwrite all the codeium configs!
  ;; for example, we recommend limiting the string sent to codeium for better performance
  (defun my-codeium/document/text ()
    (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
  ;; if you change the text, you should also change the cursor_offset
  ;; warning: this is measured by UTF-8 encoded bytes
  (defun my-codeium/document/cursor_offset ()
    (codeium-utf8-byte-length
     (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
  (setq codeium/document/text 'my-codeium/document/text)
  (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 8.flycheck
;(add-hook 'after-init-hook #'global-flycheck-mode)
;; 自動起動
(setq flycheck-check-syntax-automatically
	  '(save idle-change mode-enabled))

;; コード変更後、3秒後にチェックする
(setq flycheck-idle-change-delay 3)

;; eslint 用の linter を登録
;(flycheck-add-mode 'javascript-eslint 'web-mode)

;; 作業している projectの node-module をみて、適切にlinterの設定を読み込む
;(eval-after-load 'web-mode
;  '(add-hook 'web-mode-hook #'add-node-modules-path))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 9.各プログラミング言語の設定

;;shell-pop
;(load "init-shell")

;;web-mode
(load "init-html")

;;javascript
;(load "init-js")
;(load "init-ts")
;(load "init-jsx")

;;php
;(load "init-php")

;;perl
;(load "init-perl")

;;yaml
;(load "init-yaml")

;;ruby
;(load "init-ruby")

;;python
;(load "init-python")

;;Groovy
;(load "init-groovy")

;;rst (Sphinx)
;(load "init-rst")

;;rst (Markdown)
;(load "init-markdown")

;;org
;;;(load "init-org")

;;Elixir(Erlang beam)
;(load "init-elixir")

;;golang
;;; golangがインストールされているMacでのみ動作させる
;;;(when (eq system-type 'darwin)
;;;  (load "init-golang")
;;;)

;;Haskell
;;;(load "init-haskell")
