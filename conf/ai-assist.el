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
  :config

  ;; ------------------------------------------
  ;; [基本設定とUX]
  ;; ------------------------------------------
  ;; (オプション) チャットバッファのデフォルトを Org-mode に
  (setq gptel-default-mode 'org-mode)
  ;; 非同期実行のために curl を使用することを明示
  (setq gptel-use-curl t)
  ;; 💡 デフォルトで使うモデルを指定
  (setq gptel-model 'gemma-4)

  ;; ------------------------------------------
  ;; [LLMバックエンド設定 (Llama.cpp)]
  ;; ------------------------------------------
  ;; 💡 ローカルの llama.cpp (Gemma 4用) バックエンドを設定
  (setq gptel-backend
        (gptel-make-openai "Llama.cpp-Gemma"
          :host "127.0.0.1:8083"         ;; Gemma 4用にポート8083を指定
          :protocol "http"
          :endpoint "/v1/chat/completions"
          :stream t                      ;; リアルタイム流し込みオン
          :models '(gemma-4)))           ;; モデル識別名を設定

  ;; ------------------------------------------
  ;; [振る舞い制御 (System Prompt)]
  ;; ------------------------------------------
  ;; gptelのシステムプロンプト（指示）のデフォルトを「自習用ルール」に上書きします
  ;; 自習モード：実装ロジックはスタブ化し、設計ディスカッションに徹する
  (setq gptel-default-directive
        "あなたは優秀な開発アシスタントです。ユーザーの自習と実装スキル向上のため、明示的に『具体的に実装して』と依頼された場合を除き、関数の具体的な内部ロジック（コード）は絶対に書かないでください。日本語の仕様コメントと、中身が空の定義（スタブ）だけを出力し、設計方針のディスカッションに徹してください。")

  ) ;; End use-package

;(use-package gptel
;  :ensure t
;  :pin melpa
;  :bind ("C-c $" . gptel)
;  :init
;  (when (fboundp 'exec-path-from-shell-copy-env)
;    (exec-path-from-shell-copy-env "GEMINI_API_KEY")) ;; 任意の環境変数名に書き換えてください
;  :config
;
;  ;; Gemini 用のバックエンドを設定
;  (setq gptel-backend
;        (gptel-make-gemini "Gemini"
;          :key (getenv "GEMINI_API_KEY") ;; 環境変数からAPI読み込み
;          :stream t))                    ;; 回答をリアルタイムで流し込む設定
;  ;; デフォルトモデルの設定
;  (setq gptel-model 'gemini-2.5-flash-lite) ;;gemini-2.5-flash-lite gemini-2.5-pro gemini-3.1-flash-lite-preview
;  ;; (オプション) チャットバッファのデフォルトを Org-mode に
;  (setq gptel-default-mode 'org-mode)
;  ;; 非同期実行のために curl を使用することを明示
;  (setq gptel-use-curl t)

;  ;; openai形式の接続方法(Geminiを使わない場合)
;  (gptel-make-openai "DeepSeek"
;    :host "api.deepseek.com"
;    :endpoint "/v1/chat/completions"
;    :stream t
;    :key (getenv "DEEPSEEK_API_KEY"))                ;; 任意の環境変数名に書き換えてください

;  ) ;; End use-package

;;; 自作Elisp: llama-cli を呼び出し処理させる

;; =====================================================================
;; 0. 設定項目（お使いの環境に合わせて変更してください）
;; =====================================================================
;; Qwen2.5-Coder-7Bを使う(仮)
;;(defvar *my-llama-model-path* (getenv "LLAMA_CLI_PATH")
;;  "ローカルに配置しているGGUFモデルのフルパス。")

;; =====================================================================
;; 1. 【共通コア関数】非同期プロセスを管理し、出力をコールバック関数へ流す
;; =====================================================================
(defun my-llama-core-engine (prompt target-text callback-func)
  "llama-cliをバックグラウンドで実行。
文字が生成されるたびに (funcall callback-func \"生成されたテキスト\") を実行します。"
  (let ((cli-path (getenv "LLAMA_CLI_PATH"))
        (model-path (getenv "QWEN2_5_CODER_7B")))

    (unless (and cli-path model-path)
      (user-error "エラー: LLAMA_CLI_PATH または LLAMA_MODEL_PATH が環境変数に設定されていません。"))

    (let* (;; 1. 各プロンプトの組み立て
           (sys-msg "You are an expert programmer. Output ONLY the code inside standard markdown blocks, no explanations.")
           (user-msg (format "User Request: %s\n\nTarget Code:\n```\n%s\n```" prompt target-text))

           ;; 2. ChatMLフォーマットに完全準拠させるガッチャンコ処理
           (full-prompt (concat
                         "<|im_start|>system\n" sys-msg "<|im_end|>\n"
                         "<|im_start|>user\n" user-msg "<|im_end|>\n"
                         "<|im_start|>assistant\n")) ; 最後の改行の後からAIが書き始める

           ;; 3. コマンド引数の作成（-sys や --skip-chat-parsing も不要になり超シンプルに！）
           (cmd-args (list cli-path
                           "-m" model-path
                           "-ngl" "99"
                           "--flash-attn" "off"
                           "--temp" "0.2"
                           "-n" "2048"
                           "-c" "2048"
                           "-t" "4"
                           "--skip-chat-parsing"
                           "--log-disable"
                           "--no-display-prompt"
                           "-st"
                           "--no-show-timings"
                           "-p" full-prompt))
           (proc (apply 'start-process "my-llama-process" nil (car cmd-args) (cdr cmd-args))))
    ;; プロセスからデータ（標準出力）が届くたびに動くフィルターをセット
    (set-process-filter
     proc
     (lambda (process output)
       ;; 届いたテキストをそのままコールバック関数に yield（投下）する
       (funcall callback-func output))))))

;; =====================================================================
;; 2. 【個別ラッパー関数】出力先ごとの「戦略」を定義
;; =====================================================================

;; --- パターンA: 選択範囲を直接「置換」 ---
(defun my-llama-replace-region (start end prompt)
  "選択範囲のコードを、AIが生成したコードで直接置き換えます。"
  (interactive "r\ns指示（選択範囲を置換）: ")
  (let ((current-buf (current-buffer))
        (insert-pos start))
    (delete-region start end) ; 先に元のテキストを消去
    (my-llama-core-engine
     prompt
     (buffer-substring-no-properties start end)
     (lambda (text)
       (with-current-buffer current-buf
         (save-excursion
           (goto-char insert-pos)
           (insert text)
           ;; 次に文字が届いたときのために、挿入した末尾の位置を記憶
           (setq insert-pos (point))))))))

;; --- パターンB: 選択範囲の「次の行に挿入」 ---
(defun my-llama-insert-below (start end prompt)
  "選択範囲の下の行に、AIが生成したコードを挿入します。"
  (interactive "r\ns指示（次の行に挿入）: ")
  (let ((current-buf (current-buffer))
        ;; 選択範囲の直後の「行頭」をターゲット位置にする
        (insert-pos (save-excursion (goto-char end) (forward-line 1) (beginning-of-line) (point))))
    (my-llama-core-engine
     prompt
     (buffer-substring-no-properties start end)
     (lambda (text)
       (with-current-buffer current-buf
         (save-excursion
           (goto-char insert-pos)
           (insert text)
           (setq insert-pos (point))))))))

;; --- パターンC: ミニバッファ（画面最下部）に出力 ---
(defun my-llama-display-in-minibuffer (start end prompt)
  "画面を汚さず、エコーエリア（ミニバッファ）に結果をストリーミング表示します。"
  (interactive "r\ns指示（ミニバッファ出力）: ")
  (let ((accumulated-text ""))
    (my-llama-core-engine
     prompt
     (buffer-substring-no-properties start end)
     (lambda (text)
       ;; 届いたテキストを蓄積して画面下に表示
       (setq accumulated-text (concat accumulated-text text))
       (message "%s" accumulated-text)))))

;; --- パターンD: 専用バッファにポップアップ出力 ---
(defun my-llama-popup-buffer (start end prompt)
  "専用の別バッファ「*Llama Assistant*」を開いて結果を出力します。"
  (interactive "r\ns指示（専用バッファ出力）: ")
  (let ((out-buf (get-buffer-create "*Llama Assistant*")))
    ;; バッファの初期化
    (with-current-buffer out-buf
      (read-only-mode -1)
      (erase-buffer)
      (markdown-mode)) ; markdown-modeがあれば適用
    (display-buffer out-buf) ; 画面を割って表示

    (my-llama-core-engine
     prompt
     (buffer-substring-no-properties start end)
     (lambda (text)
       (with-current-buffer out-buf
         (save-excursion
           (goto-char (point-max))
           (insert text)))))))

;; =====================================================================
;; 3. 【キーバインド設定】C-c l を起点とした直感的な割り当て
;; =====================================================================
;;(global-set-key (kbd "C-c a r") 'my-llama-replace-region)       ; [r]eplace
;;(global-set-key (kbd "C-c a i") 'my-llama-insert-below)         ; [i]nsert
;;(global-set-key (kbd "C-c a m") 'my-llama-display-in-minibuffer) ; [m]essage
(global-set-key (kbd "C-c a b") 'my-llama-popup-buffer)         ; [b]uffer

(provide 'ai-assist)
;;; ai-assist.el ends here
