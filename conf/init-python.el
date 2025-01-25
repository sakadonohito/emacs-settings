;;; init-python.el --- Emacs initialization file
;;; Commentary:
;; このファイルは python-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

(leaf python
  :ensure nil  ;; Emacs標準搭載のpython-modeを利用
  :mode ("\\.py\\'" . python-mode)  ;; Pythonファイルをpython-modeで開く
  :custom ((python-indent-offset . 4)  ;; インデント幅をスペース2に設定
           (indent-tabs-mode . nil)    ;; タブをスペースに変換
           (tab-width . 4))            ;; タブ幅をスペース2に設定
  :hook ((python-mode . eglot-ensure)  ;; LSPサーバーを有効化
         (python-mode . (lambda ()
                           (setq indent-tabs-mode nil)  ;; タブをスペースに変換
                           (setq tab-width 4))))        ;; タブ幅をスペース2に設定
  :config
  ;; 必要に応じた追加のキーバインドやカスタマイズを記述
  ;(setq python-shell-interpreter "python3")  ;; デフォルトのPythonインタープリタをPython 3に設定
  )

(leaf blacken
  :ensure t
  :hook (python-mode . blacken-mode)  ;; 自動フォーマッタ（Black）を有効化
  :custom ((blacken-line-length . 88)))  ;; Blackの行幅を設定

;(leaf pyvenv
;  :ensure t
;  :config
;  (pyvenv-mode 1)  ;; Python仮想環境をサポート
;  (setq pyvenv-default-virtual-env-name nil))  ;; 必要に応じてデフォルトの仮想環境を設定

(leaf highlight-indent-guides
  :ensure t
  :hook (python-mode . highlight-indent-guides-mode)  ;; インデントガイドを有効化
  :custom ((highlight-indent-guides-method . 'character)  ;; インデントガイドの形式を設定
           (highlight-indent-guides-character . 124)      ;; 縦線のキャラクターコード
           (highlight-indent-guides-auto-enabled . t)))   ;; 自動でガイドを有効化

;; LSP server
;; npm install -g pyright

(provide 'init-python)
;;; init-python.el ends here
