;;; eglot-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルはEglotに関する初期設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-4. Eglotの設定 (Built-in + eglot-booster)
;; ====================================================================

;; --------------------------------------------------
;; 1. Emacs標準の Eglot の設定
;; --------------------------------------------------
(use-package eglot
  :ensure nil ;; Emacs 29から標準搭載のため外部インストール不要
  :custom
  (eldoc-echo-area-use-multiline-p nil) ;; eldocの設定：複数行エラーメッセージ無効化
  (eglot-autoshutdown t)
  ;; (オプション) さらに高速化したい場合は、Eglotの内部ログ出力を無効化します
  (eglot-events-buffer-size 0)
  (eglot-ignored-server-capabilities '(:workspace/didChangeWorkspaceFolders)) ;; 警告抑制
  ;:config
  ;; eglotがロードされた後にLSPサーバーを登録
  ;; groovyのLSP jarファイルのためにletを使う
  ;(setq eglot-server-programs nil)
;  (let ((groovy-lsp-jar (expand-file-name "servers/groovy-language-server-all.jar" user-emacs-directory))
;        (java-home "/usr/local/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"))
;    (dolist (server `(
;                      ;; --- 汎用・単機能サーバー ---
;                      ;(nxml-mode . ("lemminx"))
;                      ;(json-ts-mode . ("vscode-json-language-server" "--stdio"))
;                      ;((yaml-ts-mode yaml-mode) . ("yaml-language-server" "--stdio"))
;                      ;(markdown-ts-mode . ("marksman" "server"))
;                      ;(html-mode . ("vscode-html-language-server" "--stdio"))
;                      ;((css-mode css-ts-mode scss-mode) . ("vscode-css-language-server" "--stdio"))
;                      ;(web-mode . ("vscode-html-language-server" "--stdio"))
;
;                      ;; --- メインの言語サーバー (一番最後に評価されるように) ---
;                      ;((js-ts-mode tsx-ts-mode typescript-ts-mode) . ("typescript-language-server" "--stdio"))
;                      ;((sh-mode bash-ts-mode) . ("bash-language-server" "start"))
;                      ;(dockerfile-ts-mode . ("docker-langserver" "--stdio"))
;                      ;(terraform-mode . ("terraform-ls" "serve"))
;                      ;(perl-mode . ("perl" "-MPerl::LanguageServer" "-e" "Perl::LanguageServer::run" "--" "--port" "13603"))
;                      ;((cperl-mode) . ("perlnavigator" "--stdio"))
;                      ;(python-ts-mode . ("pyright-langserver" "--stdio"))
;
;                      ;((java-mode java-ts-mode) . ("jdtls"))
;                      ;((kotlin-mode kotlin-ts-mode) . ("kotlin-language-server"))
;                      ;((clojure-mode clojurescript-mode clojurec-mode clojure-ts-mode) . ("clojure-lsp"))
;                      ;((scala-mode) . ("metals"))
;                      ;(groovy-mode . ("java"
;                      ;                ,(concat "-Djava.home=" java-home)
;                      ;                "-jar" ,groovy-lsp-jar))
;                      ))
;      (add-to-list 'eglot-server-programs server)))
  )

;; --------------------------------------------------
;; 2. eglot-booster の設定 (LSP通信のJSONパースを爆速化)
;; ※注意: 動作させるにはOS側に `emacs-lsp-booster` コマンドがインストールされている必要があります
;; https://github.com/jdtsmith/eglot-boosterはpackage-vc-installからインストール済み
;; --------------------------------------------------
(use-package eglot-booster
  :if (executable-find "emacs-lsp-booster")
  :after eglot
  :ensure nil
  :config
  (eglot-booster-mode 1))

;; --------------------------------------------------
;; eldocの拡張
;; --------------------------------------------------
(use-package eldoc-box
  ;; GUI環境の時だけ有効化するための安全策
  :if (display-graphic-p)
  :ensure t
  :bind (;; ショートカットで好きな時だけポップアップさせたい場合
         ("C-c h" . eldoc-box-help-at-point))
  :config
  ;; もし「カーソルを合わせたら自動でポップアップしてほしい」場合は
  ;; 以下のコメントアウトを外します（少し画面がうるさく感じる方もいます）
  ;; (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode)

  ;; ポップアップの見た目を少し調整
  (set-face-attribute 'eldoc-box-border nil :background "gray30")
  (setq eldoc-box-max-pixel-width 600
        eldoc-box-max-pixel-height 400))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'eglot-settings)
;;; eglot-settings.el ends here
