;;; package --- Summary
;;; Commentary:
;; 起動時にinit.elを読み込む前に行うこと
;;; Code:

;; 1. 起動時のみGCの閾値を100MB程度に引き上げる
(setq gc-cons-threshold (* 100 1024 1024))
;; 起動完了後にGC閾値を元に戻す設定（これは init.el の最後で行う）


;; 2. ここに配置：Native Compの警告を抑制
;; これを早い段階で書くことで、起動中の不要なポップアップを防ぐ
(setq native-comp-async-report-warnings-errors 'silent)


;; 3. フレーム作成前にUIを無効化してチラつきを防止
(setq inhibit-startup-message t)                   ;; 起動時の画面はいらない
(setq inhibit-startup-echo-area-message (user-login-name))

;; ウィンドウサイズなど見た目の先行確定
(setq default-frame-alist
      '((menu-bar-lines . 0)             ;; メニューバー消す
        (tool-bar-lines . 0)             ;; ツールバー消す
        (vertical-scroll-bars . nil)     ;; 縦のスクロールバー消す
        (width . 100)                    ;; 幅100文字
        (height . 40)                    ;; 高さ40行
        (alpha . 80)                     ;; 全体を透過に※CUIはターミナル依存
        ;(alpha-background . 70)          ;; 私の環境ではこっちの設定が使えない！
        (font . "UDEV Gothic 35NF-20")   ;; フォントを「UDEV Gothic 35NF」に、サイズを200ptに
        (internal-border-width . 0)))    ;; ウィンドウの外枠とテキスト領域の間にある余白をゼロにする

;; 4. 日本語環境を最優先で確定
(set-language-environment "Japanese")         ;; 言語環境を日本語に設定
(prefer-coding-system 'utf-8)                 ;; デフォルト文字コードをUTF-8に設定

;(provide 'early-init) ;; この記述は不要のはず
;;; early-init.el ends here
