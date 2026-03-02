;;; ccpp-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは C/C++の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;C/C++
(use-package cc-mode
  :ensure nil
  :commands (c-mode c++-mode)
  :hook
  ;((c-mode-hook c++-mode-hook c-mode-common-hook) . eglot-ensure)
  ((c-mode-common) . eglot-ensure)
  :config
  ;; インデントスタイルなどの基本設定
  (setq-default c-basic-offset 4)
  ;(indent-tabs-mode . nil)     ;; タブをスペースに変換はいらんか？
  (setq c-default-style "bsd")
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 `((c-mode c++-mode) . ("/usr/local/opt/llvm/bin/clangd" ;; フルパスで指定
                                        "--header-insertion=never"
                                        "--suggest-missing-includes"
                                        "--all-scopes-completion"
                                        "--completion-style=detailed"))))
  )



(provide 'ccpp-settings)
;;; ccpp-settings.el ends here
