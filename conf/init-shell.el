(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
;;(setq shell-pop-shell-type '("shell" "*shell*" (lambda () (shell))))
;;(setq shell-pop-shell-type '("terminal" "*terminal*" (lambda () (term shell-pop-term-shell))))
;;(setq shell-pop-shell-type '("ansi-term" "*ansi-term*" (lambda () (ansi-term shell-pop-term-shell))))
(global-set-key (kbd "C-c s") 'shell-pop)
