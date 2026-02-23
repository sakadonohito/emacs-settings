;;; yaml.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;; leafやめてuse-packageに変更。内容も最小限に。
;; Emacs本体に組み込まれているTree-sitter版のモードを使用します
(use-package yaml-ts-mode
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :custom
  (yaml-indent-offset 2))

(provide 'yaml)
;;; yaml.el ends here
