(deftheme smf-base-light
  "Base light colors.")

(customize-set-variable 'frame-background-mode 'light)
(load-theme 'smf-base t)

(custom-theme-set-faces
 'smf-base-light

   `(caution                        ((t :foreground "black" :background ,(smf-color 223))
   `(error                          ((t :foreground ,(smf-color 231) :background ,(smf-color 124))))
   `(flymake-errline                ((t :inherit nil :background ,(smf-color 224))))
   `(flymake-warnline               ((t :inherit nil :background ,(smf-color 229))))
   `(header-line                    ((t :foreground ,(smf-color 252) :background ,(smf-color 238))))
   `(isearch                        ((t :background ,(smf-color 88) :foreground ,(smf-color 231))))
   `(js2-object-property            ((t :inherit font-lock-type-face)))
   `(lazy-highlight                 ((t :background ,(smf-color 181) :foreground "black")))
   `(link                           ((t :foreground ,(smf-color 26) :italic t :underline t)))
   `(link-visited                   ((t :foreground ,(smf-color 93) :italic t :underline t)))
   `(linum                          ((t :foreground ,(smf-color 60) :background ,(smf-color 255) :italic t)))
   `(mode-line-buffer-id            ((t :foreground ,(smf-color 20))))
   `(outline-1                      ((t :foreground ,(smf-color 33))))
   `(outline-2                      ((t :foreground ,(smf-color 32))))
   `(outline-3                      ((t :foreground ,(smf-color 31))))
   `(outline-4                      ((t :foreground ,(smf-color 30))))
   `(outline-5                      ((t :foreground ,(smf-color 29))))
   `(success                        ((t :foreground ,(smf-color 231) :background ,(smf-color 28))))
   `(trailing-whitespace            ((t :background ,(smf-color 195))))
   `(warning                        ((t :foreground "black" :background ,(smf-color 226))))
   `(web-mode-html-attr-custom-face ((t :foreground ,(smf-color 143))))
   `(web-mode-html-attr-name-face   ((t :foreground ,(smf-color 65))))
   `(web-mode-html-attr-value-face  ((t :foreground ,(smf-color 138))))
   `(web-mode-html-tag-face         ((t :foreground ,(smf-color 67))))
   `(whitespace-tab                 ((t :background ,(smf-color 224))))

   )

(provide-theme 'smf-base-light)