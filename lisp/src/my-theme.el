;;; my-theme.el

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions

(defmacro my-theme-create (name face-specs)
  `(defun ,(intern (concat "my-theme-" (symbol-name name))) ()
     (interactive)
     (my-theme-install ,face-specs)))

(defun my-theme-install (face-specs)
  "Install faces."
  (my-theme-add-face-specs my-theme-common-face-specs t)
  (my-theme-add-face-specs face-specs))

(defun my-theme-add-face-specs (face-specs &optional reset)
  "Add face specs."
  (let (face spec)
    (dolist (face-spec face-specs)
      (setq face (car face-spec)
            spec (nth 1 face-spec))
      (unless (facep face)
        (make-face face))
      (when reset
        (face-spec-reset-face face))
      (face-spec-set face spec))))

;; TODO
(defun my-theme-dump-faces ()
  (interactive)
  (let ((attrs '((:width . "width")
                 (:height . "height")
                 (:weight . "weight")
                 (:slant . "slant")
                 (:foreground . "foreground")
                 (:background . "background")
                 (:underline . "underline")
                 (:overline . "overline")
                 (:strike-through . "strike-through")
                 (:box . "box")
                 (:inverse-video . "inverse-video")
                 (:stipple . "stipple")
                 (:inherit . "inherit")))
        num-attrs)
    (with-temp-buffer
      (dolist (face (face-list))
        (setq num-attrs 0)
        (insert " '(" (symbol-name face) " ((t (")
        (dolist (a attrs)
          (let ((attr (face-attribute face (car a))))
            (unless (eq attr 'unspecified)
              (setq num-attrs (1+ num-attrs))
              (cond ((member (car a) '(:foreground :background))
                     (insert ":" (cdr a) (format " \"%s\" " attr)))
                    ((equal (car a) :box)
                     (when attr
                       (insert ":" (cdr a) (format " '%s " attr))))
                    (t
                     (insert ":" (cdr a) (format " %s " attr)))))))
        (if (> num-attrs 0)
            (progn
              (delete-char -1)
              (insert "))))\n"))
          (beginning-of-line)
          (kill-line)))
      (sort-lines nil (point-min) (point-max))
      (goto-char (point-min))
      (insert "(custom-set-faces\n")
      (goto-char (point-max))
      (insert " )\n")
      (write-file "~/.emacs.d/custom-faces.el"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Themes

(defvar my-theme-common-face-specs
  '(
    (Info-title-1-face ((t (:family "helv" :weight bold :height 1.728))))
    (Info-title-2-face ((t (:family "helv" :weight bold :height 1.44))))
    (Info-title-3-face ((t (:family "helv" :weight bold :height 1.2))))
    (Info-title-4-face ((t (:family "helv" :weight bold))))
    (bold ((t (:weight bold))))
    (bold-italic ((t (:slant italic :weight bold))))
    (border ((t (:background "black"))))
    (compilation-error ((t (:weight bold))))
    (compilation-warning ((t (:weight bold))))
    (custom-face-tag ((t (:family "helv" :weight bold :height 1.2))))
    (default ((t (:stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 101 :width normal))))
    (diff-added ((t (nil))))
    (diff-changed ((t (nil))))
    (diff-function ((t (:inherit diff-header))))
    (diff-hunk-header ((t (:inherit diff-header))))
    (diff-index ((t (:inherit diff-file-header))))
    (diff-removed ((t (nil))))
    (font-lock-comment-delimiter-face ((t (:slant italic))))
    (font-lock-comment-face ((t (:slant italic))))
    (font-lock-regexp-grouping-backslash ((t (:weight bold))))
    (font-lock-regexp-grouping-construct ((t (:weight bold))))
    (ido-subdir ((t (:foreground nil :inherit font-lock-keyword-face))))
    (info-header-xref ((t (:weight bold))))
    (info-menu-header ((t (:family "helv" :weight bold))))
    (info-xref ((t (:weight bold))))
    (italic ((t (:slant italic))))
    (magit-section-title ((t (:inherit font-lock-keyword-face))))
    (menu ((t (:background "gray" :foreground "black" :family "helv"))))
    (mode-line ((t (:background "gray75" :foreground "black" :box (:line-width 1 :style released-button)))))
    (mode-line-buffer-id ((t (:weight bold :background nil :foreground "blue4"))))
    (mode-line-inactive ((t (:background "gray33" :foreground "black" :box (:line-width 1 :color "gray33" :style nil)))))
    (my-todo-face ((t (:weight bold :box t :foreground "firebrick2" :background "yellow"))) t)
    (org-tag ((t (:weight bold))))
    (speedbar-button-face ((t (:foreground nil :inherit font-lock-constant-face))))
    (speedbar-file-face ((t (:foreground nil :inherit default))))
    (speedbar-directory-face ((t (:foreground nil :inherit dired-directory))))
    (speedbar-tag-face ((t (:foreground nil :inherit font-lock-reference-face))))
    (underline ((t (:underline t))))
    (variable-pitch ((t (:family "helv"))))
    (widget-button-face ((t (:weight bold))))
    )
  "*Common face specs used by all themes.")

(my-theme-create
 deeper-blue
 '(
   (compilation-column-number ((t (:foreground "LightGreen"))))
   (compilation-error ((t (:foreground "Red1"))))
   (compilation-info ((t (:weight normal :foreground "LightSkyBlue"))))
   (compilation-line-number ((t (:foreground "LightGreen"))))
   (compilation-warning ((t (:foreground "Yellow"))))
   (cperl-array-face ((t (:foreground "yellow2"))))
   (cperl-hash-face ((t (:foreground "coral1"))))
   (cursor ((t (:background "green" :foreground "black"))))
   (default ((t (:background "#181a26" :foreground "gainsboro"))))
   (diff-context ((t (:foreground "seashell4"))))
   (diff-file-header ((t (:background "grey60"))))
   (diff-header ((t (:background "grey45"))))
   (diff-indicator-added ((t (:foreground "white" :background "darkolivegreen"))))
   (diff-indicator-changed ((t (:foreground "white" :background "dodgerblue4"))))
   (diff-indicator-removed ((t (:foreground "white" :background "indianred4"))))
   (diff-refine-change ((t (:background "skyblue4"))))
   (dired-marked ((t (:background "dodgerblue3" :foreground "white"))))
   (escape-glyph ((t (:foreground "red"))))
   (font-lock-builtin-face ((t (:foreground "LightCoral"))))
   (font-lock-comment-delimiter-face ((t (:foreground "gray50"))))
   (font-lock-comment-face ((t (:foreground "gray50"))))
   (font-lock-constant-face ((t (:foreground "DarkOliveGreen3"))))
   (font-lock-doc-face ((t (:foreground "moccasin"))))
   (font-lock-doc-string-face ((t (:foreground "moccasin"))))
   (font-lock-function-name-face ((t (:foreground "goldenrod"))))
   (font-lock-keyword-face ((t (:foreground "DeepSkyBlue1"))))
   (font-lock-preprocessor-face ((t (:foreground "gold"))))
   (font-lock-reference-face ((t (:foreground "LightCoral"))))
   (font-lock-string-face ((t (:foreground "burlywood"))))
   (font-lock-type-face ((t (:foreground "CadetBlue1"))))
   (font-lock-variable-name-face ((t (:foreground "SeaGreen2"))))
   (font-lock-warning-face ((t (:foreground "red"))))
   (fringe ((t (:background "black"))))
   (highlight ((t (:background "DodgerBlue4"))))
   (highlight-changes ((t (:background "SteelBlue4" :foreground "white"))))
   (highlight-changes-delete ((t (:background "firebrick"))))
   (ido-first-match ((t (:weight normal :foreground "orange"))))
   (ido-only-match ((t (:foreground "green"))))
   (info-header-node ((t (:foreground "DeepSkyBlue1"))))
   (info-header-xref ((t (:foreground "SeaGreen2"))))
   (info-menu-5 ((t (:foreground "wheat"))))
   (info-node ((t (:foreground "DeepSkyBlue1"))))
   (info-xref ((t (:foreground "SeaGreen2"))))
   (isearch ((t (:background "coral2" :foreground "white"))))
   (isearch-lazy-highlight-face ((t (:background "coral4" :foreground "white"))))
   (lazy-highlight ((t (:background "cadetblue" :foreground "white"))))
   (magit-diff-add ((t (:foreground "SeaGreen2"))))
   (magit-diff-del ((t (:foreground "red"))))
   (magit-item-highlight ((t (:background "gray25"))))
   (match ((t (:background "DeepPink4"))))
   (minibuffer-prompt ((t (:foreground "CadetBlue1"))))
   (my-tab-face ((t (:background "pink4"))))
   (my-trailing-space-face ((t (:background "steelblue4"))))
   (org-hide ((t (:foreground "#181a26"))))
   (org-tag ((t (:foreground "salmon"))))
   (org-todo ((t (:foreground "plum2"))))
   (outline-1 ((t (:foreground "SkyBlue1"))))
   (outline-2 ((t (:foreground "CadetBlue1"))))
   (outline-3 ((t (:foreground "LightSteelBlue1"))))
   (outline-4 ((t (:foreground "turquoise2"))))
   (outline-5 ((t (:foreground "aquamarine1"))))
   (primary-selection ((t (:background "blue3"))))
   (region ((t (:background "#103050"))))
   (secondary-selection ((t (:background "yellow" :foreground "gray10"))))
   (show-paren-match-face ((t (:background "dodgerblue1" :foreground "white"))))
   (show-paren-mismatch-face ((t (:background "red1" :foreground "white"))))
   (task-bmk-face ((t (:background "#203060"))))
   (tooltip ((t (:background "lightyellow" :foreground "black"))))
   (trailing-whitespace ((t (:background "#181a26"))))
   (widget-button-pressed-face ((t (:foreground "red"))))
   (widget-documentation-face ((t (:foreground "lime green"))))
   (widget-field-face ((t (:background "dim gray"))))
   (widget-inactive-face ((t (:foreground "light gray"))))
   (widget-single-line-field-face ((t (:background "dim gray"))))
   ))

(my-theme-create deeper-red '((default ((t (:background "#261a18" :foreground "gainsboro"))))))

(my-theme-create
 whiteboard
 '(
   (compilation-column-number ((t (:foreground "DarkGreen"))))
   (compilation-error ((t (:foreground "Red1"))))
   (compilation-info ((t (:weight normal :foreground "DeepSkyBlue4"))))
   (compilation-line-number ((t (:foreground "DarkGreen"))))
   (compilation-warning ((t (:foreground "Yellow4"))))
   (cperl-array-face ((t (:foreground "yellow2"))))
   (cperl-hash-face ((t (:foreground "coral1"))))
   (cursor ((t (:background "Green3" :foreground "gainsboro"))))
   (default ((t (:background "whitesmoke" :foreground "black"))))
   (diff-context ((t (:foreground "seashell4"))))
   (diff-file-header ((t (:background "grey60"))))
   (diff-header ((t (:background "grey45"))))
   (diff-indicator-added ((t (:foreground "white" :background "darkolivegreen"))))
   (diff-indicator-changed ((t (:foreground "white" :background "dodgerblue4"))))
   (diff-indicator-removed ((t (:foreground "white" :background "indianred4"))))
   (diff-refine-change ((t (:background "skyblue4"))))
   (dired-marked ((t (:background "dodgerblue3" :foreground "white"))))
   (escape-glyph ((t (:foreground "red"))))
   (font-lock-builtin-face ((t (:foreground "OrangeRed"))))
   (font-lock-comment-delimiter-face ((t (:foreground "gray50"))))
   (font-lock-comment-face ((t (:foreground "gray50"))))
   (font-lock-constant-face ((t (:foreground "DarkOliveGreen4"))))
   (font-lock-doc-face ((t (:foreground "peru"))))
   (font-lock-doc-string-face ((t (:foreground "peru"))))
   (font-lock-function-name-face ((t (:foreground "goldenrod3"))))
   (font-lock-keyword-face ((t (:foreground "DodgerBlue2"))))
   (font-lock-preprocessor-face ((t (:foreground "gold3"))))
   (font-lock-reference-face ((t (:foreground "salmon"))))
   (font-lock-string-face ((t (:foreground "burlywood4"))))
   (font-lock-type-face ((t (:foreground "DeepSkyBlue4"))))
   (font-lock-variable-name-face ((t (:foreground "SeaGreen4"))))
   (font-lock-warning-face ((t (:foreground "red"))))
   (fringe ((t (:background "gainsboro"))))
   (highlight ((t (:background "SkyBlue1"))))
   (highlight-changes ((t (:background "SteelBlue4" :foreground "white"))))
   (highlight-changes-delete ((t (:background "firebrick"))))
   (ido-first-match ((t (:weight normal :foreground "DarkOrange3"))))
   (ido-only-match ((t (:foreground "SeaGreen4"))))
   (info-header-node ((t (:foreground "DeepSkyBlue1"))))
   (info-header-xref ((t (:foreground "SeaGreen2"))))
   (info-menu-5 ((t (:foreground "wheat"))))
   (info-node ((t (:foreground "DeepSkyBlue1"))))
   (info-xref ((t (:foreground "SeaGreen4"))))
   (isearch ((t (:background "coral2" :foreground "white"))))
   (isearch-lazy-highlight-face ((t (:background "coral4" :foreground "white"))))
   (lazy-highlight ((t (:background "cadetblue" :foreground "white"))))
   (magit-item-highlight ((t (:background "gray80"))))
   (magit-diff-add ((t (:foreground "darkgreen"))))
   (match ((t (:background "LightPink1"))))
   (minibuffer-prompt ((t (:foreground "DodgerBlue4"))))
   (my-tab-face ((t (:background "MistyRose"))))
   (my-trailing-space-face ((t (:background "lemonchiffon2"))))
   (org-document-title ((t (:foreground "ForestGreen"))))
   (org-hide ((t (:foreground "whitesmoke"))))
   (org-tag ((t (:foreground "firebrick3"))))
   (org-todo ((t (:foreground "plum2"))))
   (outline-1 ((t (:foreground "Blue3"))))
   (outline-2 ((t (:foreground "DodgerBlue"))))
   (outline-3 ((t (:foreground "SteelBlue"))))
   (outline-4 ((t (:foreground "RoyalBlue"))))
   (outline-5 ((t (:foreground "DeepSkyBlue"))))
   (primary-selection ((t (:background "blue3"))))
   (region ((t (:background "SkyBlue1"))))
   (secondary-selection ((t (:background "yellow" :foreground "gray10"))))
   (show-paren-match-face ((t (:background "dodgerblue1" :foreground "white"))))
   (show-paren-mismatch-face ((t (:background "red1" :foreground "white"))))
   (task-bmk-face ((t (:background "SlateGray2"))))
   (tooltip ((t (:background "lightyellow" :foreground "black"))))
   (trailing-whitespace ((t (:background "#181a26"))))
   (widget-button-pressed-face ((t (:foreground "red"))))
   (widget-documentation-face ((t (:foreground "lime green"))))
   (widget-field-face ((t (:background "dim gray"))))
   (widget-inactive-face ((t (:foreground "light gray"))))
   (widget-single-line-field-face ((t (:background "dim gray"))))

;;    (compilation-column-number ((t (:foreground "medium sea green"))))
;;    (compilation-error ((t (:foreground "Red1"))))
;;    (compilation-info ((t (:weight normal :foreground "Green3"))))
;;    (compilation-line-number ((t (:foreground "purple3"))))
;;    (compilation-warning ((t (:foreground "Orange"))))
;;    (cperl-array-face ((t (:background "lightyellow2" :foreground "Blue"))))
;;    (cperl-hash-face ((t (:background "lightyellow2" :foreground "Red"))))
;;    (cursor ((t (:background "blue" :foreground "white"))))
;;    (default ((t (:background "gainsboro" :foreground "black"))))
;;    (dired-marked ((t (:background "dodgerblue3" :foreground "white"))))
;;    (escape-glyph ((t (:foreground "brown"))))
;;    (font-lock-builtin-face ((t (:foreground "Orchid"))))
;;    (font-lock-comment-delimiter-face ((t (:foreground "gray50"))))
;;    (font-lock-comment-face ((t (:foreground "gray50"))))
;;    (font-lock-constant-face ((t (:foreground "deepskyblue"))))
;;    (font-lock-doc-face ((t (:foreground "darkcyan"))))
;;    (font-lock-function-name-face ((t (:foreground "brown"))))
;;    (font-lock-keyword-face ((t (:foreground "blue"))))
;;    (font-lock-preprocessor-face ((t (:foreground "yellow3"))))
;;    (font-lock-string-face ((t (:foreground "darkcyan"))))
;;    (font-lock-type-face ((t (:foreground "medium sea green"))))
;;    (font-lock-variable-name-face ((t (:foreground "purple3"))))
;;    (font-lock-warning-face ((t (:foreground "Red1"))))
;;    (fringe ((t (:background "gainsboro"))))
;;    (highlight ((t (:background "darkseagreen2"))))
;;    (info-header-node ((t (:foreground "brown"))))
;;    (info-header-xref ((t (:foreground "blue1" :underline t))))
;;    (info-node ((t (:foreground "brown" :slant italic))))
;;    (info-xref ((t (:foreground "blue1"))))
;;    (isearch ((t (:background "orange" :foreground "black"))))
;;    (lazy-highlight ((t (:background "cyan" :foreground "black"))))
;;    (match ((t (:background "tan"))))
;;    (minibuffer-prompt ((t (:foreground "medium blue"))))
;;    (my-tab-face ((t (:background "seashell"))))
;;    (my-trailing-space-face ((t (:background "lemonchiffon"))))
;;    (org-hide ((t (:foreground "whitesmoke"))))
;;    (org-tag ((t (:weight bold :foreground "salmon"))))
;;    (org-todo ((t (:foreground "plum2"))))
;;    (region ((t (:background "lightsteelblue1"))))
;;    (secondary-selection ((t (:background "yellow1"))))
;;    (show-paren-match-face ((t (:background "palegreen"))))
;;    (show-paren-mismatch-face ((t (:background "orchid" :foreground "white"))))
;;    (tooltip ((t (:background "lightyellow" :foreground "black"))))
;;    (trailing-whitespace ((t (:background "red1"))))
;;    (widget-button-pressed-face ((t (:foreground "red1"))))
;;    (widget-documentation-face ((t (:foreground "dark green"))))
;;    (widget-field-face ((t (:background "gray85"))))
;;    (widget-inactive-face ((t (:foreground "grey50"))))
;;    (widget-single-line-field-face ((t (:background "gray85"))))
   ))

(defadvice my-theme-whiteboard (after whiteboard-cursor-colors activate)
  (setq my-set-cursor-color-normal-color "Green3"
        my-set-cursor-color-read-only-color "Yellow3"
        my-set-cursor-color-overwrite-color "Red3"))

(provide 'my-theme)
