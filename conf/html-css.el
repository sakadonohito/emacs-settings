;;; html-css.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは html/CSS関係の設定ファイルです。
;;; Code:

;; CSSで色を可視化する
(use-package rainbow-mode
  :ensure t
  :hook (web-mode css-ts-mode scss-mode js-ts-mode tsx-ts-mode))

;; web-modeの設定
(use-package web-mode
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
         ("\\.astro\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
         ("\\.tmpl\\'" . web-mode)
         ("\\.blade.php\\'" . web-mode)
         ("\\.twig\\'" . web-mode)
         ("\\.ctp\\'" . web-mode))
  :hook ((web-mode . eglot-ensure)                ;; LSPサーバーを有効化
         (web-mode . rainbow-mode))          ;; rainbow-modeを有効化
;;         (web-mode . highlight-hex-colors-mode))  ;; highlight-hex-colors-modeを有効化
  :custom
  ;; htmlファイルではインデント幅は「2」とする
  ;; 基本設定でインデント幅は「2」に設定している。
  ;(web-mode-markup-indent-offset 2)         ;; HTMLタグのインデント幅
  ;(web-mode-css-indent-offset 2)            ;; CSSのインデント幅
  ;(web-mode-code-indent-offset 2)           ;; JavaScriptやPHPなどのコードのインデント幅
  (web-mode-enable-auto-closing t)          ;; 自動でタグを閉じる
  (web-mode-enable-auto-pairing t)          ;; 自動ペアリングを有効にする
  (web-mode-enable-comment-keywords t)      ;; コメントの自動補完を有効化
  (web-mode-enable-css-colorization t)      ;; 色分けなど視覚的な支援を強化
  (web-mode-enable-comment-interpolation t) ;; テンプレート言語での補完を有効化
  (web-mode-comment-formats
   '(("html" . "")
     ("javascript" . ("//%s" . "/* %s */"))
     ("css" . ("/*" . "*/"))
     ("php" . ("//%s" . "/* %s */"))
     ("python" . "# %s")
     ("ruby" . "# %s")
     ("perl" . "# %s")))
  )

;; SCSS (Sass) の設定
;(use-package cmake-mode :ensure t) ;; 構文解析用 (optional)

(use-package scss-mode
  :ensure t
  :mode ("\\.scss\\'" . scss-mode)
  :hook (scss-mode . eglot-ensure)
  :custom
  (css-indent-offset 4)            ;; CSSファイルでのインデント幅は「4」とする
  (scss-compile-at-save nil)       ;; 保存時の自動コンパイル（重い場合はnil）
  )

;; Tree-sitter版 css-mode の設定
(use-package css-ts-mode
  :ensure nil ;; 標準機能のためインストール不要
  :mode ("\\.css\\'" . css-ts-mode)
  :hook ((css-ts-mode . rainbow-mode) ;; CSSファイルではrainbow-modeを有効化
  ;:hook ((css-ts-mode . highlight-hex-colors-mode) ;; CSSファイルではhighlight-hex-colors-modeを有効化
         (css-ts-mode . eglot-ensure))             ;; CSSファイルでLSPを有効化
  :custom
  (css-indent-offset 4)                            ;; インデント幅を4に設定
  (typescript-ts-mode-indent-offset 4)             ;; インデント幅を4に設定
  )

;; 手動でhtmlファイルをhtml-modeに変えた場合の設定(軽量重視の時用)
(use-package sgml-mode
  :ensure nil
  :custom
  (sgml-basic-offset 2)                             ;; インデント幅を「2」に設定
  :hook ((html-mode . eglot-ensure)                 ;; htmlファイルでLSPを有効化
         (html-mode . rainbow-mode)))               ;; Hexカラーの強調表示を有効化
         ;(html-mode . highlight-hex-colors-mode))) ;; Hexカラーの強調表示を有効化

(provide 'html-css)
;;; html-css.el ends here
