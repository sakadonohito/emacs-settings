;;; init-jvm.el --- Emacs initialization file
;;; Commentary:
;; このファイルは JVM言語系の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; Javaの設定
(leaf java-mode
  :hook (java-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((c-basic-offset . 4)   ;; インデント幅を4に設定
           (tab-width . 4)        ;; タブ幅を4に設定
           (indent-tabs-mode . nil))  ;; タブをスペースに変換
  :config
  ;; 必要に応じてJava固有の設定をここに記述できます
  )

;; Kotlinの設定
(leaf kotlin-mode
  :ensure t
  :hook (kotlin-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((kotlin-tab-width . 4))  ;; インデント幅を4に設定
  :config
  ;; 必要に応じてKotlin固有の設定をここに記述できます
  )

;; Clojureの設定
(leaf clojure-mode
  :ensure t
  :hook (clojure-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom ((clojure-indent-style . :always-align))  ;; インデントスタイルを指定
  :config
  ;; 必要に応じてClojure固有の設定をここに記述できます
  )

(provide 'init-jvm)
;;; init-jvm.el ends here
