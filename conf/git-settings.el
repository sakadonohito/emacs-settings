;;; git-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは Emacs のGit関連設定ファイルです。
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 7. Gitの設定 (Magit + Forge + 関連ツール)
;; ====================================================================

;; --------------------------------------------------
;; 7-1. Magit: エディタ内Gitクライアントの最高峰
;; --------------------------------------------------
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)       ;; Magitのメイン画面を開く
         ("C-x M-g" . magit-dispatch))  ;; どこからでもGitコマンドを呼び出す
  :custom
  (magit-auto-revert-mode t)            ;; ファイルの変更を自動でバッファに反映
  ;; Magitの画面分割をシンプルにし、現在のウィンドウを乗っ取る形にする（好みに応じて変更可）
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (magit-save-repository-buffers 'dontask)) ;; 未保存バッファを尋ねずに自動保存する

;; --------------------------------------------------
;; 7-2. Forge: GitHub/GitLabのIssueやPRをMagit内で操作
;; --------------------------------------------------
(use-package forge
  :after magit
  :ensure t
  :custom
  (forge-topic-list-limit '(10 . 0)) ;; オープンなIssue/PRを10件までに絞る（動作を軽量化）
  ) ;; Magitが読み込まれた後に自動で有効化

;; --------------------------------------------------
;; 7-3. diff-hl: 変更箇所を画面左端に色付きで可視化
;; --------------------------------------------------
(use-package diff-hl
  :ensure t
  :init
  (global-diff-hl-mode)
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode) ;; ドキュメントやメモ帳(Markdown, Org等)でも有効化
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; CUI(ターミナル)環境では標準のフリンジ(端の余白)が使えないため、
  ;; 文字領域(マージン)に変更バーを描画するように自動フォールバック
  (unless (display-graphic-p)
    (diff-hl-margin-mode)))

;; --------------------------------------------------
;; 7-4. git-timemachine: ファイルの過去の姿をパラパラ漫画のように閲覧
;; --------------------------------------------------
(use-package git-timemachine
  :ensure t
  :bind ("C-c g t" . git-timemachine)) ;; C-c g t でタイムトラベル開始


;; --------------------------------------------------
;; 7-5. blamer: VS CodeのGitLens風（行末にコミット履歴を薄く表示）
;; --------------------------------------------------
(use-package blamer
  :ensure t
  ;; 常に表示すると画面がうるさくなるため、必要な時だけON/OFFできるようにする
  :bind (("C-c g b" . blamer-mode))
  ;:config
  ;(set-face-attribute 'blamer-face nil :background 'unspecified)
  :custom
  (blamer-idle-time 0.3)      ;; カーソルが止まってから表示されるまでの秒数
  (blamer-min-offset 70)      ;; テキストからどれくらい離して表示するか
  :custom-face
  ;; ゴーストテキストの色とサイズを控えめに調整（環境に合わせて変更してください）
  (blamer-face ((t :foreground "#7a88cf" :background unspecified :height 0.8 :italic t))))

;; --------------------------------------------------
;; 7-6. smerge-mode: コンフリクト解消を圧倒的に楽にする標準機能
;; --------------------------------------------------
(use-package smerge-mode
  :ensure nil ;; Emacs標準搭載のためインストール不要
  :bind (:map smerge-mode-map
              ("C-c ^ n" . smerge-next)          ;; 次のコンフリクト箇所へ
              ("C-c ^ p" . smerge-prev)          ;; 前のコンフリクト箇所へ
              ("C-c ^ u" . smerge-keep-upper)    ;; 相手(Upper)の変更を採用
              ("C-c ^ l" . smerge-keep-lower)    ;; 自分(Lower)の変更を採用
              ("C-c ^ a" . smerge-keep-all)      ;; 両方(All)の変更を採用
              ("C-c ^ RET" . smerge-keep-current)) ;; カーソルがある方の変更を採用
  ;; Magitからコンフリクトしているファイルを開いた時、自動で有効化する魔法のフック
  :hook (magit-diff-visit-file . (lambda ()
                                   (when (save-excursion
                                           (goto-char (point-min))
                                           (re-search-forward "^<<<<<<< " nil t))
                                     (smerge-mode 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'git-settings)
;;; git-settings.el ends here
