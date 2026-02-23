;;; org-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは org-modeの設定ファイルです
;;; Code:

;;; leafからuse-packageに変更&必要設定のみに記述を限定
(use-package org
  :custom
  (org-startup-truncated nil))

(provide 'org-settings)
;;; org-settings.el ends here
