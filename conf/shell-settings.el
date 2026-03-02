;;; shell-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs の初期設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; -------------------------------------------------------------------
;; 1. シェル環境がbashかどうか判定定数の定義
;; -------------------------------------------------------------------
(defconst bash-p
  (let ((shell-path (getenv "SHELL")))
    (and shell-path
         (string-match-p "bash$" shell-path)))
  "Return t if the current shell is bash.現在の環境のシェルが bash であれば t.")

;; -------------------------------------------------------------------
;; 2. シェルスクリプト編集モード (Emacs標準機能)
;; -------------------------------------------------------------------

;; 2-1. Linux and Bash 環境の場合
(use-package bash-ts-mode
  :if (and linux-p bash-p)
  :ensure nil  ;; Emacs 29.1+ 標準
  :mode (("\\.sh\\'" . bash-ts-mode)
         ("\\.bashrc\\'" . bash-ts-mode))
  :interpreter ("bash" . bash-ts-mode)
  :hook
  (bash-ts-mode . eglot-ensure)
  ;:custom
  ;; デフォルトは「2」
  ;(sh-basic-offset 2)
  ;(sh-indentation 2)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))))

;; 2-2. それ以外の環境の場合(Mac zsh とか)
(use-package sh-script
  :if (not (and linux-p bash-p))
  :ensure nil
  :init
  ;; zsh であっても解析には bash の Tree-sitter ライブラリを使うよう設定
  (setq sh-shell 'bash)
  :mode (("\\.sh\\'"       . sh-mode)
         ("\\.zsh\\'"      . sh-mode)
         ("\\.zshrc\\'"    . sh-mode)
         ("\\.zprofile\\'" . sh-mode)
         ("\\.bashrc\\'"   . sh-mode))
  :hook
  ;; sh-mode が起動した時、Tree-sitter が利用可能ならそのエンジンを ON にする
  (sh-mode . (lambda ()
               (when (treesit-ready-p 'bash)
                 (treesit-major-mode-setup))
               (eglot-ensure)))
  ;:custom
  ;; デフォルトは「2」
  ;(sh-basic-offset 2)
  ;(sh-indentation 2)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((sh-mode bash-ts-mode) . ("bash-language-server" "start")))))

(provide 'shell-settings)
;;; shell-settings.el ends here
