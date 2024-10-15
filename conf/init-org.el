;;; init-org.el --- Emacs initialization file
;;; Commentary:
;; このファイルは org-modeの設定ファイルです
;;; Code:

(use-package org
  :straight t)

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))


;;; init-org.el ends here
