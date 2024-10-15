;;; init-yaml.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; yaml-mode の導入
(use-package yaml-mode
  :straight t
  :mode "\\.yml\\'")

;;; init-yaml.el ends here
