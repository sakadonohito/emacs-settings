;;; init-org.el --- Emacs initialization file
;;; Commentary:
;; このファイルは org-modeの設定ファイルです
;;; Code:

;(use-package org
;  :straight t)
;; 横スクロールさせず折り返し表示にする
;(setq org-startup-truncated nil)
;(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(leaf org
  :ensure t
  :custom
  ((org-startup-truncated . nil))  ;; 折り返し表示を有効化
  :mode ("\\.org\\'" . org-mode))  ;; `.org`拡張子にorg-modeを適用

(provide 'init-org)
;;; init-org.el ends here
