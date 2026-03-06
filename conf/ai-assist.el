;;; ai-assist.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは JVM言語系の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; AI連携(gptel)
;; --------------------------------------------------


(use-package gptel
  :ensure t
  :pin melpa
  :bind ("C-c $" . gptel)
  :init
  (when (fboundp 'exec-path-from-shell-copy-env)
    (exec-path-from-shell-copy-env "GEMINI_API_KEY")) ;; 任意の環境変数名に書き換えてください
  :config

  ;; Gemini 用のバックエンドを設定
  (setq gptel-backend
        (gptel-make-gemini "Gemini"
          :key (getenv "GEMINI_API_KEY") ;; 環境変数からAPI読み込み
          :stream t))                    ;; 回答をリアルタイムで流し込む設定
  ;; デフォルトモデルの設定
  (setq gptel-model 'gemini-2.5-flash-lite) ;;gemini-2.5-flash-lite gemini-2.5-pro gemini-3.1-flash-lite-preview
  ;; (オプション) チャットバッファのデフォルトを Org-mode に
  (setq gptel-default-mode 'org-mode)
  ;; 非同期実行のために curl を使用することを明示
  (setq gptel-use-curl t)

;  ;; openai形式の接続方法(Geminiを使わない場合)
;  (gptel-make-openai "DeepSeek"
;    :host "api.deepseek.com"
;    :endpoint "/v1/chat/completions"
;    :stream t
;    :key (getenv "DEEPSEEK_API_KEY"))                ;; 任意の環境変数名に書き換えてください

  ) ;; End use-package


(provide 'ai-assist)
;;; ai-assist.el ends here
