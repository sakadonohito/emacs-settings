;;; init-terraform.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; terraform-mode の導入
;(use-package terraform-mode
;  :straight t
;  :mode "\\.tf\\'")

(leaf terraform-mode
  :ensure t
  :mode ("\\.tf\\'" . terraform-mode)  ;; `.tf`拡張子でterraform-modeを有効化
  :hook (terraform-mode . eglot-ensure))  ;; terraform-modeでeglotを有効化

(provide 'init-terraform)
;;; init-terraform.el ends here
