;;; python.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは python-modeの設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; Emacs 29以降標準搭載の Tree-sitter 版を使用
;; インデント幅をスペース2に設定
;; 「タブをスペースに」と「タブ幅をスペース2に」はinit-baseでの共通設定で行われているのでここでは行わない
;; インデントガイドの設定はinit-baseで設定されているのでここでは行わない
;; pyenv環境に合わせて、明示的に "python" コマンドを使用するよう指定
;; デフォルトpythonインタープリタの設定はinit.elのexec-path-from-shell設定依存
;; --------------------------------------------------
(use-package python-ts-mode
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :custom
  (python-shell-interpreter "python")
  (python-indent-offset 4)
  :hook (python-ts-mode . eglot-ensure))

;; --------------------------------------------------
;; Python仮想環境 (pyenv/virtualenv) のサポート
;; --------------------------------------------------
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1)
  ;; pyenv の versions ディレクトリを WORKON_HOME として認識させると、
  ;; M-x pyvenv-workon コマンドで pyenv の環境を一覧から選びやすくなります
  (setenv "WORKON_HOME" (expand-file-name "~/.pyenv/versions")))

;; --------------------------------------------------
;; 自動フォーマッタ（Black）を有効化
;; Blackの行幅を設定
;; --------------------------------------------------
(use-package blacken
  :ensure t
  :hook (python-ts-mode . blacken-mode)
  :custom
  (blacken-line-length 88))

(provide 'python)
;;; python.el ends here
