;;; terminal.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは ターミナル環境の設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 9. ターミナルの設定
;; ====================================================================

;; -------------------------------------------------------------------
;; 9-1. ターミナルエミュレータ「eat」本体の設定
;; -------------------------------------------------------------------
(use-package eat
  :preface ;; 遅延ロード対策 自作変数や関数の定義
  (defvar eat-buffer-name)
  ;; ---------------------------------------------------------
  ;; ① [C-c t] 新しいターミナルを生成する関数
  ;; ---------------------------------------------------------
  (defun my-eat-new-window ()
    "別ウインドウを分割して、最初からユニークな名前でeatバッファを作成する"
    (interactive)
    (split-window-below)   ;; 下にウインドウを分割
    (other-window 1)       ;; 分割した下のウインドウに移動
    (let ((display-buffer-overriding-action '((display-buffer-same-window)))
          ;; 生成予定のバッファ名を「ユニークな連番名」にすり替える
          (eat-buffer-name (generate-new-buffer-name "*eat*")))
      (eat)))

  ;; ---------------------------------------------------------
  ;; ② [C-c s] 画面下部に固有ターミナルを出し入れ(トグル)する関数
  ;; ---------------------------------------------------------
  (defun my-eat-toggle ()
    "画面下部に固定サイズのeatターミナルを出し入れ（トグル）する"
    (interactive)
    (let* ((buf-name "*shell-pop-eat*");; 1. 固有のバッファ名を指定
           (buf (get-buffer buf-name));; バッファが存在するかチェック
           (win (and buf (get-buffer-window buf))));; 画面上に表示されているかチェック
      (if win
          ;; トグルOFF
          (delete-window win)
        ;; トグルON（画面下に出す）
        (select-window (split-window-below -15))
        (if buf
            ;; 存在していれば使い回す
            (switch-to-buffer buf)
          ;; 存在していなければ新規に生成する
          (let ((display-buffer-overriding-action '((display-buffer-same-window)))
                (eat-buffer-name buf-name))
            (eat)))))) ;; buf-nameで新規eat生成

  ;; ---------------------------------------------------------
  ;; ③ [C-c C-k] バッファとウインドウを抹消する関数: eat標準のkill buffer カスタマイズ
  ;; ---------------------------------------------------------
  (defun my-eat-kill-buffer-and-window ()
    "現在のeatバッファをプロセス警告なしで強制終了し、ウインドウも閉じる"
    (interactive)
    (let ((buf (current-buffer))
          (process (get-buffer-process (current-buffer))))
      ;; 1. プロセスが動いていたら「killしていい？」の確認を無効化する魔法
      (when process
        (set-process-query-on-exit-flag process nil))

      ;; 2. ウインドウが分割されていれば、まずウインドウ枠を閉じる
      (unless (one-window-p)
        (delete-window))

      ;; 3. 裏側でバッファを確実に消し去る（プロセスも死ぬ）
      (kill-buffer buf)
      ))

  :functions eat-semi-char-mode         ;; 「後で定義されるから警告しないで」と伝える
  :ensure t
  :bind (
         ("C-c t" . my-eat-new-window)  ;; terminalのt。コマンドごとに新規ウインドウ
         ("C-c e" . eat)                ;; eatのe。標準のeatを起動
         ("C-c s" . my-eat-toggle)      ;; shellのs。固有ターミナルをトグルする関数
         :map eat-mode-map
         ("C-c C-k" . my-eat-kill-buffer-and-window) ;; kill buffer のオーバーライド
         )
  :custom
  (eat-term-name "xterm-256color")      ;; top/tail -f の色・表示が安定
  (eat-kill-buffer-on-exit t)           ;; ターミナル終了時にバッファも消す
  :config
  ;(setq eat-shell "zsh")                ;; 自動で$SHELLを読み込むので指定不要。書き換え用に消さずに残す
  (cond
   ;; Windows環境の場合 (PowerShellやGit Bashなどを明示的に指定してください)
   (windows-p ;; (eq system-type 'windows-nt)
    (setq eat-shell "pwsh")) ;; または "powershell", "bash" など環境に合わせて
   ;; Mac / Linux環境の場合はOSの $SHELL を適用する
   (t
    ;; 何もしない（自動で $SHELL が読み込まれる）
    ))

  ;; ---------------------------------------------------------
  ;; ④ 見た目の調整（フック）
  ;; ---------------------------------------------------------
  (add-hook 'eat-mode-hook
            (lambda ()
              (display-line-numbers-mode -1) ;; 行番号を非表示
              (setq-local cursor-type 'bar)  ;; barカーソルにする
              ))
)

(provide 'terminal)
;;; terminal.el ends here
