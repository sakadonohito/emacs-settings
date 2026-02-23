;;; docker.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; Emacs 29以降標準搭載の Tree-sitter 版を使用
(use-package dockerfile-ts-mode
  ;; 組み込み機能のため外部からのインストールは不要
  :mode ("Dockerfile\\'" . dockerfile-ts-mode)
  :hook (dockerfile-ts-mode . eglot-ensure))

(provide 'docker)
;;; docker.el ends here
