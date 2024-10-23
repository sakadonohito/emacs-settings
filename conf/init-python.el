;;; init-python.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; python-mode
;; 標準のpython-modeを利用するので以下の設定は全て不要
;; 今後専用の設定が必要になればここに記述する
;(setq auto-mode-alist
;      (cons '("\\.py$" . python-mode) auto-mode-alist))
;(autoload 'python-mode "python-mode" "Python editing mode." t)

;(add-hook 'python-mode-hook
;      '(lambda()
;         (setq indent-tabs-mode t)
;         (setq indent-level 4)
;         (setq python-indent 4)
;         (setq tab-width 4)))

(provide 'init-python)
;;; init-python.el ends here
