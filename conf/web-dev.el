;;; web-dev.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは html,CSS,JSON,JS/JSX,TS,TSX関係の設定ファイルです。
;;; Code:

;; -------------------------------------------------------------------
;; 0. 各モードのeglotへの追加
;; -------------------------------------------------------------------
(with-eval-after-load 'eglot
  (let ((web-servers
         '(((html-mode web-mode) . ("vscode-html-language-server" "--stdio"))
           ((css-mode css-ts-mode scss-mode) . ("vscode-css-language-server" "--stdio"))
           ((js-ts-mode tsx-ts-mode typescript-ts-mode) . ("typescript-language-server" "--stdio"))
           ((json-ts-mode) . ("vscode-json-language-server" "--stdio")))))
    (dolist (server web-servers)
      (add-to-list 'eglot-server-programs server))))


;; -------------------------------------------------------------------
;; 1. CSSで色定義の可視化
;; -------------------------------------------------------------------
(use-package rainbow-mode
  :ensure t
  :hook (web-mode css-ts-mode scss-mode js-ts-mode tsx-ts-mode))


;; -------------------------------------------------------------------
;; 2. web-modeの設定(主にhtmlファイル向け)
;; -------------------------------------------------------------------
(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ;("\\.xml\\'" . web-mode)           ;; xml-ts-mode に移行
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

  :custom
  ;; htmlファイルではインデント幅は「2」とする
  ;; 基本設定(base-settings.el)でインデント幅は「2」に設定している。
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

;; 手動でhtmlファイルをhtml-modeに変えた場合の設定(軽量重視の時用)
(use-package sgml-mode
  :ensure nil
  :custom
  (sgml-basic-offset 2)                             ;; インデント幅を「2」に設定
  :hook ((html-mode . eglot-ensure)                 ;; htmlファイルでLSPを有効化
         (html-mode . rainbow-mode)))               ;; Hexカラーの強調表示を有効化


;; -------------------------------------------------------------------
;; 3. SCSS (Sass) の設定
;; -------------------------------------------------------------------

;(use-package cmake-mode :ensure t) ;; 構文解析用 (optional)

(use-package scss-mode
  :ensure t
  :mode ("\\.scss\\'" . scss-mode)
  :hook (scss-mode . eglot-ensure)
  :custom
  (css-indent-offset 4)            ;; CSSファイルでのインデント幅は「4」とする
  (scss-compile-at-save nil)       ;; 保存時の自動コンパイル（重い場合はnil）
  )


;; -------------------------------------------------------------------
;; 4. CSSの設定
;; -------------------------------------------------------------------

(use-package css-ts-mode
  :ensure nil ;; 標準機能のためインストール不要
  :mode ("\\.css\\'" . css-ts-mode)
  :hook ((css-ts-mode . rainbow-mode) ;; CSSファイルではrainbow-modeを有効化
         (css-ts-mode . eglot-ensure))             ;; CSSファイルでLSPを有効化
  :custom
  (css-indent-offset 4)                            ;; インデント幅を4に設定
  (typescript-ts-mode-indent-offset 4)             ;; インデント幅を4に設定
  )


;; -------------------------------------------------------------------
;; 5. JavaScript / JSX (Tree-sitter版標準機能)
;; -------------------------------------------------------------------
;; js2-mode や rjsx-mode の代わりに、標準の js-ts-mode に統合します
;; js-ts-modeではLinter機能はないため「セミコロン警告を無効化」設定は不要
;; -------------------------------------------------------------------
(use-package js
  :ensure nil
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.jsx\\'" . js-ts-mode))

  :hook (js-ts-mode . eglot-ensure)   ;; LSPを有効化
  :custom
  ;; デフォルトは「2」
  (js-indent-level 2)                 ;; インデント幅を2に設定(これを設定しないと「4」になってしまう)
  ;(js-ts-mode-indent-offset 2)        ;; Tree-sitter版はこちらが優先
  )


;; -------------------------------------------------------------------
;; 6. TypeScript (Tree-sitter版標準機能)
;; -------------------------------------------------------------------
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode))
  :hook ((typescript-ts-mode . eglot-ensure)) ;; TypeScript用LSPを有効化
  :custom
  ;; デフォルトは「2」
  (typescript-ts-mode-indent-offset 2)       ;; インデント幅を設定
  )


;; -------------------------------------------------------------------
;; 7. TSX (React用 .tsx)
;; -------------------------------------------------------------------
;; ※typescript-ts-modeとは別に設定
;; -------------------------------------------------------------------
(use-package tsx-ts-mode
  :ensure nil
  :mode ("\\.tsx\\'" . tsx-ts-mode)
  :hook (tsx-ts-mode . eglot-ensure)
  :custom
  ;;; デフォルトは「2」
  (typescript-ts-mode-indent-offset 2)
  )


;; -------------------------------------------------------------------
;; 8. JSON
;; -------------------------------------------------------------------
(use-package json-ts-mode
  :ensure nil
  :mode (("\\.json\\'" . json-ts-mode)
         ("\\.jsonc\\'" . json-ts-mode))
  :hook (json-ts-mode . eglot-ensure)
  :custom
  ;; デフォルトは「2」
  (json-ts-mode-indent-offset 2))

;; -------------------------------------------------------------------
;; 9. PHPの設定
;; -------------------------------------------------------------------
(use-package php-ts-mode
  :init
  ;(add-to-list 'treesit-extra-load-path (expand-file-name "tree-sitter" user-emacs-directory))
  (add-to-list 'major-mode-remap-alist '(php-mode . php-ts-mode))
  :mode (("\\.php\\'" . php-mode)  ;; PHPスクリプト
         ("\\.inc\\'" . php-mode)) ;; インクルードファイル
  :hook (php-ts-mode . eglot-ensure)
  :config
  (setq php-ts-mode-indent-offset 2) ;; インデント設定（HTMLに合わせて2）
  (with-eval-after-load 'eglot
    ;; サーバーの絶対パスを servers/ から取得
    (let ((phpactor-path (expand-file-name "servers/phpactor" user-emacs-directory)))
      (add-to-list 'eglot-server-programs
                   `(php-ts-mode . (,phpactor-path "language-server"))))))

(provide 'web-dev)
;;; web-dev.el ends here
