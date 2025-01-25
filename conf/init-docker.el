;;; init-docker.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; dockerfile-mode の導入
;(use-package dockerfile-mode
;  :straight t
;  :mode "Dockerfile\\'")

;; leaf版
(leaf dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'")  ;; "Dockerfile"という名前のファイルに適用
  :hook (dockerfile-mode . eglot-ensure))  ;; LSPサーバーを有効化

;; LSP
;; npm install -g dockerfile-language-server-nodejs

(provide 'init-docker)
;;; init-docker.el ends here
