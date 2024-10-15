;;; init-terraform.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; terraform-mode の導入
(use-package terraform-mode
  :straight t
  :mode "\\.tf\\'")

;;; init-terraform.el ends here
