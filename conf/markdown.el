;;; markdown.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;; leafやめてuse-packageに変更
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("\\.mdx\\'" . markdown-mode))
  :custom
  (markdown-command "multimarkdown"))

(use-package markdown-preview-mode
  :ensure t
  :after markdown-mode
  :bind (:map markdown-mode-map
              ("C-c M-p" . markdown-preview-mode)))

(provide 'markdown)
;;; markdown.el ends here
