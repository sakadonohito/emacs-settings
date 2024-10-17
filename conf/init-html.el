;;; init-web.el --- Emacs initialization file
;;; Commentary:
;; このファイルは html/CSS関係の設定ファイルです。
;;; Code:

;; web-modeの設定
(use-package web-mode
  :straight t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.xml\\'" . web-mode)                  ;; XML
         ("\\.svg\\'" . web-mode)                  ;; SVG
	 ("\\.php\\'" . web-mode)                ;; PHPファイル
	 ("\\.tpl\\'" . web-mode)                ;; PHPファイル(Smarty)
	 ("\\.jsp\\'" . web-mode)                ;; JSPファイル
	 ("\\.ejs\\'" . web-mode)                ;; Node.jsテンプレートファイル
         ("\\.erb\\'" . web-mode)                 ;; Ruby on Rails ERBテンプレート
         ("\\.djhtml\\'" . web-mode)             ;; Djangoテンプレート
         ("\\.jsx\\'" . web-mode)                  ;; React JSX
         ("\\.vue\\'" . web-mode)                 ;; Vue.jsファイル
         ("\\.tmpl\\'" . web-mode)                ;; Goテンプレート
         ("\\.blade.php\\'" . web-mode)       ;; Laravel Bladeテンプレート
         ("\\.twig\\'" . web-mode)               ;; Twigテンプレート (Symfony)
         ("\\.ctp\\'" . web-mode)               ;; CakePHPテンプレート(滅びろ)
	 )
  :config
  (setq web-mode-markup-indent-offset 2)          ;; HTMLタグのインデント幅
  (setq web-mode-css-indent-offset 4)                ;; CSSのインデント幅
  (setq web-mode-code-indent-offset 4)             ;; JavaScriptやPHPなどコードのインデント幅
  (setq web-mode-enable-auto-closing t)            ;; 自動でタグを閉じる
  (setq web-mode-enable-auto-pairing t)             ;; 自動ペアリングを有効にする
  (setq web-mode-enable-comment-keywords t) ;; コメントの自動補完を有効化
  (setq web-mode-enable-css-colorization t)        ;; 色分けなど視覚的な支援を強化
  (setq web-mode-enable-comment-interpolation t) ;; テンプレート言語での補完を有効化
  (setq web-mode-comment-formats
	'(("html" . "<!-- %s -->")
	  ("javascript" . ("//%s" . "/* %s */") )
	  ("css" . ("/*" . "*/") )
	  ("php" . ("//%s" . "/* %s */") )
	  ("python" . "# %s" )
	  ("ruby" . "# %s" )
	  ("perl" . "# %s" )
	  ))
  )


;; css-modeの設定
(use-package css-mode
  :straight t
  :mode "\\.css\\'"
  :hook (css-mode . rainbow-mode))  ;; CSSファイルではrainbow-modeを有効に


;; rainbow-modeの設定
(use-package rainbow-mode
  :straight t
  :hook ((css-mode web-mode) . rainbow-mode))  ;; web-mode内でもrainbow-modeを有効化


(use-package company-web
  :straight t
  :after web-mode
  :config
  (add-to-list 'company-backends 'company-web-html))


;; なんの設定か思い出せない
;; コメントアウトの設定
;(add-hook 'web-mode-hook
;	  '(lambda ()
;	     (add-to-list 'web-mode-comment-formats '("jsx" . "//"))))


(provide 'init-web)
;;; init-web.el ends here
