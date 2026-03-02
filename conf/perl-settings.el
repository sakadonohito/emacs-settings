;;; perl-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは perl-modeの設定ファイルです
;;; Code:

(use-package cperl-mode
  :ensure nil
  :mode ("\\.pl\\'" "\\.pm\\'" "\\.t\\'" "\\.psgi\\'")
  :hook (cperl-mode . eglot-ensure)
  :config
  ;(add-to-list 'major-mode-remap-alist '(perl-mode . cperl-mode))
  (fset 'perl-mode 'cperl-mode)
  (setq cperl-font-lock t)                  ; 基本的にオンでOK
  ;(setq cperl-electric-parens t)            ; () {} [] の自動閉じ（好み）
  (setq cperl-electric-keywords t)          ; else とか入力したら自動で改行・インデント
  ;(setq cperl-invalid-face nil)             ; 怪しい部分を赤くしない（2026年現在はデフォルトで弱まってる）
  (setq cperl-indent-level 4)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((cperl-mode) . ("perlnavigator" "--stdio")))))

(provide 'perl-settings)
;;; perl-settings.el ends here
