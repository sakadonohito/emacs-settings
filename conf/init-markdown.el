;;; init-markdown.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(leaf markdown-mode
  :ensure t
  :mode (("\\.md*\\'" . markdown-mode)  ;; `.md`拡張子でmarkdown-modeを有効化
         ("\\.mdx\\'" . markdown-mode))  ;; `.mdx`拡張子でmarkdown-modeを有効化
  :custom ((markdown-command . "multimarkdown")))  ;; マークダウンコマンドにmultimarkdownを使用

(provide 'init-markdown)
;;; init-markdown.el ends here
