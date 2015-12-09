(deftheme my-dark
  "Terminal with dark background.")

(let ((class '((class color) (min-colors 89))))
  (custom-theme-set-faces
   'my-dark

   `(bm-face                             ((,class (:foreground "brightwhite" :background "color-53"))))
   `(compilation-mode-line-exit          ((,class (:foreground "green" :background nil))))
   `(compilation-mode-line-fail          ((,class (:foreground "brightred" :background nil))))
   `(font-lock-builtin-face              ((,class (:foreground "color-180"))))
   `(font-lock-comment-delimiter-face    ((,class (:inherit font-lock-comment-face))))
   `(font-lock-comment-face              ((,class (:foreground "color-244" :slant italic))))
   `(font-lock-constant-face             ((,class (:foreground "color-149"))))
   `(font-lock-doc-face                  ((,class (:foreground "color-138"))))
   `(font-lock-doc-string-face           ((,class (:foreground "color-138"))))
   `(font-lock-function-name-face        ((,class (:foreground "color-178"))))
   `(font-lock-keyword-face              ((,class (:foreground "color-39" :weight bold))))
   `(font-lock-preprocessor-face         ((,class (:foreground "color-220"))))
   `(font-lock-reference-face            ((,class (:foreground "color-210"))))
   `(font-lock-regexp-grouping-backslash ((,class (:weight bold))))
   `(font-lock-regexp-grouping-construct ((,class (:weight bold))))
   `(font-lock-string-face               ((,class (:foreground "color-175"))))
   `(font-lock-type-face                 ((,class (:foreground "color-123"))))
   `(font-lock-variable-name-face        ((,class (:foreground "color-78"))))
   `(font-lock-warning-face              ((,class (:foreground "red"))))
   `(header-line                         ((,class (:foreground "color-254" :background "color-236" :underline nil))))
   `(highlight                           ((,class (:foreground nil :background "color-236"))))
   `(ido-first-match                     ((,class (:foreground "yellow" :weight normal ))))
   `(ido-only-match                      ((,class (:foreground "brightgreen" :weight normal))))
   `(ido-subdir                          ((,class (:foreground nil :inherit font-lock-keyword-face))))
   `(isearch                             ((,class (:background "color-167" :foreground "color-15"))))
   `(isearch-lazy-highlight-face         ((,class (:background "color-94" :foreground "color-15"))))
   `(match                               ((,class (:foreground "color-15" :background "color-53"))))
   `(minibuffer-prompt                   ((,class (:foreground "color-74"))))
   `(mode-line                           ((,class (:background "color-24" :foreground nil))))
   `(mode-line-buffer-id                 ((,class (:foreground "yellow" :weight bold))))
   `(mode-line-inactive                  ((,class (:background "color-240" :foreground "color-250"))))
   `(my-tab-face                         ((,class (:background "color-175"))))
   `(region                              ((,class (:background "color-25"))))
   `(show-mark-face                      ((,class (:background "color-236"))))
   `(show-mark-face-eol                  ((,class (:underline t :foreground "color-236"))))
   `(show-paren-match-face               ((,class (:background "color-27" :foreground "color-15"))))
   `(show-paren-mismatch-face            ((,class (:background "color-124" :foreground "color-15"))))
   `(trailing-whitespace                 ((,class (:background "color-24"))))

   ))

(provide-theme 'my-dark)
