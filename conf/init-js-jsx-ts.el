;;; init-js-jsx-ts.el --- Emacs initialization file
;;; Commentary:
;; このファイルは js/ts関係の設定ファイルです。
;;; Code:

;; js2-modeの設定（純粋なJavaScript用）
(leaf js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  :custom ((js-indent-level . 2)  ;; インデント幅を2に設定
           (js2-basic-offset . 2)
           (js2-strict-missing-semi-warning . nil))  ;; セミコロン警告を無効化
  :hook (js2-mode . eglot-ensure))  ;; LSPを有効化

;; rjsx-modeの設定（React/JSX用）
(leaf rjsx-mode
  :ensure t
  :mode ("\\.jsx\\'" . rjsx-mode)
  :custom ((js-indent-level . 2)
           (js2-basic-offset . 2))
  :hook (rjsx-mode . eglot-ensure))  ;; LSPを有効化

;; typescript-ts-modeの設定（TypeScript用）
;; Emacs29からこっち
(leaf typescript-ts-mode
  :ensure nil  ;; Emacs 29以上では標準搭載のためインストール不要
  :mode (("\\.ts\\'" . typescript-ts-mode)    ;; TypeScriptファイル
         ("\\.tsx\\'" . typescript-ts-mode))  ;; TSXファイルも同じモードで対応
  :custom ((typescript-ts-mode-indent-offset . 2))  ;; インデント幅を設定
  :hook (typescript-ts-mode . eglot-ensure))  ;; TypeScript用LSPを有効化

(provide 'init-js-jsx-ts)
;;; init-js-jsx-ts.el ends here
