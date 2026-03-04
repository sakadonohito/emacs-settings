;;; swift-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Swiftの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:


;; 1. Swift用のメジャーモード (Syntax Highlight & Indent)
(use-package swift-mode
  :ensure t
  :mode "\\.swift\\'"
  :hook (swift-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(swift-mode . ("xcrun" "sourcekit-lsp")))))

(provide 'swift-settings)
;;; swift-settings.el ends here
