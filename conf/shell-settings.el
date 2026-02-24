;;; shell-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; -------------------------------------------------------------------
;; 1. シェルスクリプト編集モード (Emacs標準機能)
;; -------------------------------------------------------------------
(use-package sh-script
  :ensure nil ;; 標準機能のため外部インストール不要
  :mode (("\\.sh\\'" . sh-mode)
         ("\\.zsh\\'" . sh-mode))
  :hook (sh-mode . eglot-ensure)
  :custom
  (sh-basic-offset 2)
  (sh-indentation 2))

(provide 'shell-settings)
;;; shell-settings.el ends here
