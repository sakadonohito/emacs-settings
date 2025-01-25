;;; init-php.el --- Emacs initialization file
;;; Commentary:
;; このファイルは php-modeの設定ファイルです
;;; Code:


;;
;; php-mode
;;
;(when (require 'php-mode nil t)
;  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))
;  (add-to-list 'auto-mode-alist '("\\.tpl\\'" . php-mode))
;  (add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))
;  (setq php-search-url "http://jp.php.net/ja/")
;  (setq php-manual-url "http://jp.php.net/manual/ja/"))

;;php-modeのインデント設定
;(defun php-indent-hook ()
;  (setq indent-tabs-mode nil)
;  (setq c-basic-offset 4)
;;;(c-set-offset 'case-label '+) ;switch文のラベル
;  (c-set-offset 'arglist-intro '+) ;配列の最初の要素が改行した場合
;  (c-set-offset 'arglist-close 0)) ;配列の閉じ括弧

;(add-hook 'php-mode-hook 'php-indent-hook)

;;phpの補完を強化する
;(defun php-completion-hook()
;  (when (require 'php-completion nil t)
;	(php-completion-mode t)
;	(define-key php-mode-map (kbd "C-\\") 'phpcmp-complete)
;
;	(when (require 'auto-complete nil t)
;	  (make-variable-buffer-local 'ac-sources)
;	  (add-to-list 'ac-sources 'ac-source-php-completion)
;	  (auto-complete-mode t))))
;(add-hook 'php-mode-hook 'php-completion-hook)

;;CakePHP1.x系のcake-mode
;(when (require 'cake nil t)
;  (cake-set-default-keymap)
;  ;;標準でemacs-cakeはオフ
;  (global-cake -1))

;;CakePHP2.x系のcake-mode
;(when (require 'cake2 nil t)
;  (cake2-set-default-keymap)
;  ;;標準でemacs-cakeはオン
;  (global-cake2 t))

;;cake auto-complete
;(when (and (require 'auto-complete nil t)
;		   (require 'ac-cake nil t)
;		   (require 'ac-cake2 nil t))

;;ac-cake用の関数定義
;(defun ac-cake-hook ()
;  (make-variable-buffer-local 'ac-sources)
;  (add-to-list 'ac-sources 'ac-source-cake)
;  (add-to-list 'ac-sources 'ac-source-cake2))
;;php-mode-hookにac-cake用の関数を追加
;(add-hook 'php-mode-hook 'ac-cake-hook))


;;(load-library "php-mode")
;;(require 'php-mode)

; mmm-mode in php
;(require 'mmm-mode)
;(setq mmm-global-mode 'maybe)
;(mmm-add-mode-ext-class nil "\\.php?\\'" 'html-php)
;(mmm-add-classes
;	'((html-php
;		:submode php-mode
;		:front "<\\?\\(php\\)?"
;		:back "\\?>")))
; (add-to-list 'auto-mode-alist '("\\.php?\\'" . xml-mode))
;
;(add-hook 'php-mode-hook
;         (lambda ()
;             (require 'php-completion)
;             (php-completion-mode t)
;             (define-key php-mode-map (kbd "C-0") 'phpcmp-complete)
;             (when (require 'auto-complete nil t)
;             (make-variable-buffer-local 'ac-sources)
;             (add-to-list 'ac-sources 'ac-source-php-completion)
;             (auto-complete-mode t))))
;;拡張子関連付け
;			 (add-to-list 'auto-mode-alist '("\\.tpl$" . php-mode))
;			 (add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;			 (add-to-list 'auto-mode-alist '("\\.ctp$" . php-mode))


(leaf php-mode
  :ensure t
  :mode (("\\.php\\'" . php-mode)  ;; PHPスクリプト
         ("\\.inc\\'" . php-mode)) ;; インクルードファイル
  :custom ((php-mode-coding-style . 'psr2) ;; PSR-2スタイルを使用
           (php-indent-level . 2)         ;; インデント幅をスペース2に設定
           (indent-tabs-mode . nil)       ;; タブを使わずスペースに変換
           (tab-width . 2))               ;; タブ幅をスペース2に設定
  :hook ((php-mode . eglot-ensure)        ;; LSPを有効化
         (php-mode . (lambda ()
                       (setq indent-tabs-mode nil) ;; 再度確認
                       (setq tab-width 2))))      ;; タブ幅の再確認
  :config
  ;; 変数や関数のハイライトを有効化
  (font-lock-add-keywords
   'php-mode
   '(("\\<\\(if\\|else\\|elseif\\|while\\|for\\|foreach\\|return\\|break\\|continue\\|switch\\|case\\|default\\|try\\|catch\\|throw\\|class\\|public\\|protected\\|private\\|static\\|function\\|use\\|namespace\\|require\\|include\\|new\\)\\>"
      . font-lock-keyword-face)  ;; キーワードのハイライト
     ("\\$[a-zA-Z_][a-zA-Z0-9_]*\\>" . font-lock-variable-name-face) ;; 変数のハイライト
     ("->\\([a-zA-Z_][a-zA-Z0-9_]*\\)" 1 font-lock-function-name-face)))) ;; メソッド呼び出しのハイライト

(provide 'init-php)
;;; init-php.el ends here
