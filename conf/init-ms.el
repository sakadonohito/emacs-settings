;;; init-ms.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Microsoft系言語の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; C#の設定
(leaf csharp-mode
  :ensure t
  :mode ("\\.cs\\'" . csharp-mode)  ;; C#ファイルの拡張子を対応
  :hook (csharp-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((c-basic-offset . 4)   ;; インデント幅を4に設定
           (tab-width . 4)        ;; タブ幅を4に設定
           (indent-tabs-mode . nil))  ;; タブをスペースに変換
  :config
  ;; 必要に応じた追加設定をここに記述
  )


;; F#の設定
(leaf fsharp-mode
  :ensure t
  :mode ("\\.fs\\'" . fsharp-mode)  ;; F#ファイルの拡張子を対応
  :hook (fsharp-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((fsharp-indent-level . 4)   ;; インデント幅を4に設定
           (tab-width . 4)            ;; タブ幅を4に設定
           (indent-tabs-mode . nil))  ;; タブをスペースに変換
  :config
  ;; 必要に応じた追加設定をここに記述
  )

;; LSP
;; C#: https://github.com/OmniSharp/omnisharp-roslyn
;; F#: dotnet tool install --global fsautocomplete

(provide 'init-ms)
;;; init-ms.el ends here
