;;; docker.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; Emacs 29以降標準搭載の Tree-sitter 版を使用
(use-package dockerfile-ts-mode
  :ensure nil
  :init
  ;; 旧モードを呼び出そうとしても強制的に Tree-sitter 版へ転送
  (add-to-list 'major-mode-remap-alist '(dockerfile-mode . dockerfile-ts-mode))
  :mode ("Dockerfile\\'" . dockerfile-ts-mode)
  :hook
  (dockerfile-ts-mode . eglot-ensure))

(provide 'docker)
;;; docker.el ends here
