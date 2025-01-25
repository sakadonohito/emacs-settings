;;; init-ccpp.el --- Emacs initialization file
;;; Commentary:
;; このファイルは C/C++の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;C/C++
(leaf cc-mode
  :custom ((c-default-style . "linux")   ;; Linuxカーネルスタイル
           (c-basic-offset . 4)          ;; インデント幅を4に設定
           (indent-tabs-mode . nil))     ;; タブをスペースに変換
  :hook ((c-mode-common . (lambda ()
                            (c-toggle-auto-newline t)))  ;; 自動で改行を挿入
         (c-mode . eglot-ensure)          ;; c-modeでLSPを有効化
         (c++-mode . eglot-ensure))       ;; c++-modeでLSPを有効化
  :config
  (leaf clang-format
    :ensure t
    :hook ((c-mode-common . (lambda ()
                              (local-set-key (kbd "C-M-<tab>") 'clang-format-buffer)))))) ;; フォーマット用のキー


(provide 'init-ccpp)
;;; init-ccpp.el ends here
