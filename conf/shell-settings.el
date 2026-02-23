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

;; -------------------------------------------------------------------
;; 2. ポップアップターミナル (外部パッケージ)
;; -------------------------------------------------------------------

;;(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
;;(setq shell-pop-shell-type '("shell" "*shell*" (lambda () (shell))))
;;(setq shell-pop-shell-type '("terminal" "*terminal*" (lambda () (term shell-pop-term-shell))))
;;(setq shell-pop-shell-type '("ansi-term" "*ansi-term*" (lambda () (ansi-term shell-pop-term-shell))))
;; -> eshellを使う

(use-package shell-pop
  :ensure t
  :bind (("C-c s" . shell-pop))
  :custom
  (shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
  (shell-pop-window-size 30)
  (shell-pop-full-span nil))

(provide 'shell-settings)
;;; shell-settings.el ends here
