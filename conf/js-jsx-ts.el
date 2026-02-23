;;; js-jsx-ts.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは js/ts関係の設定ファイルです。
;;; Code:

;; -------------------------------------------------------------------
;; JavaScript / JSX (Tree-sitter版標準機能)
;; -------------------------------------------------------------------
;; js2-mode や rjsx-mode の代わりに、標準の js-ts-mode に統合します
;; js-ts-modeではLinter機能はないため「セミコロン警告を無効化」設定は不要
(use-package js
  :ensure nil
  :mode (("\\.js\\'" . js-ts-mode)
         ("\\.jsx\\'" . js-ts-mode))
  :custom
  (js-indent-level 2)                 ;; インデント幅を2に設定
  :hook (js-ts-mode . eglot-ensure))  ;; LSPを有効化

;; -------------------------------------------------------------------
;; TypeScript / TSX (Tree-sitter版標準機能)
;; -------------------------------------------------------------------
(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))        ;; TSX専用のTree-sitterモード
  :custom
  (typescript-ts-mode-indent-offset 2)       ;; インデント幅を設定
  :hook ((typescript-ts-mode . eglot-ensure) ;; TypeScript用LSPを有効化
         (tsx-ts-mode . eglot-ensure)))      ;; TypeScript用LSPを有効化

(provide 'js-jsx-ts)
;;; js-jsx-ts.el ends here
