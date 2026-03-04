;;; terraform-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(use-package terraform-mode
  :ensure t
  :mode (("\\.ts\\'" . terraform-mode)
         ("\\.tsvars\\'" . terraform-mode))
  :hook ((terraform-mode . eglot-ensure)
         (terraform-mode . flymake-mode)
         (terraform-mode . terraform-format-on-save-mode))
  :custom
  (terraform-indent-level 2)
  ;:config
  ;  (add-to-list 'eglot-server-programs
  ;               '(terraform-mode . ("terraform-ls"))) ;; Eglotが自動認識？
)

(provide 'terraform-settings)
;;; terraform-settings.el ends here
