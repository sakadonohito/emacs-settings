;;; flymake-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルはflymakeに関する初期設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-3. 構文チェック (Flymake + Flycheck統合)
;; ====================================================================

;; --------------------------------------------------
;; 8-3-1. Flymake (Emacs標準機能)
;; --------------------------------------------------
(use-package flymake
  ;; 全てのプログラミング用モードでFlymakeをベースにする
  :hook 
  (prog-mode . flymake-mode)
  (yaml-ts-mode . flymake-mode)
  (html-mode . flymake-mode)
  (mhtml-mode . flymake-mode)
  :bind
  (("C-c n" . flymake-goto-next-error)
   ("C-c p" . flymake-goto-prev-error)
   ("C-c l" . flymake-show-buffer-diagnostics)    ;; バッファ内のエラー一覧
   ("C-c C-l" . flymake-show-project-diagnostics) ;; プロジェクト内のエラー一覧
   )
  :custom
  (flymake-no-changes-timeout 2.0)    ;; 手を止めて2秒後に構文チェック
  (flymake-start-on-save-buffer nil)  ;; 保存時の構文チェックやらない
  (flymake-start-on-flymake-mode nil) ;; ファイル開いた時の構文チェックやらない
  :config
  (add-hook 'lisp-interaction-mode-hook (lambda () (flymake-mode -1))) ;; *scratch*画面ではチェックしない
  )

;; --------------------------------------------------
;; 8-3-2. Flycheck (本体？)
;; マイナーモード(flycheck-mode)としては絶対に起動しない
;; --------------------------------------------------
(use-package flycheck
  :ensure t
  :defer t)

;; --------------------------------------------------
;; 8-3-3. flymake-flycheck (Flycheckの解析結果をFlymakeに流し込むブリッジ)
;; --------------------------------------------------
(use-package flymake-flycheck
  :ensure t
  :after (flymake flycheck)
  ;; 対象としたい言語の起動時のみ、ブリッジ機能をONにする
  :hook
  ((php-ts-mode   . flymake-flycheck-auto)
   ;(perl-mode     . flymake-flycheck-auto)
   (cperl-mode    . flymake-flycheck-auto)   ;; perlはこっちのが強いらしい
   (ruby-ts-mode  . flymake-flycheck-auto)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'flymake-settings)
;;; flymake-settings.el ends here
