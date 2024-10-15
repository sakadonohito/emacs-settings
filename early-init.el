;;; package --- Summary
;;; Commentary:
;; 起動時にinit.elを読み込む前に行うこと
;;; Code:

;; straight.elを使用しているので、競合しないようpackage.elがうごかないようにしている
(setq package-enable-at-startup nil)
;(setq package--init-file-ensured t)


(provide 'early-init)
;;; early-init.el ends here
