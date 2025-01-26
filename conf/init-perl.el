;;; init-perl.el --- Emacs initialization file
;;; Commentary:
;; このファイルは perl-modeの設定ファイルです
;;; Code:

(leaf perl-mode
  :ensure nil  ;; perl-modeはEmacsに標準で付属
  :mode (("\\.pl\\'" . perl-mode)   ;; Perlスクリプト
         ("\\.t\\'" . perl-mode)    ;; テストスクリプト
         ("\\.pm\\'" . perl-mode)   ;; モジュール
         ("\\.psgi\\'" . perl-mode)) ;; PSGIファイル
  :custom ((perl-indent-level . 2)  ;; インデント幅をスペース2に設定
           (indent-tabs-mode . nil) ;; タブを使わずスペースに変換
           (tab-width . 2))         ;; タブ幅をスペース2に設定
  :hook ((perl-mode . eglot-ensure) ;; LSPを有効化
         (perl-mode . (lambda ()
                        ;; 必要なら追加の設定をここに記述
                        )))
  :config
  ;; 変数や関数のハイライトを有効化
  (font-lock-add-keywords
   'perl-mode
   '(("\\<\\(my\\|our\\|local\\|sub\\|use\\|require\\|if\\|else\\|elsif\\|for\\|foreach\\|while\\|until\\|next\\|last\\|redo\\|goto\\|return\\|die\\|warn\\|eval\\)\\>"
      . font-lock-keyword-face)  ;; キーワードのハイライト
     ("\\<\\$[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-variable-name-face) ;; 変数のハイライト
     ("\\<\\&[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-function-name-face) ;; 関数のハイライト
     ("\\<@[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-variable-name-face)   ;; 配列のハイライト
     ("\\<%[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-variable-name-face)))) ;; ハッシュのハイライト


;; LSP server
;; cpanm Perl::LanguageServer

(provide 'init-perl)
;;; init-perl.el ends here
