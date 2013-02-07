(defun my-x-color-to-tty-color ()
  (interactive)
  (let (x-color end)
    (skip-chars-backward "a-zA-Z0-9")
    (setq end (save-excursion (skip-chars-forward "a-zA-Z0-9") (point)))
    (setq x-color (buffer-substring-no-properties (point) end))
    (kill-region (point) end)
    (insert "color-" (number-to-string (tty-color-translate x-color)))))

(deftheme my-terminal-light
  "Terminal with light background.")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'my-terminal-light

   `(button ((,class (:foreground "color-30"))))
   `(compilation-column-number ((,class (:foreground "color-22"))))
   `(compilation-error ((,class (:foreground "red"))))
   `(compilation-info ((,class (:foreground "color-28"))))
   `(compilation-line-number ((,class (:foreground "color-18"))))
   `(cperl-array-face ((t (:foreground "color-62" :weight normal))))
   `(cperl-hash-face ((t (:foreground "cyan" :slant normal :weight normal))))
   `(cperl-nonoverridable-face ((,class (:foreground "color-170"))))
   `(cursor ((,class (:background "color-28"))))
   `(dired-marked ((,class (:background "color-32" :foreground "color-231"))))
   `(flymake-errline ((,class (:background "color-224"))))
   `(flymake-warnline ((,class (:background "color-230"))))
   `(font-lock-builtin-face ((,class (:foreground "color-166"))))
   `(font-lock-comment-delimiter-face ((,class (:foreground "color-248"))))
   `(font-lock-comment-face ((,class (:foreground "color-248"))))
   `(font-lock-constant-face ((,class (:foreground "color-65"))))
   `(font-lock-doc-face ((,class (:foreground "color-173"))))
   `(font-lock-doc-string-face ((,class (:foreground "color-173"))))
   `(font-lock-function-name-face ((,class (:foreground "color-172"))))
   `(font-lock-keyword-face ((,class (:foreground "color-33"))))
   `(font-lock-preprocessor-face ((,class (:foreground "color-178"))))
   `(font-lock-reference-face ((,class (:foreground "color-209"))))
   `(font-lock-string-face ((,class (:foreground "color-95"))))
   `(font-lock-type-face ((,class (:foreground "color-24"))))
   `(font-lock-variable-name-face ((,class (:foreground "color-29"))))
   `(font-lock-warning-face ((,class (:foreground "red"))))
   `(fringe ((,class (:background "color-253"))))
   `(highlight ((,class (:background "color-117" :foreground "black"))))
   `(hl-line ((,class (:background "color-230"))))
   `(ido-first-match ((,class (:weight normal :foreground "color-166"))))
   `(ido-only-match ((,class (:foreground "color-29"))))
   `(ido-subdir ((,class (:foreground nil :inherit font-lock-keyword-face))))
   `(info-header-node ((,class (:foreground "color-39"))))
   `(info-header-xref ((,class (:inherit info-xref :foreground "color-29"))))
   `(info-menu-star ((,class (:foreground "black"))))
   `(info-node ((,class (:foreground "color-39"))))
   `(info-title-1 ((,class (:foreground "color-100"))))
   `(info-title-2 ((,class (:foreground "color-106"))))
   `(info-xref ((,class (:inherit link :foreground "brightblue"))))
   `(isearch ((,class (:background "color-203" :foreground "color-231"))))
   `(isearch-fail ((,class (:background "red" :foreground "color-231"))))
   `(isearch-lazy-highlight-face ((,class (:background "color-94" :foreground "color-231"))))
   `(lazy-highlight ((,class (:background "color-73" :foreground "color-231"))))
   `(link ((,class (:foreground "color-20"))))
   `(link-visited ((,class (:inherit link :foreground "brightmagenta"))))
   `(magit-diff-add ((,class (:foreground "green"))))
   `(magit-diff-del ((,class (:foreground "red"))))
   `(magit-item-highlight ((,class (:background "color-254"))))
   `(magit-section-title ((,class (:inherit font-lock-keyword-face))))
   `(match ((,class (:background "color-217"))))
   `(minibuffer-prompt ((,class (:foreground "color-24"))))
   `(mode-line ((,class (:background "white" :foreground "black"))))
   `(mode-line-buffer-id ((,class (:foreground "color-20"))))
   `(mode-line-inactive ((,class (:background "color-248" :foreground "color-238"))))
   `(my-debug-face ((,class (:background "color-208" :foreground "black"))))
   `(my-fixme-face ((,class (:background "red" :foreground "color-231"))))
   `(my-modified-face ((,class (:background "color-124" :foreground "color-255"))))
   `(my-narrow-face ((,class (:background "brightyellow" :foreground "black"))))
   `(my-read-only-face ((,class (:background "color-208" :foreground "black"))))
   `(my-tab-face ((,class (:background "color-224"))))
   `(my-todo-face ((,class (:background "brightyellow" :foreground "black"))))
   `(org-checkbox-statistics-done ((,class (:foreground "color-28"))))
   `(org-checkbox-statistics-todo ((,class (:foreground "color-95"))))
   `(org-date ((,class (:foreground "color-24"))))
   `(org-document-title ((,class (:foreground "color-100"))))
   `(org-special-keyword ((,class (:foreground "color-94"))))
   `(org-tag ((,class (:foreground "color-69"))))
   `(org-todo ((,class (:foreground "color-95"))))
   `(outline-1 ((t (:inherit font-lock-function-name-face))))
   `(outline-2 ((,class (:foreground "color-33"))))
   `(outline-3 ((,class (:foreground "color-67"))))
   `(outline-4 ((,class (:foreground "color-62"))))
   `(outline-5 ((,class (:foreground "color-39"))))
   `(primary-selection ((,class (:background "color-20"))))
   `(region ((,class (:background "color-152"))))
   `(show-paren-match-face ((,class (:background "color-33" :foreground "color-231"))))
   `(show-paren-mismatch-face ((,class (:background "brightred" :foreground "color-231"))))
   `(task-bmk-face ((,class (:background "color-254"))))
   `(trailing-whitespace ((,class (:background "color-195"))))
   `(warning ((,class (:foreground "color-100"))))

   ))

(provide-theme 'my-terminal-light)
