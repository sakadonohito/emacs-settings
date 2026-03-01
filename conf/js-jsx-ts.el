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

  :hook (js-ts-mode . eglot-ensure)   ;; LSPを有効化
  :custom
  ;; デフォルトは「2」
  (js-indent-level 2)                 ;; インデント幅を2に設定(これを設定しないと「4」になってしまう)
  ;(js-ts-mode-indent-offset 2)        ;; Tree-sitter版はこちらが優先
  )

;; -------------------------------------------------------------------
;; TypeScript (Tree-sitter版標準機能)
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
;; TSX (React用 .tsx)
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
;; JSON
;; -------------------------------------------------------------------
(use-package json-ts-mode
  :ensure nil
  :mode (("\\.json\\'" . json-ts-mode)
         ("\\.jsonc\\'" . json-ts-mode))
  :hook (json-ts-mode . eglot-ensure)
  :custom
  ;; デフォルトは「2」
  (json-ts-mode-indent-offset 2)
  )

(provide 'js-jsx-ts)
;;; js-jsx-ts.el ends here
