;;; init-shell.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; eshellを使う
;;(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
;;(setq shell-pop-shell-type '("shell" "*shell*" (lambda () (shell))))
;;(setq shell-pop-shell-type '("terminal" "*terminal*" (lambda () (term shell-pop-term-shell))))
;;(setq shell-pop-shell-type '("ansi-term" "*ansi-term*" (lambda () (ansi-term shell-pop-term-shell))))
;(global-set-key (kbd "C-c s") 'shell-pop)


;; shell-settings名前空間でshell関連をまとめて設定
(leaf shell-settings
  :config
  (leaf shell-pop
    :ensure t
    :custom ((shell-pop-shell-type . '("eshell" "*eshell*" (lambda () (eshell))))
             (shell-pop-window-size . 30)
             (shell-pop-full-span . nil))
    :bind (("C-c s" . shell-pop)))

  (leaf sh-mode
    :hook (sh-mode . eglot-ensure)
    :custom ((sh-basic-offset . 2)
             (sh-indentation . 2))))

(provide 'init-shell)
;;; init-shell.el ends here