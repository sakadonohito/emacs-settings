;;; init-rst.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(leaf rst
  :ensure nil  ;; Emacs標準機能のためインストール不要
  :mode (("\\.rst\\'" . rst-mode)   ;; `.rst`拡張子に対応
         ;("\\.tab\\'" . rst-mode)   ;; `.tab`拡張子に対応
         ;("\\.txt\\'" . rst-mode)   ;; `.txt`拡張子に対応
         ("\\.rest\\'" . rst-mode)) ;; `.rest`拡張子に対応
  :custom ((frame-background-mode . 'dark))  ;; 背景が黒い場合に見出しハイライトを調整
  :hook (rst-mode . (lambda () (setq indent-tabs-mode nil))))  ;; rst-modeでインデントをスペースに設定

(provide 'init-rst)
;;; init-rst.el ends here
