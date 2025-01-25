;;; init-rust.el --- Emacs initialization file
;;; Commentary:
;; このファイルは rust-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:


(leaf rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode) ;; Rustファイルに対応
  :hook ((rust-mode . eglot-ensure)  ;; LSPサーバーを有効化
         (rust-mode . (lambda ()
                        (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
                        (setq tab-width 4)          ;; タブ幅を4に設定
                        (setq rust-format-on-save t))))  ;; 保存時に自動フォーマット
  :custom ((rust-indent-offset . 4))  ;; インデント幅を4に設定
  :config
  ;; Cargo minor modeを有効化
  (leaf cargo
    :ensure t
    :hook (rust-mode . cargo-minor-mode))

  ;; Rust専用のeldocを有効化
  ;(leaf rust-eldoc
  ;  :ensure t
  ;  :hook (rust-mode . rust-eldoc-mode))

  ;; FlycheckをRustで有効化
  (leaf flycheck-rust
    :ensure t
    :after flycheck
    :hook (flycheck-mode . flycheck-rust-setup))

  ;; 必要に応じた追加の設定
  (message "Rust mode configured successfully!"))

(provide 'init-rust)
;;; init-rust.el ends here
