;;; jvm.el --- Emacs initialization file -*- lexical-binding: t; -*-
;;; Commentary:
;; このファイルは JVM言語系の設定ファイルです
;; 必要なパッケージのロードやカスタム設定が行われます。
;;; Code:

;; --------------------------------------------------
;; 1. Java (Standard & Modern)
;; --------------------------------------------------
(use-package java-ts-mode
  :ensure nil
  :mode "\\.java\\'"
  :hook (java-ts-mode . eglot-ensure)  ;; LSPサーバーを有効化
  :custom
  ;(c-basic-offset 4)                ;; インデント幅を4に設定
  ;(tab-width 4)                     ;; タブ幅を4に設定
  ;(indent-tabs-mode nil)            ;; タブをスペースに変換
  (java-ts-mode-indent-offset 4)     ;; インデント幅を4に設定
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((java-mode java-ts-mode) . ("jdtls")))))

;; Java補助: JUnitなどのテスト実行を便利にする
(use-package meghanada
  :ensure t
  :defer t
  :init
  (add-hook 'java-mode-hook 'meghanada-mode))

;; --------------------------------------------------
;; 2. Kotlin (Treesitter & LSP)
;; --------------------------------------------------
(use-package kotlin-ts-mode
  :ensure t
  :mode "\\.kt\\'"
  :hook (kotlin-ts-mode . eglot-ensure) ;; LSPサーバーを有効化
  :custom
  ;(kotlin-tab-width 4)                 ;; こっちの設定は古い？不要？
  (kotlin-ts-mode-indent-offset 4)     ;; インデント幅を4に設定
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((kotlin-mode kotlin-ts-mode) . ("kotlin-language-server")))))

;; --------------------------------------------------
;; 3. Clojure (Lisp-friendly)
;; --------------------------------------------------
;; clojure-ts-modeが存在するが今はまだ採用しない
(use-package clojure-mode
  :ensure t
  :hook ((clojure-mode . eglot-ensure)  ;; LSPサーバーを有効化
         (clojure-mode . paredit-mode)) ;; Lisp系にはPareditが必須級
  :custom
  (clojure-indent-style :always-align) ;; インデントスタイルを指定
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((clojure-mode clojurescript-mode clojurec-mode clojure-ts-mode) . ("clojure-lsp")))))

;; Clojure補助: 強力なREPL環境
(use-package cider
  :ensure t
  :defer t)

;; --------------------------------------------------
;; 4. Scala (Metals integration)
;; --------------------------------------------------
;; scala-ts-modeは無いもしくは不安定。現状scala-modeで十分
(use-package scala-mode
  :ensure t
  :interpreter ("scala" . scala-mode)
  :hook (scala-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((scala-mode) . ("metals")))))

;; インデント指定は？

;; Scala補助: sbt連携
(use-package sbt-mode
  :ensure t
  :commands sbt-start sbt-command
  :config
  ;; コンパイルバッファで色を有効にする
  (setq sbt:program-name "sbt"))

;; --------------------------------------------------
;; 5. Groovy (Build Tool & Test focused)
;; --------------------------------------------------
;; groovy-ts-modeは存在しない
(use-package groovy-mode
  :ensure t
  :mode ("\\.groovy\\'" "\\.gradle\\'" "Jenkinsfile\\'")
  :hook (groovy-mode . eglot-ensure)
  :custom
  (groovy-indent-offset 4)
  :config
  (let (
        (groovy-lsp-jar (expand-file-name "servers/groovy-language-server-all.jar" user-emacs-directory))
        (java-home "/usr/local/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"))
    (with-eval-after-load 'eglot
      (add-to-list 'eglot-server-programs
                   ;; ここは文法的にバッククォートで合ってるんやで
                   `(groovy-mode . ("java"
                                    ,(concat "-Djava.home=" java-home)
                                    "-jar" ,groovy-lsp-jar))))
    ) ;; End let
  ) ;; End use-package

;; --------------------------------------------------
;; 6. 補助・共通便利パッケージ (JVM全般)
;; --------------------------------------------------

;; プロジェクト管理 (gradle/mavenプロジェクトの認識に必須)
(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map ("C-c p" . projectile-command-map)))

;;; テスト実行の可視化
;(use-package quicktest
;  :ensure t
;  :bind ("C-c t" . quicktest-run))

;; Rest Client (Java/KotlinでのAPI開発時に便利)
(use-package restclient
  :ensure t
  :mode ("\\.http\\'" . restclient-mode))

(provide 'jvm)
;;; jvm.el ends here
