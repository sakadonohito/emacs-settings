;;; base-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs のGUIなどに関する初期設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  1. 基本設定・キーバインド
;;  2. ファイル関係設定
;;  3. テーマ
;;  4. 表示関連設定
;;     4-1. メニューバー(early-init.elへ移動)
;;     4-2. 文字サイズ(early-init.elへ移動)
;;     4-3. ウインドウ
;;     4-4. カーソル他表示関係
;;  5. ファイルツリー
;;  6. 言語設定
;;  7. 入力関係
;;  8. 使い勝手・便利設定
;;  9. CUI用クリップボード連携の設定
;; 10. sshの設定
;; 11. UI / モードラインの設定 (doom-modeline + nerd-icons)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 1. 基本的な設定・キーバインド
;; ====================================================================

(use-package emacs
  :bind
  (("C-z" . undo)                                ;; UndoをCtrl+zに
   ("C-S-z" . undo-redo)                         ;; RedoをCtrl+Shift+zに
   ("C-h" . delete-backward-char)                ;; バックスペースをCtrl+hに
   ("C-?" . help-command)                        ;; ヘルプ
   ("M-[" . switch-to-prev-buffer)               ;; 前のバッファに切り替え
   ("M-]" . switch-to-next-buffer)               ;; 次のバッファに切り替え
   ("C-x C-k" . kill-buffer)                     ;; バッファを削除
   ("C-c <left>" . windmove-left)                ;; ウィンドウ移動（左）
   ("C-c <down>" . windmove-down)                ;; ウィンドウ移動（下）
   ("C-c <up>" . windmove-up)                    ;; ウィンドウ移動（上）
   ("C-c <right>" . windmove-right)              ;; ウィンドウ移動（右）
   ("<C-tab>" . (lambda () (interactive) (other-window-or-split 1))) ;; ウィンドウ切り替え or 分割
   ("<C-S-tab>" . (lambda () (interactive) (other-window-or-split -1)))
   ;; CUI環境でも使える代替キーバインド (Meta + n / p)
   ;; うまくいかない場合は[ C-x o ]を使いましょう
   ("M-n" . (lambda () (interactive) (other-window-or-split 1)))
   ("M-p" . (lambda () (interactive) (other-window-or-split -1)))
    )
  :custom
  (backup-inhibited t)                          ;; バックアップファイルを作成しない
  (make-backup-files nil)                       ;; バックアップ無効
  (delete-auto-save-files t)                    ;; 終了時にオートセーブファイルを削除
  (setq auto-save-default nil)                  ;; 自動保存無効
  (setq auto-save-list-file-prefix nil)         ;; 自動保存のリストを作成しない
  (column-number-mode t)                        ;; 列数表示
  (line-number-mode t)                          ;; 行数表示
  (display-line-numbers-width 5)                ;; 行番号の幅
  (display-line-numbers-format "%5d")           ;; 行番号フォーマット
  (use-short-answers t)                         ;; yes/no を y/n に変更
  (tab-width 2)                                 ;; タブ文字の表示幅
  (default-tab-width 2)                         ;; タブ幅を2に設定
  (standard-indent 2)                           ;; デフォルトインデント幅を2に設定
  (indent-tabs-mode nil)                        ;; インデントでタブを使用しない
  (indent-line-function 'indent-relative-maybe) ;; 相対インデントを使用
  (ns-alt-modifier 'meta)                       ;; AltキーをMetaキーとして使用
  :config
  ;; early-init.elに設定を移動
  ;(set-face-attribute 'default nil :height 180) ;; フォントサイズを18pxに設定
  (global-display-line-numbers-mode t))         ;; 行番号を有効化

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 2. ファイル関係設定
;; ====================================================================

;; --------------------------------------------------
;; 2-1. アイコンフォントの提供元: 表示用アイコンのインストールや設定
;; 以前主流だった all-the-icons に代わり、現在はより安定している nerd-icons が標準です
;; --------------------------------------------------
(use-package nerd-icons
  :ensure t
  ;; ※注意: 初回のみ Emacs上で M-x nerd-icons-install-fonts を実行して
  ;; OSにフォントをインストールする必要があります。
  )

;; --------------------------------------------------
;; Emacs外でファイルが書き換えられたら自動で最新状態に更新
;; --------------------------------------------------
(global-auto-revert-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 3. テーマ
;; ====================================================================

;; M-x customize-themes からGUI操作でテーマ変更できるよ
(load-theme 'wheatgrass t) ;; GUI,CUI 共通

;; GUI,CUIでテーマを分けたい場合
;(if (display-graphic-p)  ;; GUI環境かどうかを判定
;    (load-theme 'spacemacs-light t)
;  (load-theme 'spacemacs-dark t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 4. 表示関連設定
;; ====================================================================

;; --------------------------------------------------
;; 4-1. メニューバー
;; --------------------------------------------------
;; early-init.elに設定を移動

;; --------------------------------------------------
;; 4-2. 文字サイズ
;; --------------------------------------------------
;; ウインドウの大きさに影響するので先に指定する
;; early-init.elに設定を移動

;; --------------------------------------------------
;; 4-3. ウィンドウ
;; --------------------------------------------------

;; ウインド透過設定はearly-init.elに移動
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

;; --------------------------------------------------
;; 複数に画面分割している時にアクティブと他ので色を差別化
;; --------------------------------------------------
(use-package dimmer
  :ensure t
  :custom
  (dimmer-fraction 0.3) ;; 非アクティブウィンドウの暗さを設定
  :config
  (dimmer-mode t))      ;; Dimmerモードを有効化

;; --------------------------------------------------
;; 4-4. カーソル他表示関係
;; --------------------------------------------------

(use-package color-identifiers-mode
  :ensure t
  :hook (after-init . global-color-identifiers-mode)) ;; 初期化後に有効化

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)) ;; プログラミングモードで有効化

;; --------------------------------------------------
;; 現在の行をハイライト
;; --------------------------------------------------
(use-package hl-line
  :ensure nil
  :init
  (global-hl-line-mode +1)
  :config
  (unless (display-graphic-p)  ;; ターミナル環境でのみ色を変更
    (set-face-background 'hl-line "#0000ff"))) ;; 222222

;; --------------------------------------------------
;; 対応括弧を強調表示
;; --------------------------------------------------
(use-package paren
  :ensure nil
  :init
  (show-paren-mode +1)) ;; 括弧の対応を強調表示

;; --------------------------------------------------
;; 末尾の空白、タブ、全角スペースを強調表示
;; --------------------------------------------------
(use-package whitespace
  :ensure nil
  :init
  (global-whitespace-mode +1)  ;; 空白強調モードを有効化
  :custom
  ;; 1. 対象の指定（行末、タブ、スペース、およびそれぞれの記号化）
  (whitespace-style '(face trailing tabs tab-mark spaces space-mark))
  ;; 2. 「スペース」の対象を「全角スペース（\u3000）」だけに限定
  (whitespace-space-regexp "\\(\u3000+\\)")
  ;; 3. 画面にどう描画するか（マッピング）
  ;;    タブは「»」、全角スペースは「□」で表示する
  (whitespace-display-mappings
   '((tab-mark   ?\t   [?\u00BB ?\t] [?\\ ?\t])
     (space-mark ?\u3000 [?\u25A1]     [?_])))
  :config
  ;; 記号の色調整
  (set-face-attribute 'whitespace-tab nil :background 'unspecified :foreground "gray40")
  (set-face-attribute 'whitespace-space nil :background 'unspecified :foreground "gray40"))

;; --------------------------------------------------
;; インデントを可視化
;; --------------------------------------------------
(use-package highlight-indent-guides
  :ensure t
  :hook ((prog-mode . highlight-indent-guides-mode)       ;; プログラムモードで有効化
         (text-mode . highlight-indent-guides-mode))     ;; テキストモードで有効化
  :custom
  (highlight-indent-guides-method 'character)             ;; インデントを文字で表示
  (highlight-indent-guides-character 124)                 ;; '|'で表示
  (highlight-indent-guides-responsive 'top))              ;; レスポンシブ設定



;; --------------------------------------------------
;; 4-4. UI / モードラインの設定 (doom-modeline + nerd-icons)
;;      ※nerd-iconsは「2. ファイル関係設定」で設定済み
;; --------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1) ;; 全画面で有効化
  :custom
  (doom-modeline-height 35)               ;; モードラインの高さ（少し高めが見やすいです）
  (doom-modeline-bar-width 4)             ;; 左端のアクセントバーの太さ
  (doom-modeline-icon t)                  ;; アイコン表示を有効化
  (doom-modeline-major-mode-icon t)       ;; 言語(メジャーモード)のアイコンを表示
  (doom-modeline-major-mode-color-icon t) ;; アイコンに色をつける
  ;; ファイルパスの表示方法（プロジェクトのルートからの相対パスでスッキリ表示）
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-vcs-max-length 25)       ;; Gitのブランチ名が長すぎる場合に省略する長さ
  (doom-modeline-enable-word-count nil)   ;; 単語数カウントは重くなることがあるので無効化
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 5. ファイルマネージャー
;; 左サイドに表示するキーバインドの設定
;; ====================================================================

;; --------------------------------------------------
;;; ファイルマネージャ / サイドバー (Dirvish)
;; --------------------------------------------------
(use-package dirvish
  :ensure t
  :init
  ;; Emacs標準の dired をすべてモダンな dirvish に置き換える
  (dirvish-override-dired-mode)

  ;; 【今回追加】M-o を「フォーカス移動」ではなく「直接の開閉（トグル）」にする独自機能
  (defun my-dirvish-side-toggle-strictly ()
    "現在のウィンドウから移動せずに、サイドバーが存在すれば閉じ、なければ開く"
    (interactive)
    (let ((win (window-with-parameter 'window-side)))
      (if win
          ;; サイドバーが開いていれば、一度そこを選択して安全に閉じる
          (progn
            (select-window win)
            (dirvish-quit))
        ;; 開いていなければ通常通りサイドバーを呼び出す
        (dirvish-side))))

  :bind (;; 1. グローバルキーバインド: M-o でサイドバーをトグル表示(独自関数を割り当て)
         ("M-o" . my-dirvish-side-toggle-strictly)
         ;; 2. Dirvish操作中のローカルキーバインド
         :map dirvish-mode-map
         ;; NeoTreeのように、ディレクトリ上でTABを押すと「その場でツリー展開/折りたたみ」する
         ("TAB" . dirvish-subtree-toggle)
         ;; q を押した時にサイドバー（またはDirvish全体）を閉じる
         ("q" . dirvish-quit))
  :custom
  ;; サイドバーの幅（お好みで数値を調整してください）
  (dirvish-side-width 30)
  ;; サイドバーでファイルを開いた際、サイドバーを自動で閉じるか（nilなら開きっぱなし）
  (dirvish-side-auto-close nil)
  ;; UIをリッチにする属性の有効化（アイコン表示、ツリー表示の許可、Gitのステータスなど）
  (dirvish-attributes '(nerd-icons collapse git-msg))
  ;;(dired-listing-switches "-alh --group-directories-first") ;; 隠しファイルも表示
  :config
  ;; macOSなど特定の環境で C-x C-f でディレクトリが開けなくなる問題の対策
  (setq dired-use-ls-dired nil)
  ;; 隠しファイル（-a）と詳細リスト（-l）、読みやすいサイズ表記（-h）
  (setq dired-listing-switches "-alh")
)

;; dirvishに移行したので無効
;(use-package neotree
;  :ensure t
;  :custom
;  (neo-theme 'ascii)               ;; ASCII 表示を使用
;  (neo-persist-show t)             ;; neotree を常に表示
;  (neo-smart-open t)               ;; 現在のファイルに基づいて自動的に開く
;  (neo-show-hidden-files t)        ;; 隠しファイルも表示
;  (neo-window-width 30)            ;; neotree のウィンドウ幅を 30 に設定
;  :bind (("M-o" . neotree-toggle)
;         ("C-c d" . make-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 6. 言語設定
;; ====================================================================

;; early-init.elに設定を移動

;(set-language-environment 'Japanese)
;(prefer-coding-system 'utf-8)

;; 日本語フォント設定
;(when (display-graphic-p)
;  (set-face-attribute 'default nil :family "JetBrains Mono" :height 130))

;; ※Macの場合は半角と全角の比率を1:2に
;(when (and (eq window-system 'ns) (eq current-os 'IS-MAC))
  ;; 英数字（ベース）をNoto Sans JPに
  ;(set-face-attribute 'default nil :family "Noto Sans JP")
  ;(set-face-attribute 'default nil :family "JetBrains Mono" :height 130)
  ;(set-face-attribute 'default t :family "JetBrains Mono" :height 130)

  ;; 日本語も明示的にNoto Sans JPに上書き指定
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Noto Sans JP"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Noto Sans CJK JP"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Hiragino Kaku Gothic ProN"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Microsoft Sans Serif"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Toppan Bunkyu Gothic"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "YuGothic"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Bizin Gothic Discord NF"))
  ;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "PlemolJP Console NF"))
  ;(set-fontset-font t 'japanese-jisx0208 (font-spec :family "PlemolJP Console NF"))

  ;(setq face-font-rescale-alist '((".*Hiragino_Mincho_pro.*" . 1.2)))
;)

;(when (eq current-os 'IS-WINDOWS)
;  (set-face-font 'default "MS UI Gothic-14"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 7. 入力関係
;; ====================================================================

;; --------------------------------------------------
;; 選択範囲の上書きペースト
;; --------------------------------------------------
(use-package delsel
  :ensure nil
  :init
  (delete-selection-mode t))

;; --------------------------------------------------
;; 自動的に括弧を閉じる(括弧を自動補完)
;; --------------------------------------------------
(use-package elec-pair
  :ensure nil
  :init
  (electric-pair-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8. 使い勝手・便利設定
;; ====================================================================

;; ToDo: これは不要なのか確認する
;(setq mac-pass-control-to-system nil)  ;; macOSのイベント処理をEmacs側で完全管理

;; --------------------------------------------------
;; カスタム関数の定義
;; C-tab で画面分割してカーソルを移動するショートカット的機能
;; --------------------------------------------------
(defun other-window-or-split (val)
  "C-tab で画面分割してVALウインドウにカーソルを移動するショートカット的機能."
  (interactive)
  (when (one-window-p)
    (split-window-horizontally)) ;split horizontally
  (other-window val))


;; --------------------------------------------------
;; 超高速検索と、検索結果からの安全な一括置換
;; --------------------------------------------------

;; 1. wgrep (検索結果バッファを直接編集してファイルに反映する魔法のツール)
(use-package wgrep
  :ensure t
  :custom
  ;; 編集を完了(C-c C-c)した際、変更されたすべてのファイルを自動的に保存する
  (wgrep-auto-save-buffer t))

;; 2. deadgrep (ripgrepを使ってプロジェクト全体を検索し、一覧表示する)
;; ※ripgrepを事前にインストールしておく
;; mac -> brew install ripgrep
;; win -> winget install BurntSushi.ripgrep.MSVC
;; or  -> scoop install ripgrep
;; or  -> choco install ripgrep
;; Linux -> sudo apt install ripgrep (Ubuntu/Debianの場合)
(use-package deadgrep
  :ensure t
  :bind
  ;; 検索をすぐに呼び出せるようにキーバインドを設定（お好みで変更してください）
  ;; 例として、C-c d (deadgrepのd) に割り当てています
  ;; ミニバッファで検索条件指定後のdeadgrepウインドウで検索条件を編集したりできます
  ;; deadgrepウインドウで「e」を押すと編集モード(wgrep)になります。
  ;; wgrepモードで「M-%」することで一括置換できます。
  ("C-c d" . deadgrep))


;; --------------------------------------------------
;; visual-regexp パッケージの設定
;; 正規表現操作を見た目でわかりやすく
;; --------------------------------------------------
(use-package visual-regexp
  :ensure t
  :bind (("M-%" . vr/query-replace)))

;; --------------------------------------------------
;; org-modeやmarkdownのテーブルで日本語のズレを防止
;; --------------------------------------------------
(use-package valign
  :ensure t
  :hook ((org-mode . valign-mode)
         (markdown-mode . valign-mode)))

;; --------------------------------------------------
;; エラーなどで鳴る「ビープ音」や「画面のフラッシュ」を無効化
;; --------------------------------------------------
(setq ring-bell-function 'ignore)

;; --------------------------------------------------
;; ロックファイル作成を無効化
;; --------------------------------------------------
(setq create-lockfiles nil)

;; --------------------------------------------------
;; 次に押せるキーの一覧と説明ポップアップ表示
;; --------------------------------------------------
(use-package which-key :init (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 9. CUI用クリップボード連携の設定
;;; --------------------------------------------------
;;; * クリップボード連携の包括的設定
;;; * GUI環境（Mac, Linux, Windows）はEmacs本体の標準機能で自動連携するため設定不要。
;;; * 以下のブロックは CUI (emacs -nw) 起動時のみ評価されるOS別の連携処理です。
;;; --------------------------------------------------
;;; ====================================================================

(unless (display-graphic-p) ;; CUI環境でのみ実行
  (cond
   ;; --------------------------------------------------
   ;; 1. Mac の CUI環境 (pbcopy / pbpaste を使用)
   ;; --------------------------------------------------
   (mac-p
   ;((eq system-type 'darwin)
    (defun my-cui-clipboard-copy (text &optional push)
      (let ((process-connection-type nil))
        (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
          (process-send-string proc text)
          (process-send-eof proc))))
    ;(defun my-cui-clipboard-paste ()
    ;  (shell-command-to-string "pbpaste"))
    (defun my-cui-clipboard-paste ()
      ;; shellを経由せず、直接 pbpaste バイナリを実行して文字列を取得する（安全・爆速）
      (with-temp-buffer
        (call-process "pbpaste" nil t nil)
        (buffer-string)))
    (setq interprogram-cut-function 'my-cui-clipboard-copy)
    (setq interprogram-paste-function 'my-cui-clipboard-paste))

   ;; --------------------------------------------------
   ;; 2. Windows WSL の CUI環境 (Linuxとして認識されるが、Windowsのコマンドを使用)
   ;; --------------------------------------------------
   ((and linux-p
   ;((and (eq system-type 'gnu/linux)
         (string-match-p "microsoft\\|wsl" (shell-command-to-string "uname -r")))
    (defun my-cui-clipboard-copy (text &optional push)
      (let ((process-connection-type nil))
        ;; WSLからWindows側のclip.exeを呼び出す
        (let ((proc (start-process "clip.exe" "*Messages*" "clip.exe")))
          (process-send-string proc text)
          (process-send-eof proc))))
    (defun my-cui-clipboard-paste ()
      ;; PowerShellを経由して取得し、末尾の不要な改行をトリムする
      (string-trim-right
       (shell-command-to-string "powershell.exe -NoProfile -Command Get-Clipboard")))
    (setq interprogram-cut-function 'my-cui-clipboard-copy)
    (setq interprogram-paste-function 'my-cui-clipboard-paste))

   ;; --------------------------------------------------
   ;; 3. 純粋な Linux の CUI環境 (xclip を使用)
   ;; --------------------------------------------------
   (linux-p
   ;((eq system-type 'gnu/linux)
    ;; OS側に xclip コマンドがインストールされている前提
    (when (executable-find "xclip")
      (defun my-cui-clipboard-copy (text &optional push)
        (let ((process-connection-type nil))
          (let ((proc (start-process "xclip" "*Messages*" "xclip" "-selection" "clipboard" "-in")))
            (process-send-string proc text)
            (process-send-eof proc))))
      (defun my-cui-clipboard-paste ()
        (shell-command-to-string "xclip -selection clipboard -out"))
      (setq interprogram-cut-function 'my-cui-clipboard-copy)
      (setq interprogram-paste-function 'my-cui-clipboard-paste)))

   ;; --------------------------------------------------
   ;; 4. Windows の CUI環境 (コマンドプロンプトやPowerShell等)
   ;; --------------------------------------------------
   (windows-p
   ;((eq system-type 'windows-nt)
    (defun my-cui-clipboard-copy (text &optional push)
      (let ((process-connection-type nil))
        (let ((proc (start-process "clip" "*Messages*" "clip")))
          (process-send-string proc text)
          (process-send-eof proc))))
    (defun my-cui-clipboard-paste ()
      (string-trim-right
       (shell-command-to-string "powershell.exe -NoProfile -Command Get-Clipboard")))
    (setq interprogram-cut-function 'my-cui-clipboard-copy)
    (setq interprogram-paste-function 'my-cui-clipboard-paste))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ====================================================================
;;; 10. sshの設定
;;; ====================================================================

;; --------------------------------------------------
;; * デフォルトでSSHを仕様
;; * プロキシ設定の追加
;; --------------------------------------------------
(use-package tramp
  :ensure nil
  :custom
  (tramp-default-method "ssh")
  :config
  (add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist '("localhost" nil nil))
  (add-to-list 'tramp-default-proxies-alist `((regexp-quote (system-name)) nil nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'base-settings)
;;; base-settings.el ends here
