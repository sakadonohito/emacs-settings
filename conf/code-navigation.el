;;; code-navigation.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-1 & 8-2. 検索・移動・アクション (Vertico + Consult + Marginalia + Embark)
;; ====================================================================

;; --------------------------------------------------
;; 8-1-1. Vertico: 垂直方向の美しいミニバッファUI
;; --------------------------------------------------
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-count 20)      ;; ivy-height 20 に相当
  (vertico-cycle t)       ;; リストの端から端へループさせる
  )

;; ToDo: このコメントはここであるべきか？もしくは記載内容を変えるべきか？
;; ※ Orderless は Corfu の設定ブロックですでに有効化されているため、
;; Vertico や Consult の検索でも自動的に「スペース区切りのあいまい検索」が機能します！

;; Ivyユーザーが戸惑いがちな「ファイルパス入力時のバックスペース挙動」を
;; Ivyと同じように「ディレクトリ単位で削除」にするための公式拡張
(use-package vertico-directory
  :after vertico
  :ensure nil ;; verticoパッケージに同梱されているため外部インストール不要
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

;; --------------------------------------------------
;; 8-1-2. Marginalia: ミニバッファにリッチな注釈（パーミッションやDocstring）を追加
;; --------------------------------------------------
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; --------------------------------------------------
;; 8-1-3. Consult: 高度な検索・移動コマンド (Counsel/Swiper の完全な代替)
;; --------------------------------------------------
(use-package consult
  :ensure t
  :bind (;; --- Counsel / Swiper からの移行キーバインド ---
         ("C-s" . consult-line)                  ;; swiper の代替
         ("C-x b" . consult-buffer)              ;; ivy-switch-buffer の代替
         ("C-x C-b" . consult-buffer)            ;; 
         ("C-c k" . consult-ripgrep)             ;; counsel-rg の代替
         ("C-c j" . consult-find)                ;; counsel-file-jump の代替

         ;; --- ぜひ使ってほしい Consult の強力な標準コマンド ---
         ("M-y" . consult-yank-pop)              ;; キルリング(クリップボード)履歴の検索
         ("M-g g" . consult-goto-line)           ;; プレビュー付きの行ジャンプ
         ("M-g o" . consult-outline)             ;; ファイル内の見出し(関数名など)を検索
         ("M-g i" . consult-imenu))              ;; 現在のバッファの関数/変数一覧
  :custom
  ;; 検索結果を絞り込むためのプレフィックスキー (例: b SPC でバッファのみに絞り込み)
  (consult-narrow-key "<")
  :config
  ;; xrefのUIをConsultに変更 (ivy-xrefの完全な代替)
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

;; --------------------------------------------------
;; 8-1-4. Embark: 候補に対するアクション（右クリックメニューのような機能）
;; --------------------------------------------------
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)         ;; 選択中の候補に対してアクションを実行
         ("C-c b" . embark-bindings)) ;; 現在使えるキーバインド一覧を検索
  :init
  ;; アクションメニューを画面下部に表示する設定
  (setq prefix-help-command #'embark-prefix-help-command))

;; --------------------------------------------------
;; 8-1-5. Embark-Consult: Embark と Consult の連携
;; --------------------------------------------------
(use-package embark-consult
  :ensure t
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'code-navigation)
;;; code-navigation.el ends here
