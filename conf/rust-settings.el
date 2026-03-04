;;; rust.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは rust-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Rust
;; --------------------------------------------------
(use-package rust-ts-mode
  :ensure nil
  :after treesit
  :mode (("\\.rs\\'" . rust-ts-mode))
  :init
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
  ;; 従来の rust-mode を tree-sitter 版にリマップ
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))
  :hook
  (rust-ts-mode . eglot-ensure)
  :config
  (setq treesit-font-lock-level 4) ;; ToDo: 全体に波及しない？
  ;; Rustの標準インデントは 4
  (setq rust-ts-mode-indent-offset 4)
  (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
  (setq tab-width 4)          ;; タブ幅を4に設定

  ;; Eglotの設定 (rust-analyzer)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(rust-ts-mode . ("rust-analyzer"))))

  ;; rust-analyzerの詳細設定（お好みで調整してください）
  (setq-default eglot-workspace-configuration
                '((:rust-analyzer . (
                                     ;; 編集中の保存時に cargo check を走らせる
                                     :checkOnSave (:command "clippy")
                                                  :inlayHints (:enable t
                                                                       :lifetimeElisionHints (:enable "skip_trivial")
                                                                       :closureReturnTypeHints (:enable "always")
                                                                       :reborrowHints (:enable "enable"))
                                                  :procMacro (:enable t)
                                                  :format (:enable t)                ; on saveでrustfmt
                                                  :assist (:importEnforceGranularity t
                                                                                     :importPrefix "crate")
                                                  :cargo (:features "all"))))))  ; features全部見る


;; --------------------------------------------------
;; Cargo
;; --------------------------------------------------
(use-package cargo
  :ensure t
  :hook (rust-ts-mode . cargo-minor-mode)
  :bind (:map cargo-minor-mode-map
              ("C-c C-c C-r" . cargo-process-run)
              ("C-c C-c C-t" . cargo-process-test)
              ("C-c C-c C-b" . cargo-process-build)))



;(leaf rust-mode
;  :ensure t
;  :mode ("\\.rs\\'" . rust-mode) ;; Rustファイルに対応
;  :hook ((rust-mode . eglot-ensure)  ;; LSPサーバーを有効化
;         (rust-mode . (lambda ()
;                        (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
;                        (setq tab-width 4)          ;; タブ幅を4に設定
;                        (setq rust-format-on-save t))))  ;; 保存時に自動フォーマット
;  :custom ((rust-indent-offset . 4))  ;; インデント幅を4に設定
;  :config
;  ;; Cargo minor modeを有効化
;  (leaf cargo
;    :ensure t
;    :hook (rust-mode . cargo-minor-mode))
;
;  ;; Rust専用のeldocを有効化
;  ;(leaf rust-eldoc
;  ;  :ensure t
;  ;  :hook (rust-mode . rust-eldoc-mode))
;
;  ;; FlycheckをRustで有効化
;  (leaf flycheck-rust
;    :ensure t
;    :after flycheck
;    :hook (flycheck-mode . flycheck-rust-setup))
;
;  ;; 必要に応じた追加の設定
;  (message "Rust mode configured successfully!"))

;; LSP他
;; rustup component add rust-analyzer
;; rustup component add rustfmt ;; フォーマットツール
;; cargo


(provide 'rust)
;;; rust.el ends here
