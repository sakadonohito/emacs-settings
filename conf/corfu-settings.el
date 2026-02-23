;;; corfu-settings.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルはEglotに関する初期設定ファイルです。
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ====================================================================
;; 8-5. Corfuの設定(Corfu + Orderless + Kind-icon + Cape)
;; ====================================================================

;; --------------------------------------------------
;; 8-5-1. Orderless: 柔軟なあいまい検索（スペース区切りで順不同マッチ）
;;        Corfuよりも前に設定
;; --------------------------------------------------
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; --------------------------------------------------
;; 8-5-2. Corfu: 補完UIのコア
;; --------------------------------------------------
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)                 ;; 自動補完を有効化
  (corfu-auto-delay 0.1)         ;; 自動補完の遅延
  (corfu-auto-prefix 1)          ;; 補完を始める文字数
  (corfu-cycle t)                ;; 候補を循環
  (corfu-preselect 'prompt)      ;; プロンプトを事前選択（勝手に1つ目が確定されるのを防ぐ）
  :config
  ;; 補完候補の横にドキュメント（関数の説明など）をポップアップ表示する標準機能
  (corfu-popupinfo-mode)

  ;; ミニバッファではCorfuの自動表示を無効化
  (add-hook 'minibuffer-setup-hook
            (lambda () (setq-local corfu-auto nil))))

;; --------------------------------------------------
;; 8-5-3. Kind-icon: 補完候補にアイコン（VS Code風）を表示
;; --------------------------------------------------
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; Corfuの背景色に自然に馴染ませる
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; --------------------------------------------------
;; 8-5-4. Cape: 補完バックエンドの拡張（LSPと単語履歴などを連携）
;; --------------------------------------------------
(use-package cape
  :ensure t
  :init
  ;; 基本的な補完ソースを追加（上にあるほど優先度が高い）
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; バッファ内の単語履歴
  (add-to-list 'completion-at-point-functions #'cape-file)    ;; ファイルパス
  (add-to-list 'completion-at-point-functions #'cape-keyword) ;; 言語のキーワード
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'corfu-settings)
;;; corfu-settings.el ends here
