;;; init-beam.el --- Emacs initialization file
;;; Commentary:
;; このファイルは BEAM系言語の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:


(leaf erlang
  :ensure t
  :mode ("\\.erl\\'" . erlang-mode) ;; Erlangファイルに対応
  :hook ((erlang-mode . eglot-ensure)  ;; LSPサーバーを有効化
         (erlang-mode . (lambda ()
                          (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
                          (setq tab-width 4))))        ;; タブ幅を4に設定
  :config
  ;; 保存時にコードを自動フォーマット
  (add-hook 'before-save-hook
            (lambda ()
              (when (eq major-mode 'erlang-mode)
                (eglot-format-buffer))))
  :custom ((erlang-indent-level . 4))) ;; インデント幅を4に設定


(leaf elixir-mode
  :ensure t
  :mode ("\\.ex\\'" . elixir-mode)   ;; Elixirファイルに対応
  :hook ((elixir-mode . eglot-ensure)  ;; LSPサーバーを有効化
         (elixir-mode . (lambda ()
                          (setq indent-tabs-mode nil)  ;; タブを使わずスペースに変換
                          (setq tab-width 2))))        ;; タブ幅を2に設定
  :custom ((elixir-indent-level . 2))  ;; インデント幅を2に設定
  :config
  ;; 保存時にコードを自動フォーマット
  (add-hook 'before-save-hook
            (lambda ()
              (when (eq major-mode 'elixir-mode)
                (eglot-format-buffer))))

  ;; Mix integration
  (leaf mix
    :ensure t
    :hook (elixir-mode . mix-minor-mode))

  ;; Alchemist（Elixir専用ツール）を有効化する場合
  ;; 非推奨になりつつあるため慎重に検討
  ;; (leaf alchemist
  ;;   :ensure t
  ;;   :hook (elixir-mode . alchemist-mode))
  )


;; LSP
;; asdf plugin add erlang
;; asdf install erlang <バージョン>
;; asdf global erlang <バージョン>


(provide 'init-beam)
;;; init-beam.el ends here
