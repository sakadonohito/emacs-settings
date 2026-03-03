;;; ruby-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは ruby-modeの設定ファイルです
;;; Code:

;; --------------------------------------------------
;; 1. Rubyの設定
;; --------------------------------------------------
(use-package ruby-ts-mode
  :ensure nil ; Emacs組み込み
  :init
  ;; 既存の ruby-mode を ruby-ts-mode にリマップ
  (add-to-list 'major-mode-remap-alist '(ruby-mode . ruby-ts-mode))
  :mode (("\\.rb\\'" . ruby-ts-mode)
         ("Rakefile\\'" . ruby-ts-mode)
         ("Gemfile\\'" . ruby-ts-mode)
         ("Vagrantfile\\'" . ruby-ts-mode)
         ("\\.gemspec\\'" . ruby-ts-mode)
         ("\\.rake\\'" . ruby-ts-mode)
         ("\\.ru\\'" . ruby-ts-mode)
         ("\\.thor\\'" . ruby-ts-mode))
  :hook ((ruby-ts-mode . eglot-ensure)
         ;; 保存時に自動でインデントを整える設定（おすすめ）
         ;(ruby-ts-mode . (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
         )
  :custom
  ;; Rubyの標準トレンドであるインデント2を設定
  (ruby-ts-mode-indent-level 2)
  (ruby-ts-mode-indent-tabs-mode nil)
  :config
  ;; EglotにRuby用LSPサーバーを追加
  ;; トレンドは "ruby-lsp" (Shopify製) または "solargraph" です
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 `(ruby-ts-mode . ("bundle" "exec" "ruby-lsp")))) ; または "solargraph" "bundle" "exec" "ruby-lsp"

  ;; ruby-ts-modeでの追加の強調表示設定
  ;(setq treesit-font-lock-level 4) ;; ToDo: これはtree-sitterの共通設定を変更してしまうのでは？

)

;; --------------------------------------------------
;; Rails開発などをする場合
;; --------------------------------------------------

(use-package yard-mode
  :ensure t
  :hook (ruby-ts-mode . yard-mode))

(use-package inf-ruby
  :hook (ruby-ts-mode . inf-ruby-minor-mode)
  :config
  (inf-ruby-switch-setup))  ;; pry を優先

(use-package ruby-extra-highlight
  :ensure t
  :hook (ruby-ts-mode . ruby-extra-highlight-mode))

(provide 'ruby-settings)
;;; ruby-settings.el ends here
