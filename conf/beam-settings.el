;;; beam-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは BEAM系言語の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Elixir
;; --------------------------------------------------
(use-package elixir-ts-mode
  :mode
  ;; elixir-ts-modeを適用する拡張子
  (("\\.ex\\'" . elixir-ts-mode)
   ("\\.exs\\'" . elixir-ts-mode)
   ("mix\\.lock\\'" . elixir-ts-mode))
  :init
  ;; 従来のelixir-modeをtree-sitter版にリマップ
  (add-to-list 'major-mode-remap-alist '(elixir-mode . elixir-ts-mode))
  :hook
  ;; 保存時にフォーマットを実行（任意）し、Eglotを起動
  (elixir-ts-mode . eglot-ensure)
  :config
  ;; インデント設定（Elixirの標準は2）
  (setq-default elixir-ts-indent-offset 2)

  ;; EglotのLSPサーバー設定 (ElixirLSを想定)
  ;; パスが通っていない場合は、絶対パスで指定してください
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(elixir-ts-mode . ("elixir-ls")))))
               ;;'(elixir-ts-mode . ("language_server.sh")))))
;; Elixir特有のツール: HexやMixコマンドをEmacsから呼び出す
;; パッケージの内容が古い可能性があるため不採用
;(use-package mix
;  :ensure t
;  :hook (elixir-ts-mode . mix-minor-mode))

;; Mixの代替
(use-package exunit
  :ensure t
  :hook (elixir-ts-mode . exunit-mode)
  :bind (:map elixir-ts-mode-map
              ;; C-c , v で現在のテストを実行、といった具合に便利になります
              ("C-c , v" . exunit-verify)
              ("C-c , a" . exunit-verify-all))
  :config
  ;; テスト実行時に自動的にバッファを保存する設定
  (setq exunit-save-all-buffers-before-run t))

;; HTMLテンプレート HEEx
(use-package heex-ts-mode
  :mode "\\.heex\\'"
  :init
  (add-to-list 'major-mode-remap-alist '(heex-mode . heex-ts-mode))
  :hook (heex-ts-mode . eglot-ensure))


;; --------------------------------------------------
;; Erlang
;; --------------------------------------------------
(use-package erlang-ts
  :ensure t ; erlang-ts-modeが標準入りしていても、syntax設定等のためerlangパッケージを推奨
  :mode
  (("\\.erl\\'" . erlang-ts-mode)
   ("\\.hrl\\'" . erlang-ts-mode)
   ("\\.app\\.src\\'" . erlang-ts-mode)
   ("rebar\\.config\\'" . erlang-ts-mode))
  :init
  (add-to-list 'major-mode-remap-alist '(erlang-mode . erlang-ts-mode))
  :hook
  (erlang-ts-mode . eglot-ensure)
  :config
  ;; インデント設定（Erlangの標準は4が一般的）
  (setq-default erlang-indent-level 4)

  ;; EglotのLSPサーバー設定 (erlang_lsを想定)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(erlang-ts-mode . ("elp" "server")))))


;(leaf erlang
;  :ensure t
;  :mode ("\\.erl\\'" . erlang-mode) ;; Erlangファイルに対応
;  :hook ((erlang-mode . eglot-ensure)  ;; LSPサーバーを有効化
;         (erlang-mode . (lambda ()
;                          (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
;                          (setq tab-width 4))))        ;; タブ幅を4に設定
;  :config
;  ;; 保存時にコードを自動フォーマット
;  (add-hook 'before-save-hook
;            (lambda ()
;              (when (eq major-mode 'erlang-mode)
;                (eglot-format-buffer))))
;  :custom ((erlang-indent-level . 4))) ;; インデント幅を4に設定


;(leaf elixir-mode
;  :ensure t
;  :mode ("\\.ex\\'" . elixir-mode)   ;; Elixirファイルに対応
;  :hook ((elixir-mode . eglot-ensure)  ;; LSPサーバーを有効化
;         (elixir-mode . (lambda ()
;                          (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
;                          (setq tab-width 2))))        ;; タブ幅を2に設定
;  :custom ((elixir-indent-level . 2))  ;; インデント幅を2に設定
;  :config
;  ;; 保存時にコードを自動フォーマット
;  (add-hook 'before-save-hook
;            (lambda ()
;              (when (eq major-mode 'elixir-mode)
;                (eglot-format-buffer))))
;  ;; Mix integration
;  (leaf mix
;    :ensure t
;    :hook (elixir-mode . mix-minor-mode))

;  ;; Alchemist（Elixir専用ツール）を有効化する場合
;  ;; 非推奨になりつつあるため慎重に検討
;  ;; (leaf alchemist
;  ;;   :ensure t
;  ;;   :hook (elixir-mode . alchemist-mode))
;  )


;; LSP
;; asdf plugin add erlang
;; asdf install erlang <バージョン>
;; asdf global erlang <バージョン>


(provide 'beam-settings)
;;; beam-settings.el ends here
