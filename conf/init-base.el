;;; init-base.el --- Emacs initialization file
;;; Commentary:
;; このファイルは Emacs のGUIなどに関する初期設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; leafでまとめて設定する
(leaf cus-start
  :doc "Basic UI/UX settings for Emacs"
  :custom '((backup-inhibited . t)                      ; バックアップファイルを作成しない
            (make-backup-files . nil)                   ; バックアップ無効
            (delete-auto-save-files . t)                ; 終了時にオートセーブファイルを削除
	    (line-number-mode . t)                        ; 行数表示
            (display-line-numbers-width . 5)            ; 行番号の幅
            (display-line-numbers-format . "%5d")       ; 行番号フォーマット
            (use-short-answers . t)                     ; yes/no を y/n に変更
	    (inhibit-startup-message . t)                 ; 起動時の画面はいらない
	    (current-language-environment . "Japanese") ; 言語環境を日本語に設定
	    (prefer-coding-system . 'utf-8)             ; デフォルト文字コードをUTF-8に設定
	    (default-tab-width . 2)                      ;; タブ幅を2に設定
	    (indent-tabs-mode . nil)                    ;; インデントでタブを使用しいない
            (indent-line-function . 'indent-relative-maybe) ;; 相対インデントを使用
            (ns-alt-modifier . 'meta)                 ;; AltキーをMetaキーとして使用
	    )
  :config
  (auto-image-file-mode t)                              ; 画像ファイルを表示する
  (set-face-attribute 'default nil :height 180)         ; フォントサイズを18pxに設定
  (global-display-line-numbers-mode t))                 ; 行番号を有効化
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ファイル関係

;; 画像ファイルを表示する
;(auto-image-file-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 画面表示

;; メニューバーを隠す
(tool-bar-mode -1)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)

;; 行数表示
;(line-number-mode t)

;; 左側に行番号表示
;(global-display-line-numbers-mode t)
;(setq display-line-numbers-width 5)  ;; 5桁分の幅を確保
;(setq display-line-numbers-format "%5d")  ;; 行番号を5桁で表示


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ウィンドウ設定
;;
;; 文字サイズの指定
;; ウインドウの大きさに影響するので先に指定する
;; デフォルトのフォントサイズを18pxに設定(程よく大きいほうが目が疲れない)
;(set-face-attribute 'default nil :height 180)

(if window-system
    ;; ウィンドウ幅を100文字分、ウィンドウ高さを40行分に設定
    (add-to-list 'default-frame-alist '(width . 100))
)

;; ウィンドウ半透明ブームは終わったのでこの設定は使いません
;(if window-system (progn
;  (set-background-color "Black")
;  (set-foreground-color "LightGray")
;  (set-cursor-color "VioletRed")
;  (set-frame-parameter nil 'alpha 80)
;))

;; ウィンドウを透明化
;(add-to-list 'default-frame-alist '(alpha . (0.75 0.75)))

;; for Linux
;(when (eq system-type 'gnu/linux)
;  (setq default-frame-alist
;	(append (list
;		 '(alpha . (70 100 100 100))
;		 )
;		default-frame-alist))
;)
;; for Windows
;(when (eq system-type 'windows-nt)
;  (setq default-frame-alist
;	(append (list
;		 '(width . 100)
;		 '(height . 36)
;		 '(top . 10)
;		 '(left . 20))
;		default-frame-alist))
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; テーマ
;;; 色々試したが挫折
;; 背景色: アイボリー
;(set-face-background 'default "#fdf6e3") ;#FDF6E3
;; テキストカラー: 濃いグレー
;(set-face-foreground 'default "#333333")
;; キーワード: ソフトブルー
;(set-face-foreground 'font-lock-keyword-face "#268BD2")
;; コメント: グレイッシュグリーン
;(set-face-foreground 'font-lock-comment-face "#874608") ;#93A1A1 / #667575 / #586e75
;; カーソル: 穏やかな青色
;(set-cursor-color "#176296") ;#268BD2
;; 選択範囲: 淡い青
;(set-face-background 'region "#E1F5FE")

;;; 結局はコレ
;(use-package solarized-theme
;  :straight t
;  :config
;  (if window-system
;      (load-theme 'solarized-light t) ;; GUI環境でのテーマ
;    ;;ターミナル環境は何もしないに変更
;;;    (load-theme 'solarized-dark t)))  ;; ターミナル環境でのテーマ
;    ))

;(if window-system
;    ;; GUI環境でのテーマ
;    (use-package solarized-theme
;      :ensure t
;      :config
;      (load-theme 'solarized-light t))
;  ;; ターミナル環境でのテーマ
;  (use-package solarized-theme
;    :ensure t
;    :config
;    (load-theme 'solarized-dark t)))

;; leaf版
(leaf solarized-theme
  :ensure t
  :config
  (if (display-graphic-p)  ;; GUI環境かどうかを判定
      (load-theme 'solarized-light t)  ;; GUI環境では light テーマをロード
    ;; ターミナル環境では何もしない
    ))

;; 起動時の画面はいらない
;(setq inhibit-startup-message t)

;; 複数に画面分割している時にアクティブと他ので色を差別化
(leaf dimmer
  :ensure t
  :custom
  '((dimmer-fraction . 0.3)) ;; 非アクティブウィンドウの暗さを設定
  :config
  (dimmer-mode t)) ;; Dimmerモードを有効化

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; カーソル色表示

;; シンタックスハイライトの色付けをオン
;(global-font-lock-mode 1)

;; color-identifiers-mode
;(straight-use-package 'color-identifiers-mode)
;; color-identifiers-mode を有効にする
;(with-eval-after-load 'color-identifiers-mode
;  (global-color-identifiers-mode t))

;(add-hook 'after-init-hook 'global-color-identifiers-mode)

;; rainbow delimiters
;(straight-use-package 'rainbow-delimiters)
;(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; leaf版
(leaf global-font-lock
  :doc "Enable syntax highlighting globally"
  :config
  (global-font-lock-mode 1))  ;; シンタックスハイライトを有効化

(leaf color-identifiers-mode
  :ensure t
  :hook (after-init-hook . global-color-identifiers-mode))  ;; 初期化後に有効化

(leaf rainbow-delimiters
  :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))  ;; プログラミングモードで有効化

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; neotree
;; 左サイドにファイルツリーを表示する
;(use-package neotree
;  :straight t
;  :config
;  ;; neotree のカスタム設定
;  (setq neo-theme 'ascii)                    ;; ASCII 表示を使用
;  (setq neo-persist-show t)                  ;; neotree を常に表示
;  (setq neo-smart-open t)                    ;; 現在のファイルに基づいて自動的に neotree を開く
;  (setq neo-show-hidden-files t)             ;; 隠しファイルも表示
;  (setq neo-window-width 30)                 ;; neotree のウィンドウ幅を 30 に設定
;  )
;(global-set-key (kbd "M-o") 'neotree-toggle)
;(global-set-key (kbd "C-c d") 'make-directory)

;; leaf版
(leaf neotree
  :ensure t
  :custom ((neo-theme . 'ascii)               ;; ASCII 表示を使用
           (neo-persist-show . t)             ;; neotree を常に表示
           (neo-smart-open . t)               ;; 現在のファイルに基づいて自動的に開く
           (neo-show-hidden-files . t)        ;; 隠しファイルも表示
           (neo-window-width . 30))           ;; neotree のウィンドウ幅を 30 に設定
  :bind (("M-o" . neotree-toggle)             ;; ショートカットキーを設定
         ("C-c d" . make-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 言語設定
;(set-language-environment 'Japanese)
;(prefer-coding-system 'utf-8)

;; Mac OS X 10.9専用
;(when (and (eq window-system 'ns) (eq system-type 'darwin))
;(when (and (eq window-system 'ns) (eq current-os IS-MAC))
;
;;;日本語
;  (set-fontset-font
;   nil 'japanese-jisx0208
;   (font-spec :family "Hiragino Kaku Gothic ProN"));;font
;
;;; 半角と全角の比を1:2に
;  (setq face-font-rescale-alist
;	'((".*Hiragino_Mincho_pro.*" .1.2)))
;)

;; for Windows
;(when (eq system-type 'windows-nt)
;(when (eq current-os IS-WINDOWS)
;  (set-face-font 'default "MS UI Gothic-14" ))


(leaf mac-fonts
  :doc "Font settings for macOS"
  :if (and (eq window-system 'ns) (eq current-os 'IS-MAC)) ;; macOS専用設定
  :config
  (set-fontset-font nil 'japanese-jisx0208
                    (font-spec :family "Hiragino Kaku Gothic ProN")) ;; 日本語フォントを設定
  (setq face-font-rescale-alist
        '((".*Hiragino_Mincho_pro.*" . 1.2))))           ;; 半角と全角の比率を1:2に

(leaf windows-fonts
  :doc "Font settings for Windows"
  :if (eq current-os 'IS-WINDOWS)  ;; Windows専用設定
  :config
  (set-face-font 'default "MS UI Gothic-14")) ;; Windows用フォントを設定

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 入力関係

;;; タブキー/インデント
;(setq default-tab-width 2 indent-tab-mode nil)
;(setq indent-line-function 'indent-relative-maybe)

;; Altがどの環境でもMetaキーになるように設定(ターミナルからだとEscがMetaキーになる場合あんねん)
;(setq ns-alt-modifier (quote meta))

;;; キーバインド
;(global-set-key "\C-z" 'undo)
;(global-set-key "\C-h" 'delete-backward-char)

;; redo
;; redo+ パッケージをインストール
;(straight-use-package
; '(redo+ :type git :host github :repo "emacsmirror/redo-plus"))
;(require 'redo+)
;(global-set-key (kbd "C-S-z") 'redo)


;; 検索文字列のC-hで削除
;(define-key isearch-mode-map (kbd "C-h") 'isearch-del-char)

;; バッファきりかえ
;(global-set-key (kbd "M-[") 'switch-to-prev-buffer)
;(global-set-key (kbd "M-]") 'switch-to-next-buffer)

;; kill buffer のキーバインド変更
;(define-key global-map (kbd "C-x C-k") 'kill-buffer)


;; ウィンドウの移動に関するキーバインド
;(global-set-key (kbd "C-c <left>") 'windmove-left)
;(global-set-key (kbd "C-c <down>") 'windmove-down)
;(global-set-key (kbd "C-c <up>") 'windmove-up)
;(global-set-key (kbd "C-c <right>") 'windmove-right)

;; ?無効にして大丈夫?
(defun other-window-or-split (val)
  (interactive)
  (when (one-window-p)
    (split-window-horizontally) ;split horizontally
    ;(split-window-vertically) ;split vertically
  )
  (other-window val))

;(global-set-key (kbd "<C-tab>") (lambda () (interactive) (other-window-or-split 1)))
;(global-set-key (kbd "<C-S-tab>") (lambda () (interactive) (other-window-or-split -1)))


;;; 他入力編集
;; 選択範囲を上書きペースト
;(delete-selection-mode t)

;; visual-regexpに置き換え
;(use-package visual-regexp
;  :straight t
;  :bind
;  ("M-%" . vr/query-replace))  ;; M-% で visual-regexp を使う

;(autoload 'vr/query-replace "visual-regexp" "visual regexp" t)
;(global-set-key (kbd "M-%") 'vr/query-replace)

;; leaf版

;; キーバインドの設定をまとめる
(leaf key-bindings
  :doc "Custom key bindings"
  :bind (("C-z" . undo)                                ;; UndoをCtrl+zに
         ("C-S-z" . undo-redo)                         ;; RedoをCtrl+Shift+zに
         ("C-h" . delete-backward-char)                ;; バックスペースをCtrl+hに
         ("M-[" . switch-to-prev-buffer)               ;; 前のバッファに切り替え
         ("M-]" . switch-to-next-buffer)               ;; 次のバッファに切り替え
         ("C-x C-k" . kill-buffer)                     ;; バッファを削除
         ("C-c <left>" . windmove-left)                ;; ウィンドウ移動（左）
         ("C-c <down>" . windmove-down)                ;; ウィンドウ移動（下）
         ("C-c <up>" . windmove-up)                    ;; ウィンドウ移動（上）
         ("C-c <right>" . windmove-right)              ;; ウィンドウ移動（右）
         ("<C-tab>" . (lambda () (interactive) (other-window-or-split 1))) ;; ウィンドウ切り替え or 分割
         ("<C-S-tab>" . (lambda () (interactive) (other-window-or-split -1)))))

;; redo+ パッケージの設定
;(leaf redo+
;  :ensure t
;  :bind (("C-S-z" . redo))                              ;; RedoをCtrl+Shift+zに
;  :config
;  (require 'redo+))

;; 選択範囲の上書きペースト
(leaf delete-selection
  :doc "Enable overwrite paste for selection"
  :init
  (delete-selection-mode t))

;; visual-regexp パッケージの設定
;(leaf visual-regexp
;  :ensure t
;  :bind (("M-%" . vr/query-replace)))                   ;; M-%でvisual-regexpを使用

;; 検索モードでの文字削除
;(leaf isearch
;  :doc "Customizations for isearch"
;  :bind (:map isearch-mode-map
;              ("C-h" . isearch-del-char)))             ;; 検索中のC-hで削除可能


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 使い勝手
;; yes-or-noをy-or-nに変更
;(setq use-short-answers t)

;; 対応括弧を強調表示
;(use-package paren
;  :straight nil  ;; Emacs 組み込みの機能なのでインストールは不要
;  :init
;  (show-paren-mode +1))

;; 自動的に括弧を閉じる
;(use-package elec-pair
;  :straight nil  ;; Emacs 組み込みの機能なのでインストールは不要
;  :init
;  (electric-pair-mode +1))

;; 現在の行をハイライト
;(use-package hl-line
;  :straight nil  ;; Emacs 組み込みの機能なのでインストールは不要
;  :init
;  (global-hl-line-mode +1)
;  :config
;  ;; ターミナル環境の時だけhl-lineの色を変更
;  (unless (display-graphic-p)
;    (set-face-background 'hl-line "#222222")))  ;; 暗い背景色

;; 末尾の空白のみを強調表示
;(use-package whitespace
;  :straight nil  ;; Emacs 組み込みパッケージなのでインストールは不要
;  :custom
;  (whitespace-style '(face trailing))
;  :init
;  (global-whitespace-mode +1))

;; インデントを可視化
;(use-package highlight-indent-guides
;  :straight t
;  :custom ((highlight-indent-guides-method 'character)
;           (highlight-indent-guides-character 124)
;           (highlight-indent-guides-responsive 'top))
;;  :bind (nil
;;         :map my-toggle-map
;;	 ("i" . highlight-indent-guides-mode))
;  :hook ((prog-mode . highlight-indent-guides-mode)
;	 (text-mode . highlight-indent-guides-mode)))


;; org-mode や markdown のテーブル機能で日本語が含まれてもずれないように
;(use-package valign
;  :straight t
;  :hook ((org-mode . valign-mode)
;         (markdown-mode . valign-mode)))

;(setq mac-pass-control-to-system nil)  ;; macOSのイベント処理をEmacs側で完全管理

; Windows向けクリップボード利用
;(when (eq system-type 'windows-nt)
;  (setq select-enable-clipboard t))

;; leaf版
;; 対応括弧を強調表示
(leaf paren
  :doc "Show matching parentheses"
  :init
  (show-paren-mode +1))  ;; 括弧の対応を強調表示

;; 自動的に括弧を閉じる
(leaf elec-pair
  :doc "Automatically insert matching parentheses"
  :init
  (electric-pair-mode +1))  ;; 括弧を自動補完

;; 現在の行をハイライト
(leaf hl-line
  :doc "Highlight the current line"
  :init
  (global-hl-line-mode +1)  ;; 現在の行をハイライト
  :config
  (unless (display-graphic-p)  ;; ターミナル環境でのみ色を変更
    (set-face-background 'hl-line "#222222")))  ;; 暗い背景色

;; 末尾の空白を強調表示
(leaf whitespace
  :doc "Highlight trailing whitespace"
  :custom ((whitespace-style . '(face trailing)))  ;; 末尾の空白を強調
  :init
  (global-whitespace-mode +1))  ;; 空白強調モードを有効化

;; インデントを可視化
(leaf highlight-indent-guides
  :doc "Visualize indentation levels"
  :ensure t
  :custom ((highlight-indent-guides-method . 'character)  ;; インデントを文字で表示
           (highlight-indent-guides-character . 124)     ;; '|'で表示
           (highlight-indent-guides-responsive . 'top))  ;; レスポンシブ設定
  :hook ((prog-mode . highlight-indent-guides-mode)       ;; プログラムモードで有効化
         (text-mode . highlight-indent-guides-mode)))     ;; テキストモードで有効化

;; org-modeやmarkdownのテーブルで日本語のズレを防止
(leaf valign
  :doc "Align tables in org-mode and markdown-mode"
  :ensure t
  :hook ((org-mode . valign-mode)                         ;; org-modeで有効化
         (markdown-mode . valign-mode)))                  ;; markdown-modeで有効化

;; Windows向けクリップボード利用
(leaf windows-clipboard
  :doc "Enable clipboard integration on Windows"
  :if (eq system-type 'windows-nt)  ;; Windows環境でのみ適用
  :custom ((select-enable-clipboard . t)))  ;; クリップボードを有効化

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sshの設定
;; この設定の記述はここでよいのだろうか？
;(require 'tramp)
;(setq tramp-default-method "ssh")
;(add-to-list 'tramp-default-proxies-alist
;	     '(nil "\\`root\\'" "/ssh:%h:"))
;(add-to-list 'tramp-default-proxies-alist
;	     '("localhost" nil nil))
;(add-to-list 'tramp-default-proxies-alist
;	     '((regexp-quote (system-name)) nil nil))

(leaf tramp
  :doc "Transparent Remote Access, Multiple Protocols"
  :require t
  :custom ((tramp-default-method . "ssh"))  ;; デフォルトでSSHを使用
  :config
  ;; プロキシの設定を追加
  (add-to-list 'tramp-default-proxies-alist
               '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist
               '("localhost" nil nil))
  (add-to-list 'tramp-default-proxies-alist
               `((regexp-quote (system-name)) nil nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'init-base)
;;; init-base.el ends here
