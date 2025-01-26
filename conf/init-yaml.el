;;; init-yaml.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(leaf yaml-mode
  :ensure t
  :mode "\\.yml\\'"
  :custom ((yaml-indent-offset . 2))  ;; インデント幅をスペース2に設定
  :hook ((yaml-mode . (lambda ()
                        (setq indent-tabs-mode nil)  ;; タブではなくスペースを使用
                        (setq tab-width 2)))))      ;; タブ幅をスペース2に変換

(provide 'init-yaml)
;;; init-yaml.el ends here
