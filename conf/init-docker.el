;;; init-docker.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; dockerfile-mode の導入
(use-package dockerfile-mode
  :straight t
  :mode "Dockerfile\\'")

;;; init-docker.el ends here
