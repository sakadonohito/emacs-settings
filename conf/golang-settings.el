;;; golang-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは go-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Go
;; --------------------------------------------------
(use-package go-ts-mode
  :mode (("\\.go\\'" . go-ts-mode)
         ("\\.mod\\'" . go-mod-ts-mode)
         ("\\.work\\'" . go-ts-mode)) ; go.work も対象
  :init
  ;; 従来の go-mode を tree-sitter 版にリマップ
  (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
  :hook
  (go-ts-mode . eglot-ensure)
  ;; 保存時にフォーマットとインポートの整理を実行
  ;(go-ts-mode . (lambda ()
  ;                (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
  :config
  ;; Go の標準インデント（タブ幅8が公式標準だが、表示上の幅を4にするのが一般的）
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode t) ; Goはタブインデントが絶対ルール

  ;; Eglot の LSP サーバー設定 (gopls)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(go-ts-mode . ("gopls"))))

  ;; gopls の詳細設定（インラインヒントなどを有効化）
  (setq-default eglot-workspace-configuration
                '((:gopls . (
                             ;; パラメータ名などのインライン表示
                             :hints ( :assignVariableTypes t
                                      :compositeLiteralFields t
                                      :compositeLiteralTypes t
                                      :constantValues t
                                      :functionTypeParameters t
                                      :parameterNames t
                                      :rangeVariableTypes t)
                             ;; 静的解析の強化
                             :analyses ((nilness . t)
                                        (unusedparams . t)
                                        (unusedwrite . t))
                             :staticcheck t)))))

;(use-package gotest
;  :ensure t
;  :bind (:map go-ts-mode-map
;              ("C-c C-t t" . go-test-current-test)
;              ("C-c C-t f" . go-test-current-file)
;              ("C-c C-t p" . go-test-current-project)
;              ("C-c C-t b" . go-test-current-benchmark)))


;; --------------------------------------------------
;; Toml
;; --------------------------------------------------
;; LSP入れるほどじゃないかな。。
(use-package toml-ts-mode
  :mode "\\.toml\\'"
  :init
  ;; 1. 起動時にTOML文法が利用可能かチェックして紐付け
  (when (treesit-ready-p 'toml)
    (add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-ts-mode)))
  :config
  ;; インデント設定（通常は2か4）
  (setq toml-ts-mode-indent-offset 2))



(provide 'golang-settings)
;;; golang-settings.el ends here
