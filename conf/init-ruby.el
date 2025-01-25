;;; init-ruby.el --- Emacs initialization file
;;; Commentary:
;; このファイルは ruby-modeの設定ファイルです
;;; Code:

(leaf ruby-mode
  :ensure nil  ;; ruby-modeはEmacs標準搭載
  :mode (("\\.rb\\'" . ruby-mode)       ;; Rubyスクリプト
         ("Rakefile\\'" . ruby-mode)   ;; Rakeファイル
         ("Gemfile\\'" . ruby-mode)    ;; Gemfile
         ("\\.gemspec\\'" . ruby-mode) ;; gemspecファイル
         ("\\.rake\\'" . ruby-mode)    ;; Rakeタスク
         ("\\.ru\\'" . ruby-mode)      ;; Rackアプリケーション
         ("\\.thor\\'" . ruby-mode))   ;; Thorスクリプト
  :custom ((ruby-indent-level . 4)     ;; インデント幅をスペース2に設定
           (indent-tabs-mode . nil)    ;; タブをスペースに変換
           (tab-width . 4))            ;; タブ幅をスペース2に設定
  :hook ((ruby-mode . eglot-ensure)    ;; LSPサーバーを有効化
         (ruby-mode . (lambda ()
                        (setq indent-tabs-mode nil)  ;; タブをスペースに変換
                        (setq tab-width 4))))       ;; タブ幅をスペース2に設定
  :config
  ;; 必要に応じた構文ハイライトの追加
  (font-lock-add-keywords
   'ruby-mode
   '(("\\<\\(def\\|class\\|module\\|if\\|else\\|elsif\\|end\\|do\\|while\\|for\\|break\\|next\\|redo\\|retry\\|return\\|yield\\|self\\|nil\\|true\\|false\\|super\\)\\>"
      . font-lock-keyword-face) ;; キーワードをハイライト
     ("\\(@[a-zA-Z_][a-zA-Z0-9_]*\\)" . font-lock-variable-name-face) ;; インスタンス変数
     ("\\(::[a-zA-Z_][a-zA-Z0-9_]*\\)" . font-lock-type-face))))     ;; クラスやモジュール

(leaf inf-ruby
  :ensure t
  :hook (ruby-mode . inf-ruby-minor-mode) ;; Ruby REPLとの統合を有効化
  :custom ((inf-ruby-default-implementation . "irb"))) ;; 使用するRuby REPLを指定

(leaf robe
  :ensure t
  :hook (ruby-mode . robe-mode)          ;; Robeモードを有効化
  :config
  )

(provide 'init-ruby)
;;; init-ruby.el ends here
