;;; my-buf.el

;; Ignore buffers

(defvar my-buf-always-show-regexps (list (concat "^"
                                                 (regexp-opt (list "*Find"
                                                                   "*Man"
                                                                   "*Occur"
                                                                   "*ag"
                                                                   "*cc-status"
                                                                   "*clearcase-config-spec"
                                                                   "*compilation"
                                                                   "*grep"
                                                                   "*info"
                                                                   "*magit:"
                                                                   "*scratch"
                                                                   "*shell"
                                                                   "*terminal"
                                                                   "*regman"
                                                                   "*vcs-compile"))))
  "*Buffer regexps to always show when buffer switching.")

(defvar my-buf-never-show-regexps '("^\\s-" "^\\*" "TAGS$")
  "*Buffer regexps to never show when buffer switching.")

(defvar my-buf-ignore-dired-buffers t
  "*If non-nil, buffer switching should ignore dired buffers.")

(defun my-buf-str-in-regexp-list (str regexp-list)
  "Return non-nil if str matches anything in regexp-list."
  (let ((case-fold-search nil))
    (catch 'done
      (dolist (regexp regexp-list)
        (when (string-match regexp str)
          (throw 'done t))))))

(defun my-buf-ignore-buffer (name)
  "Return non-nil if the named buffer should be ignored."
  (or (and (not (my-buf-str-in-regexp-list name my-buf-always-show-regexps))
           (my-buf-str-in-regexp-list name my-buf-never-show-regexps))
      (and my-buf-ignore-dired-buffers
           (condition-case nil
               (with-current-buffer name
                 (and (equal major-mode 'dired-mode)
                      (not (string= name "*Find*"))))
             (error nil)))))

;; Toggle buffers

(defun my-buf-toggle ()
  "Toggle buffers, ignoring certain ones."
  (interactive)
  (catch 'done
    (dolist (buf (buffer-list))
      (unless (or (equal (current-buffer) buf)
                  (my-buf-ignore-buffer (buffer-name buf)))
        (switch-to-buffer buf)
        (throw 'done t)))))

;; Popup special buffers at bottom of frame

(add-to-list 'display-buffer-alist
             '(my-buf-popup-filter
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible)))

(defun my-buf-popup-filter (buffer alist)
  "Filter for `display-buffer-alist' to popup these buffers at
the bottom of the frame."
  (string-match (concat "\\`" (regexp-opt '(
                                            "*Compile-Log"
                                            "*Find"
                                            "*Help"
                                            "*Ibuffer"
                                            "*Occur"
                                            "*ag"
                                            "*compilation"
                                            "*grep"
                                            "*magit-diff"
                                            "*regman"
                                            "*vcs-compile"
                                            ))) buffer))


;; Splits

(defun my-buf-split-window-vertically (&optional arg)
  "Like `split-window-vertically', but switch to other window after split.
With prefix arg, stay in current window but show different buffer in new window."
  (interactive "P")
  (split-window-vertically)
  (recenter)
  (other-window 1)
  (when arg
    (my-buf-toggle))
  (recenter)
  (when arg
    (other-window -1)))

(defun my-buf-split-window-horizontally (&optional arg)
  "Like `split-window-horizontally', but switch to other window after split.
With prefix arg, stay in current window but show different buffer in new window."
  (interactive "P")
  (split-window-horizontally)
  (other-window 1)
  (when arg
    (my-buf-toggle)
    (other-window -1)))

;; Done

(provide 'my-buf)
