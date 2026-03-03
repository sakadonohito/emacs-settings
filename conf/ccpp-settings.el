;;; ccpp-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは C/C++の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;C/C++
(use-package c-ts-mode
  :init
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))
  :hook ((c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure))
  :config
  (setq c-ts-mode-indent-offset 4)
  (setq c-ts-mode-indent-style 'bsd)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 `((c-ts-mode c++-ts-mode) . ("/usr/local/opt/llvm/bin/clangd" ;; フルパスで指定
                                        "--header-insertion=never"
                                        "--suggest-missing-includes"
                                        "--all-scopes-completion"
                                        "--completion-style=detailed"))))
)

(provide 'ccpp-settings)
;;; ccpp-settings.el ends here
