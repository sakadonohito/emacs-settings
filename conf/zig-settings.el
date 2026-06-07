;;; zig-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Zigの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Zigの設定
;; --------------------------------------------------
(use-package zig-mode
  :ensure t
  :mode "\\.\\(zig\\|zon\\)\\'"
  :hook
  (zig-mode . eglot-ensure)
  (zig-mode . (lambda ()
                (setq-local compile-command "zig build")))
  :bind
  (:map zig-mode-map
        ;; 単一ファイルのコンパイル
        ("C-c z r" . (lambda () (interactive)
                       (compile (concat "zig run " (buffer-file-name))))))
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
      '(zig-mode . ("/usr/local/bin/zls"
                    :initializationOptions
                    (:zig_exe_path "/usr/local/bin/zig"))))))

(provide 'zig-settings)
;;; zig-settings.el ends here
