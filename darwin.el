(setq default-frame-alist
      '((width . 120) (height . 60)))

;; Exec this line to insert the current font as a setting:
;; (insert "\n(set-default-font \"" (cdr (assoc 'font (frame-parameters))) "\")")
(set-default-font "-apple-Menlo-medium-normal-normal-*-12-*-*-*-m-0-iso10646-1")

;(set-face-attribute 'my-buffer-face-mode-face nil :family "Terminus" :height 120)

(setq exec-path (append exec-path (list "/usr/local/bin"
                                        "/usr/local/git/bin"
                                        "/usr/X11/bin"
                                        "/opt/local/bin")))

(setq-default save-interprogram-paste-before-kill nil
              select-active-regions nil
              my-set-cursor-color-read-only-color "yellow3"
              my-set-cursor-color-normal-color "green3")

(grep-apply-setting 'grep-template "grep -nH -d skip -I -E -e <R> <C> <F>")
(grep-apply-setting 'grep-find-template "find <D> <X> -type f <F> -print0 | xargs -0 grep -nH -I -E -e <R> <C>")

;; Theme

(white)

(setq-default org-priority-faces '((?A . (:foreground "IndianRed3"))
                                   (?B . (:foreground "SteelBlue3"))
                                   (?C . (:foreground "SpringGreen3")))
              org-todo-keyword-faces '(("TODO"       . (:foreground "Red3"))
                                       ("STARTED"    . (:foreground "Blue"))
                                       ("WAITING"    . (:foreground "Orange3"))
                                       ("DONE"       . (:foreground "Green4"))
                                       ("MAYBE"      . (:foreground "Cyan4"))
                                       ("SOMEDAY"    . (:foreground "Cyan4"))
                                       ("CANCELED"   . (:foreground "Green4"))
                                       ("REASSIGNED" . (:foreground "Green4"))))
(eval-after-load "org"
  '(progn
     (set-face-foreground 'org-tag "RoyalBlue1")
     (set-face-foreground 'org-checkbox-statistics-todo "HotPink4")
     (set-face-foreground 'org-checkbox-statistics-done "Green4")
     (set-face-foreground 'org-special-keyword "DarkOrange4")
     (set-face-foreground 'org-date "DeepSkyBlue4")
     (set-face-foreground 'org-document-title "gold4")))
