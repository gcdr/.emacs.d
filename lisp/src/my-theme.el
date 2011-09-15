;;; my-theme.el

(setq custom-theme-directory "~/.emacs.d/themes")

(load-theme 'deeper-blue)
(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'deeper-blue
   `(custom-face-tag ((,class (:family "helv" :weight bold :height 1.2))))
   `(highlight-changes ((,class (:background "SteelBlue4" :foreground "white"))))
   `(highlight-changes-delete ((,class (:background "firebrick"))))
   `(magit-diff-add ((,class (:foreground "SeaGreen2"))))
   `(magit-diff-del ((,class (:foreground "red"))))
   `(magit-item-highlight ((,class (:background "gray25"))))
   `(magit-section-title ((,class (:inherit font-lock-keyword-face))))
   `(my-tab-face ((,class (:background "pink4"))))
   `(my-todo-face ((,class (:weight bold :box t :foreground "firebrick2" :background "yellow"))) t)
   `(my-trailing-space-face ((,class (:background "steelblue4"))))
   `(org-document-title ((,class (:height 1.44))))
   `(org-hide ((,class (:foreground "#181a26"))))
   `(org-table ((,class (:foreground "darkseagreen2"))))
   `(org-tag ((,class (:foreground "salmon"))))
   `(org-tag ((,class (:weight bold))))
   `(org-todo ((,class (:foreground "plum2"))))
   `(speedbar-button-face ((,class (:foreground nil :inherit font-lock-constant-face))))
   `(speedbar-directory-face ((,class (:foreground nil :inherit dired-directory))))
   `(speedbar-file-face ((,class (:foreground nil :inherit default))))
   `(speedbar-tag-face ((,class (:foreground nil :inherit font-lock-reference-face))))
   `(task-bmk-face ((,class (:background "#404040"))))
   `(widget-button-face ((,class (:weight bold))))
   `(widget-button-pressed-face ((,class (:foreground "red"))))
   `(widget-documentation-face ((,class (:foreground "lime green"))))
   `(widget-field-face ((,class (:background "dim gray"))))
   `(widget-inactive-face ((,class (:foreground "light gray"))))
   `(widget-single-line-field-face ((,class (:background "dim gray"))))))

(defalias 'blue (lambda () (interactive) (set-background-color "#181a26")))
(defalias 'red (lambda () (interactive) (set-background-color "#261a18")))
(defalias 'green (lambda () (interactive) (set-background-color "#18261a")))

;; (my-theme-create
;;  whiteboard
;;  '(
;;    (compilation-column-number ((t (:foreground "DarkGreen"))))
;;    (compilation-error ((t (:foreground "Red1"))))
;;    (compilation-info ((t (:weight normal :foreground "DeepSkyBlue4"))))
;;    (compilation-line-number ((t (:foreground "DarkGreen"))))
;;    (compilation-warning ((t (:foreground "Yellow4"))))
;;    (cperl-array-face ((t (:foreground "yellow2"))))
;;    (cperl-hash-face ((t (:foreground "coral1"))))
;;    (cursor ((t (:background "Green3" :foreground "gainsboro"))))
;;    (default ((t (:background "whitesmoke" :foreground "black"))))
;;    (diff-context ((t (:foreground "seashell4"))))
;;    (diff-file-header ((t (:background "grey60"))))
;;    (diff-header ((t (:background "grey45"))))
;;    (diff-indicator-added ((t (:foreground "white" :background "darkolivegreen"))))
;;    (diff-indicator-changed ((t (:foreground "white" :background "dodgerblue4"))))
;;    (diff-indicator-removed ((t (:foreground "white" :background "indianred4"))))
;;    (diff-refine-change ((t (:background "skyblue4"))))
;;    (dired-marked ((t (:background "dodgerblue3" :foreground "white"))))
;;    (escape-glyph ((t (:foreground "red"))))
;;    (font-lock-builtin-face ((t (:foreground "OrangeRed"))))
;;    (font-lock-comment-delimiter-face ((t (:foreground "gray50"))))
;;    (font-lock-comment-face ((t (:foreground "gray50"))))
;;    (font-lock-constant-face ((t (:foreground "DarkOliveGreen4"))))
;;    (font-lock-doc-face ((t (:foreground "peru"))))
;;    (font-lock-doc-string-face ((t (:foreground "peru"))))
;;    (font-lock-function-name-face ((t (:foreground "goldenrod3"))))
;;    (font-lock-keyword-face ((t (:foreground "DodgerBlue2"))))
;;    (font-lock-preprocessor-face ((t (:foreground "gold3"))))
;;    (font-lock-reference-face ((t (:foreground "salmon"))))
;;    (font-lock-string-face ((t (:foreground "burlywood4"))))
;;    (font-lock-type-face ((t (:foreground "DeepSkyBlue4"))))
;;    (font-lock-variable-name-face ((t (:foreground "SeaGreen4"))))
;;    (font-lock-warning-face ((t (:foreground "red"))))
;;    (flymake-warnline ((t (:background nil :underline "magenta3"))))
;;    (flymake-errline ((t (:background nil :underline "red"))))
;;    (fringe ((t (:background "gainsboro"))))
;;    (highlight ((t (:background "SkyBlue1"))))
;;    (highlight-changes ((t (:background "SteelBlue4" :foreground "white"))))
;;    (highlight-changes-delete ((t (:background "firebrick"))))
;;    (ido-first-match ((t (:weight normal :foreground "DarkOrange3"))))
;;    (ido-only-match ((t (:foreground "SeaGreen4"))))
;;    (info-header-node ((t (:foreground "DeepSkyBlue1"))))
;;    (info-header-xref ((t (:foreground "SeaGreen2"))))
;;    (info-menu-5 ((t (:foreground "wheat"))))
;;    (info-node ((t (:foreground "DeepSkyBlue1"))))
;;    (info-xref ((t (:foreground "SeaGreen4"))))
;;    (isearch ((t (:background "coral2" :foreground "white"))))
;;    (isearch-lazy-highlight-face ((t (:background "coral4" :foreground "white"))))
;;    (lazy-highlight ((t (:background "cadetblue" :foreground "white"))))
;;    (magit-item-highlight ((t (:background "gray80"))))
;;    (magit-diff-add ((t (:foreground "darkgreen"))))
;;    (match ((t (:background "LightPink1"))))
;;    (minibuffer-prompt ((t (:foreground "DodgerBlue4"))))
;;    (my-org-new-face ((t (:foreground "whitesmoke" :background "DodgerBlue2"))))
;;    (my-tab-face ((t (:background "MistyRose"))))
;;    (my-trailing-space-face ((t (:background "lemonchiffon2"))))
;;    (org-document-title ((t (:foreground "ForestGreen" :height 1.44))))
;;    (org-hide ((t (:foreground "whitesmoke"))))
;;    (org-table ((t (:foreground "forestgreen"))))
;;    (org-tag ((t (:foreground "firebrick3"))))
;;    (org-todo ((t (:foreground "plum2"))))
;;    (outline-1 ((t (:foreground "Blue3"))))
;;    (outline-2 ((t (:foreground "DodgerBlue"))))
;;    (outline-3 ((t (:foreground "SteelBlue"))))
;;    (outline-4 ((t (:foreground "RoyalBlue"))))
;;    (outline-5 ((t (:foreground "DeepSkyBlue"))))
;;    (primary-selection ((t (:background "blue3"))))
;;    (region ((t (:background "SkyBlue1"))))
;;    (secondary-selection ((t (:background "yellow" :foreground "gray10"))))
;;    (show-paren-match-face ((t (:background "dodgerblue1" :foreground "white"))))
;;    (show-paren-mismatch-face ((t (:background "red1" :foreground "white"))))
;;    (task-bmk-face ((t (:background "gray85"))))
;;    (tooltip ((t (:background "lightyellow" :foreground "black"))))
;;    (trailing-whitespace ((t (:background "#181a26"))))
;;    (widget-button-pressed-face ((t (:foreground "red"))))
;;    (widget-documentation-face ((t (:foreground "lime green"))))
;;    (widget-field-face ((t (:background "dim gray"))))
;;    (widget-inactive-face ((t (:foreground "light gray"))))
;;    (widget-single-line-field-face ((t (:background "dim gray"))))))

(provide 'my-theme)
