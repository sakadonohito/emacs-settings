;;; init-groovy.el --- Emacs initialization file
;;; Commentary:
;; このファイルは groovy-mode関係の設定ファイルです。
;;; Code:

;; カッコの補完や他コーディング便利機能が必要なら改て調べる
(leaf groovy-mode
  :ensure t
  :mode (("\\.gradle\\'" . groovy-mode)  ;; Gradleファイルをgroovy-modeで開く
         ("\\.groovy\\'" . groovy-mode)) ;; Groovyファイルも対応
  :custom ((groovy-indent-offset . 2))  ;; インデント幅をスペース2に設定
  :hook ((groovy-mode . eglot-ensure)   ;; LSPサーバーを有効化
         (groovy-mode . (lambda ()
                          (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
                          (setq tab-width 2))))        ;; タブ幅をスペース2に設定
  :config
  (global-font-lock-mode 1))  ;; 構文ハイライトを有効化

;; LSP
;; https://github.com/GroovyLanguageServer/groovy-language-server

(provide 'init-groovy)
;;; init-groovy.el ends here
