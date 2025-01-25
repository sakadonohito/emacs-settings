;;; init-rst.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:


;;; rst.el
;(require 'rst)
;;;拡張子の*.rst (*.tab,*.txt)のファイルをrst-modeで開く
;(setq auto-mode-alist 
;	  (append '(("\\.rst$" . rst-mode)
;				("\\.tab$" . rst-mode)
;				("\\.txt$" . rst-mode)
;				("\\.rest$" . rst-mode)) auto-mode-alist))
;;;背景が黒い場合は見出しのハイライトを変える
;(setq frame-background-mode 'dark)
;;;インデントはスペース
;(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; leaf版
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
