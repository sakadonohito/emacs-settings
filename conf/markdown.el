;;; markdown.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(use-package markdown-ts-mode
  :ensure nil
  :init
  ;; markdown-modeを呼び出そうとしてもts-modeに強制する
  (add-to-list 'major-mode-remap-alist '(markdown-mode . markdown-ts-mode))
  :mode (("\\.md\\'" . markdown-ts-mode)
         ("\\.markdown\\'" . markdown-ts-mode)
         ("\\.mdx\\'" . markdown-ts-mode))
  :bind (:map markdown-mode-map
              ;("C-c M-p" . markdown-preview-mode)
              ;:map markdown-ts-mode-map
              ("C-c M-p" . markdown-preview-mode))
  :hook
  (markdown-ts-mode . eglot-ensure)
  :custom
  (markdown-command "multimarkdown")
  )

(use-package markdown-preview-mode
  :ensure t
  :after (markdown-mode markdown-ts-mode)
)

(provide 'markdown)
;;; markdown.el ends here
