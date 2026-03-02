;;; yaml.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;; leafやめてuse-packageに変更。内容も最小限に。
;; Emacs本体に組み込まれているTree-sitter版のモードを使用します
(use-package yaml-ts-mode
  :ensure nil
  :init
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  :mode ("\\.ya?ml\\'" . yaml-ts-mode)
  :hook
  (yaml-ts-mode . eglot-ensure)
  ;:custom
  ;; デフォルトは「2」
  ;(yaml-indent-offset 2)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((yaml-ts-mode yaml-mode) . ("yaml-language-server" "--stdio")))))

(provide 'yaml)
;;; yaml.el ends here
