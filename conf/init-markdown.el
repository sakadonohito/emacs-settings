;;; init-markdown.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; markdown-mode の導入
(use-package markdown-mode
  :straight t
  :mode "\\.md\\'"
  :init
  (setq markdown-command "multimarkdown"))

;;; init-markdown.el ends here
