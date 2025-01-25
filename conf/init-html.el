;;; init-web.el --- Emacs initialization file
;;; Commentary:
;; このファイルは html/CSS関係の設定ファイルです。
;;; Code:

;; web-modeの設定
;(use-package web-mode
;  :straight t
;  :mode (("\\.html?\\'" . web-mode)
;         ("\\.xml\\'" . web-mode)                  ;; XML
;         ("\\.svg\\'" . web-mode)                  ;; SVG
;	 ("\\.php\\'" . web-mode)                ;; PHPファイル
;	 ("\\.tpl\\'" . web-mode)                ;; PHPファイル(Smarty)
;	 ("\\.jsp\\'" . web-mode)                ;; JSPファイル
;	 ("\\.ejs\\'" . web-mode)                ;; Node.jsテンプレートファイル
;         ("\\.erb\\'" . web-mode)                 ;; Ruby on Rails ERBテンプレート
;         ("\\.djhtml\\'" . web-mode)             ;; Djangoテンプレート
;         ("\\.jsx\\'" . web-mode)                  ;; React JSX
;         ("\\.vue\\'" . web-mode)                 ;; Vue.jsファイル
;         ("\\.tmpl\\'" . web-mode)                ;; Goテンプレート
;         ("\\.blade.php\\'" . web-mode)       ;; Laravel Bladeテンプレート
;         ("\\.twig\\'" . web-mode)               ;; Twigテンプレート (Symfony)
;         ("\\.ctp\\'" . web-mode)               ;; CakePHPテンプレート(滅びろ)
;	 )
;  :config
;  (setq web-mode-markup-indent-offset 2)          ;; HTMLタグのインデント幅
;  (setq web-mode-css-indent-offset 2)                ;; CSSのインデント幅
;  (setq web-mode-code-indent-offset 2)             ;; JavaScriptやPHPなどコードのインデント幅
;  (setq web-mode-enable-auto-closing t)            ;; 自動でタグを閉じる
;  (setq web-mode-enable-auto-pairing t)             ;; 自動ペアリングを有効にする
;  (setq web-mode-enable-comment-keywords t) ;; コメントの自動補完を有効化
;  (setq web-mode-enable-css-colorization t)        ;; 色分けなど視覚的な支援を強化
;  (setq web-mode-enable-comment-interpolation t) ;; テンプレート言語での補完を有効化
;  (setq web-mode-comment-formats
;	'(("html" . "<!-- %s -->")
;	  ("javascript" . ("//%s" . "/* %s */") )
;	  ("css" . ("/*" . "*/") )
;	  ("php" . ("//%s" . "/* %s */") )
;	  ("python" . "# %s" )
;	  ("ruby" . "# %s" )
;	  ("perl" . "# %s" )
;	  ))
;  )


;; css-modeの設定
;(use-package css-mode
;  :straight t
;  :mode "\\.css\\'"
;  :hook (css-mode . rainbow-mode))  ;; CSSファイルではrainbow-modeを有効に


;; rainbow-modeの設定
;(use-package rainbow-mode
;  :straight t
;  :hook ((css-mode web-mode) . rainbow-mode))  ;; web-mode内でもrainbow-modeを有効化


;(use-package company-web
;  :straight t
;  :after web-mode
;  :config
;  (add-to-list 'company-backends 'company-web-html))


;; なんの設定か思い出せない
;; コメントアウトの設定
;(add-hook 'web-mode-hook
;	  '(lambda ()
;	     (add-to-list 'web-mode-comment-formats '("jsx" . "//"))))


;; leaf版
;; web-modeの設定
(leaf web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.xml\\'" . web-mode)
         ("\\.svg\\'" . web-mode)
         ("\\.php\\'" . web-mode)
         ("\\.tpl\\'" . web-mode)
         ("\\.jsp\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.astro\\'" . web-mode) ;;Astro
         ("\\.vue\\'" . web-mode)
         ("\\.tmpl\\'" . web-mode)
         ("\\.blade.php\\'" . web-mode)
         ("\\.twig\\'" . web-mode)
         ("\\.ctp\\'" . web-mode))
  :custom ((web-mode-markup-indent-offset . 2)          ;; HTMLタグのインデント幅
           (web-mode-css-indent-offset . 2)             ;; CSSのインデント幅
           (web-mode-code-indent-offset . 2)            ;; JavaScriptやPHPなどのコードのインデント幅
           (web-mode-enable-auto-closing . t)           ;; 自動でタグを閉じる
           (web-mode-enable-auto-pairing . t)           ;; 自動ペアリングを有効にする
           (web-mode-enable-comment-keywords . t)       ;; コメントの自動補完を有効化
           (web-mode-enable-css-colorization . t)       ;; 色分けなど視覚的な支援を強化
           (web-mode-enable-comment-interpolation . t)) ;; テンプレート言語での補完を有効化
  :config
  (setq web-mode-comment-formats
        '(("html" . "<!-- %s -->")
          ("javascript" . ("//%s" . "/* %s */"))
          ("css" . ("/*" . "*/"))
          ("php" . ("//%s" . "/* %s */"))
          ("python" . "# %s")
          ("ruby" . "# %s")
          ("perl" . "# %s")))
  :hook ((web-mode . eglot-ensure) ;; LSPサーバーを有効化
         (web-mode . highlight-hex-colors-mode)) ;; highlight-hex-colors-modeを有効化
  )

;; css-modeの設定
(leaf css-mode
  :ensure t
  :mode "\\.css\\'"
  :hook ((css-mode . highlight-hex-colors-mode)  ;; CSSファイルではhighlight-hex-colors-modeを有効化
         (css-mode . eglot-ensure))  ;; CSSファイルでLSPを有効化
  :custom ((css-indent-offset . 2)))  ;; インデント幅を2に設定

;; 手動でhtmlファイルをhtml-modeに変えた場合の設定(軽量重視の時用)
(leaf html-mode
  :ensure nil  ;; Emacs組み込みのためインストール不要
  :custom ((sgml-basic-offset . 2))  ;; インデント幅を設定
  :hook ((html-mode . (lambda ()
                        (setq indent-tabs-mode nil)       ;; タブではなくスペースでインデント
                        (setq show-paren-mode t)          ;; 対応する括弧を表示
                        (html-mode . eglot-ensure)         ;; htmlファイルでLSPを有効化
                        (highlight-hex-colors-mode 1))))) ;; Hexカラーの強調表示を有効化

;; 一箇所に設定をまとめたい場合
;(leaf highlight-hex-colors
;  :hook ((css-mode web-mode) . highlight-hex-colors-mode))

(provide 'init-html)
;;; init-html.el ends here
