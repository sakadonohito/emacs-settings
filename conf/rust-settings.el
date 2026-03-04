;;; rust-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは rust-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Rust
;; --------------------------------------------------

;; 念のため、rust の文法が利用可能かチェック
;(when (treesit-ready-p 'rust)
;  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))

(use-package rust-ts-mode
  :ensure nil
  :after treesit
  :mode (("\\.rs\\'" . rust-ts-mode))
  :init
  ;; 1. 起動時にTOML文法が利用可能かチェックして紐付け
  ;(when (treesit-ready-p 'rust)
  ;  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode)))
  ;(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))
  ;; 従来の rust-mode を tree-sitter 版にリマップ
  (add-to-list 'major-mode-remap-alist '(rust-mode . rust-ts-mode))
  :hook
  (rust-ts-mode . eglot-ensure)
  :custom
  (setq treesit-font-lock-level 4) ;; ToDo: 全体に波及しない？
  ;; Rustの標準インデントは 4
  (setq rust-ts-mode-indent-offset 4)
  (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
  (setq tab-width 4)          ;; タブ幅を4に設定
  :config


  ;; Eglotの設定 (rust-analyzer)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(rust-ts-mode . ("rust-analyzer"))))

  ;; rust-analyzerの詳細設定（お好みで調整してください）
  (setq eglot-workspace-configuration
        '((:rust-analyzer
           (checkOnSave . t)
           (check
            (command . "clippy"))
           (inlayHints
            (typeHints . t)
            (parameterHints . t)
            (lifetimeElisionHints . t)
            (closureReturnTypeHints . t)
            (reborrowHints . t))
           (procMacro
            (enable . t))
           (rustfmt
            (enable . t))
           (assist
            (importEnforceGranularity . t)
            (importPrefix . "crate"))))) ;; End eglot-workspace-configuration
  ) ;; End use-package


;  (setq-default eglot-workspace-configuration
;                '((:rust-analyzer . (
;                                     ;; 編集中の保存時に cargo check を走らせる
;                                     :checkOnSave (:command "clippy")
;                                                  :inlayHints (:enable t
;                                                                       :lifetimeElisionHints (:enable "skip_trivial")
;                                                                       :closureReturnTypeHints (:enable "always")
;                                                                       :reborrowHints (:enable "enable"))
;                                                  :procMacro (:enable t)
;                                                  :format (:enable t)                ; on saveでrustfmt
;                                                  :assist (:importEnforceGranularity t
;                                                                                     :importPrefix "crate")
;                                                  :cargo (:features "all"))))))  ; features全部見る


;; --------------------------------------------------
;; Cargo
;; --------------------------------------------------
;; なんかエラー出たりでうまくいかないので無効に
;(use-package cargo
;  :ensure t
;  :hook (rust-ts-mode . cargo-minor-mode)
;  :bind (:map cargo-minor-mode-map
;              ("C-c C-c C-r" . cargo-process-run)
;              ("C-c C-c C-t" . cargo-process-test)
;              ("C-c C-c C-b" . cargo-process-build)))

(provide 'rust-settings)
;;; rust-settings.el ends here
