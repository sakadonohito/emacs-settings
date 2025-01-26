;;; init-golang.el --- Emacs initialization file
;;; Commentary:
;; このファイルは go-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(leaf go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode)  ;; Goファイルに対応
  :hook ((go-mode . eglot-ensure)        ;; LSPを有効化
         (before-save . gofmt-before-save))  ;; 保存前にコードをフォーマット
  :custom ((gofmt-command . "gofmt")    ;; gofmtを使用（必要に応じてgoimportsに変更可能）
           (tab-width . 2)             ;; タブ幅を2に設定
           (indent-tabs-mode . nil))   ;; タブをスペースに変換
  :config

  ;; Eldocを有効化（関数の引数や型情報を表示）
  (add-hook 'go-mode-hook #'eldoc-mode)

  ;; M-.で定義ジャンプ、M-,で戻る
  (define-key go-mode-map (kbd "M-.") #'eglot-find-definition)
  (define-key go-mode-map (kbd "M-,") #'xref-pop-marker-stack)

  ;; 必要に応じた追加設定をここに記述
  (message "Go mode configured successfully"))


;; LSP
;; go install golang.org/x/tools/gopls@latest

(provide 'init-golang)
;;; init-golang.el ends here
