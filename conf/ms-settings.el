;;; ms-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Microsoft系言語の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; 重要！： dotnet tools のパス(~/.dotnet/tools) を環境変数に追加してください。

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
;; 初めてF#ファイルを開いた時に以下を実行
;; M-x fsharp-ts-mode-install-grammars
;; --------------------------------------------------
(use-package fsharp-ts-mode
  :after treesit
  :ensure t
  :init
  (add-to-list 'major-mode-remap-alist '(fsharp-mode . fsharp-ts-mode))
  :mode (("\\.fs\\'" . fsharp-ts-mode)
         ("\\.fsx\\'" . fsharp-ts-mode)
         ("\\.fsi\\'" . fsharp-ts-mode))
  :hook (
         (fsharp-ts-mode . fsharp-ts-repl-minor-mode)
         (fsharp-ts-mode . fsharp-ts-dotnet-mode)
         (fsharp-ts-mode . prettify-symbols-mode)     ;; 数学記法表示(funがλ、<-が←、->が→)に変換してくれるhook
         (fsharp-ts-mode . eglot-ensure)              ;; LSPサーバーを有効化
         (fsharp-ts-mode . (lambda ()
                             (setq-local corfu-auto-prefix 2)
                             (setq-local completion-styles '(basic partial-completion))
                             ;; Cape の補完ソースをF#バッファ用に上書き
;                             (setq-local completion-at-point-functions
;                                         (list
;                                          #'eglot-completion-at-point  ;; LSP補完を最優先
;                                          #'cape-keyword               ;; キーワード補完
;                                          #'cape-dabbrev               ;; バッファ内単語
;                                          ))
))
         )
  :custom ((tab-width 4)                              ;; タブ幅を4に設定
           (indent-tabs-mode nil))                    ;; タブをスペースに変換
  :config
  ;; fsharp-ts-eglot の自動インストールを使わず
  ;; dotnet グローバルツールを使う
  (setq fsharp-ts-eglot-server-install-dir nil)
  (require 'fsharp-ts-eglot)
  (require 'fsharp-ts-lens)
  (require 'fsharp-ts-info)
  (add-hook 'fsharp-ts-mode-hook #'fsharp-ts-lens-mode)
  (add-hook 'fsharp-ts-mode-hook #'fsharp-ts-info-mode)
  (setq fsharp-ts-guess-indent-offset t)
  ;; fsharp-ts-eglot のバグ対処：
  ;; server-contact が引数なしで定義されているが
  ;; Eglot は引数ありで呼び出すためラッパーで吸収
  ;; fsharp-ts-eglot--server-contact の引数なし定義を修正するラッパー
  (with-eval-after-load 'fsharp-ts-eglot
    (defun fsharp-ts-eglot--server-contact (&rest _)
      "Wrapper to accept arguments Eglot passes."
      (fsharp-ts-eglot--ensure-server)
      (fsharp-ts-eglot--server-command))
    ;; eglot-server-programs を上書き登録
    (add-to-list 'eglot-server-programs
                 '((fsharp-ts-mode fsharp-ts-signature-mode) .
                   (fsharp-ts-eglot-server . fsharp-ts-eglot--server-contact))))
  (message "fsharp setup finished"))

(with-eval-after-load 'project
  (add-to-list 'project-vc-extra-root-markers "*.sln")
  (add-to-list 'project-vc-extra-root-markers "global.json"))

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
