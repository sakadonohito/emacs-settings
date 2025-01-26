;;; init-org.el --- Emacs initialization file
;;; Commentary:
;; このファイルは org-modeの設定ファイルです
;;; Code:

(leaf org
  :ensure t
  :custom
  ((org-startup-truncated . nil))  ;; 折り返し表示を有効化
  :mode ("\\.org\\'" . org-mode))  ;; `.org`拡張子にorg-modeを適用

(provide 'init-org)
;;; init-org.el ends here
