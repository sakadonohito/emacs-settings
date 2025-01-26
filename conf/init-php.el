;;; init-php.el --- Emacs initialization file
;;; Commentary:
;; このファイルは php-modeの設定ファイルです
;;; Code:

(leaf php-mode
  :ensure t
  :mode (("\\.php\\'" . php-mode)  ;; PHPスクリプト
         ("\\.inc\\'" . php-mode)) ;; インクルードファイル
  :custom ((php-mode-coding-style . 'psr2) ;; PSR-2スタイルを使用
           (php-indent-level . 2)         ;; インデント幅をスペース2に設定
           (indent-tabs-mode . nil)       ;; タブを使わずスペースに変換
           (tab-width . 2))               ;; タブ幅をスペース2に設定
  :hook ((php-mode . eglot-ensure)        ;; LSPを有効化
         (php-mode . (lambda ()
                       (setq indent-tabs-mode nil) ;; 再度確認
                       (setq tab-width 2))))      ;; タブ幅の再確認
  :config
  ;; 変数や関数のハイライトを有効化
  (font-lock-add-keywords
   'php-mode
   '(("\\<\\(if\\|else\\|elseif\\|while\\|for\\|foreach\\|return\\|break\\|continue\\|switch\\|case\\|default\\|try\\|catch\\|throw\\|class\\|public\\|protected\\|private\\|static\\|function\\|use\\|namespace\\|require\\|include\\|new\\)\\>"
      . font-lock-keyword-face)  ;; キーワードのハイライト
     ("\\$[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-variable-name-face) ;; 変数のハイライト
     ("->\\([a-zA-Z_][a-zA-Z0-9_]*\\)" 1 font-lock-function-name-face)))) ;; メソッド呼び出しのハイライト

;; LSP server
;; npm install -g intelephense

(provide 'init-php)
;;; init-php.el ends here
