;;; ms-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Microsoft系言語の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; C#の設定
;; --------------------------------------------------
(use-package csharp-mode
  :ensure t
  :mode (("\\.cs\\'" . csharp-ts-mode)
         ("\\.csx\\'" . csharp-ts-mode))
  :init
  (add-to-list 'major-mode-remap-alist '(csharp-mode . csharp-ts-mode))
  :hook
  (csharp-ts-mode . eglot-ensure)
  :config
  ;; インデント設定（スペース4つ）
  (setq-default c-basic-offset 4)
  (setq-local tab-width 4)
  (setq-local indent-tabs-mode nil)

  ;; LSPサーバー（OmniSharp または Microsoft-gds）の指定
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 ;`(csharp-ts-mode . (,(expand-file-name "~/.dotnet/tools/csharp-ls"))))
                 '(csharp-ts-mode . ("csharp-ls"))))

  ;; おすすめの追加設定：コンパイル後の自動スクロール
  (setq compilation-scroll-output t))

(use-package dotnet
  :ensure t
  ;; csharp-ts-mode が起動したときに dotnet-mode も有効にする
  :hook (csharp-ts-mode . dotnet-mode))


;; --------------------------------------------------
;; F#の設定
;; --------------------------------------------------
;(use-package fsharp-ts-mode
;  :after treesit
;  :vc (:url "https://github.com/KaranAhlawat/fsharp-ts-mode" :rev :newest)
;  :mode (("\\.fs\\'" . fsharp-ts-mode)
;         ("\\.fsx\\'" . fsharp-ts-mode)
;         ("\\.fsi\\'" . fsharp-ts-mode))
;  :init
;  ;(add-to-list 'auto-mode-alist '("\\.fs\\'" . fsharp-ts-mode))
;  (add-to-list 'major-mode-remap-alist '(fsharp-mode . fsharp-ts-mode))
;  :hook (fsharp-ts-mode . eglot-ensure)  ;; LSPサーバーを有効化
;  :custom ((fsharp-indent-offset 4)   ;; インデント幅を4に設定
;           ;(tab-width 4)            ;; タブ幅を4に設定
;           ;(indent-tabs-mode nil)
;)  ;; タブをスペースに変換
;  :config
;  ;; 1. インデントエンジンの強制設定
;  (setq-local indent-line-function 'indent-relative) ; 前の行に合わせる最も安全な設定
;  (setq fsharp-ts-mode-indent-offset 4)
;  (with-eval-after-load 'eglot
;    (add-to-list 'eglot-server-programs
;                 ;'(fsharp-ts-mode . ("fsautocomplete" "--background-service-enabled"))))
;                 '(fsharp-ts-mode . ("fsautocomplete"))))
;  (message "fsharp setup finished"))

(use-package fsharp-mode
  :after treesit
  :ensure t
  ;:vc (:url "https://github.com/KaranAhlawat/fsharp-ts-mode" :rev :newest)
  :mode (("\\.fs\\'" . fsharp-mode)
         ("\\.fsx\\'" . fsharp-mode)
         ("\\.fsi\\'" . fsharp-mode))
  ;:init
  ;(add-to-list 'auto-mode-alist '("\\.fs\\'" . fsharp-mode))
  ;(add-to-list 'major-mode-remap-alist '(fsharp-mode . fsharp-mode))
  :hook (fsharp-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((fsharp-indent-offset 4)   ;; インデント幅を4に設定
           ;(tab-width 4)            ;; タブ幅を4に設定
           ;(indent-tabs-mode nil)    ;; タブをスペースに変換
           )
  :config
  ;(setq-local indent-line-function 'indent-relative) ; 前の行に合わせる最も安全な設定
  ;(setq fsharp-mode-indent-offset 4)
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 ;'(fsharp-mode . ("fsautocomplete" "--background-service-enabled"))))
                 '(fsharp-mode . ("fsautocomplete"))))
  )

;; --------------------------------------------------
;; PowerShellの設定(いけるか？)
;; --------------------------------------------------
(use-package powershell
  :ensure t
  :mode ("\\.ps1\\'" . powershell-mode)
  :config
  ;; PowerShell Core (pwsh) を使う設定
  (setq powershell-indent-offset 4))

;; LSP (Eglot) を使う場合
;; PowerShell Editor Services がインストールされていれば、
;; ps1ファイルでも補完や定義ジャンプが効きます。

(provide 'ms-settings)
;;; ms-settings.el ends here
