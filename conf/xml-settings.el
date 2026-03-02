;;; xml-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルはXMLに関する設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; XMLの設定
;; ====================================================================

(use-package nxml-mode
  :ensure nil ;; Emacs内蔵
  :mode ("\\.xml\\'" "\\.xsd\\'" "\\.dtd\\'")
  :hook (nxml-mode . eglot-ensure)
  :config
  (setq nxml-child-indent 2)
  (setq nxml-attribute-indent 2)
:config
  (let ((lemminx-jar (expand-file-name "servers/org.eclipse.lemminx-uber.jar" user-emacs-directory)))
    (with-eval-after-load 'eglot
      (add-to-list 'eglot-server-programs
                   `(nxml-mode . ("java" "-jar" ,lemminx-jar))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'xml-settings)
;;; xml-settings.el ends here
