;;; bind-remind.el

(defvar bind-remind-key-alist '(
                                ("C-c d"   . "Debugging")
                                ("C-c y"   . "Yank to Target")
                                ("C-x 5"   . "Frames")
                                ("C-x C-k" . "Keyboard Macros")
                                ("C-x n"   . "Narrowing")
                                ("C-x r"   . "Rectangles and Registers")
                                ("C-x t"   . "Tasks")
                                ("C-x v"   . "ClearCase")
                                ("M-r"     . "Rectangles")
                                ("M-s"     . "Search")
                                ("M-s h"   . "Highlight")
                                )
  "Prefix keys to give binding reminders for.")

(defvar bind-remind-command-hash-mapping
  '(
    ("my-debug-insert-ll"                 . "Insert")
    ("ll-debug-renumber"                  . "Renumber")
    ("ll-debug-revert"                    . "Remove all")
    ("my-debug-next"                      . "Goto next")
    ("my-debug-previous"                  . "Goto previous")
    ("my-debug-isearch-forward"           . "isearch forward")
    ("my-debug-isearch-backward"          . "isearch backward")
    ("my-debug-occur"                     . "Occur")
    ("my-debug-multi-occur"               . "Multi-occur")
    ("my-debug-comment-region"            . "Comment region")
    ("my-debug-comment-region-after-copy" . "Insert copy of region and comment original")
    ("my-debug-insert-line"               . "Insert comment")

    ("yank-target-set" . "Set target")
    ("yank-target-yank" . "Copy region to target")
    ("yank-target-kill" . "Move region to target")
    ("yank-target-yank-and-go" . "Copy region to target and go")
    ("yank-target-kill-and-go" . "Move region to target and go")
    ("yank-target-go-source" . "Goto last copy/move region source")
    ("yank-target-go-target" . "Goto target")

    ("clearcase-edcs-edit"                          . "Edit config spec")
    ("cc-status"                                    . "Status")
    ("clearcase-checkout-unreserved-current-buffer" . "Checkout unreserved")
    ("clearcase-checkout-current-buffer"            . "Checkout reserved")
    ("clearcase-checkin-current-buffer"             . "Checkin")
    ("clearcase-uncheckout-current-buffer"          . "Uncheckout keep")
    ("my-clearcase-uncheckout-and-remove"           . "Uncheckout remove")
    ("my-clearcase-ediff-current"                   . "Ediff")
    ("my-clearcase-gui-diff-current"                . "TkDiff")
    ("my-clearcase-list-history"                    . "Show history")
    ("my-clearcase-list-checkouts"                  . "Show checkouts")
    ("clearcase-annotate-current-buffer"            . "Annotate")
    ("my-clearcase-show-package"                    . "What ur package")
    ("clearcase-what-rule-current-buffer"           . "What rule")
    ("my-clearcase-reserve"                         . "Reserve")
    ("my-clearcase-unreserve"                       . "Unreserve")

    ("kill-rectangle" . "Kill")
    ("string-rectangle" . "Replace with string")
    ("my-rectangle-number-lines" . "Number lines")
    ("my-forward-paragraph-rect" . "Forward similar lines")
    ("my-backward-paragraph-rect" . "Backward similar lines")
    ("rectangle-mark-mode" . "Visible mark mode")

    ("my-occur" . "Occur")
    ("my-multi-occur" . "Multi-occur")
    ("my-lgrep" . "Grep")
    ("my-rgrep" . "Rgrep")
    ("isearch-forward-symbol-at-point" . "Isearch forward symbol at point")
    ("isearch-forward-symbol" . "Isearch forward symbol")
    ("isearch-forward-word" . "Isearch forward word")
    )
  "Command/user-string pairs")

(defvar bind-remind-command-hash (make-hash-table :test 'equal)
  "Hash to map command to user string.")

(defvar bind-remind-buf nil)

(defun bind-remind-populate-hash ()
  "Populate `bind-remind-command-hash' from `bind-remind-hash-mapping'."
  (let ((idx 0))
    (dolist (map bind-remind-command-hash-mapping)
      (puthash (car map) (cons (cdr map) idx) bind-remind-command-hash)
      (setq idx (1+ idx)))))

(bind-remind-populate-hash)

(defun bind-remind-show-bindings (&optional test-keys)
  "Show bind reminder."
  (let* ((keys (or test-keys (this-single-command-keys)))
         (prefix (key-description keys))
         (prefix-info (assoc prefix bind-remind-key-alist)))
    (when prefix-info
      (bind-remind-close)
      (let ((bindings (bind-remind-get-bindings (current-buffer) keys prefix))
            (buf (get-buffer-create "*bind-remind*"))
            (max-key-length 0))
        (dolist (binding bindings)
          (setq max-key-length (max max-key-length (length (car binding)))))
        (setq max-key-length (+ 4 max-key-length))
        (with-current-buffer buf
          (erase-buffer)
          (setq header-line-format (format "[%s]" (cdr prefix-info)))
          (setq mode-line-format nil)
          (let (key desc)
            (dolist (binding bindings)
              (setq key (car binding)
                    desc (cdr binding))
              (if (not key)
                  (insert "\n")
                (when (string-match "\\`\\[" desc)
                  (setq key (propertize key 'face 'font-lock-keyword-face)
                        desc (propertize desc 'face 'font-lock-keyword-face)))
                (insert key
                        (make-string (- max-key-length (length key)) ?\ )
                        desc "\n"))))
          (goto-char (point-min)))
        (display-buffer buf '((display-buffer-at-bottom)
                              (window-height . fit-window-to-buffer)))
        (unless test-keys
          (setq bind-remind-buf buf))))))

(defun bind-remind-get-bindings (buf keys prefix)
  "Get sorted bindings."
  (let ((regexp (format "^%s \\([^ ]+\\)\\s-\\{2,\\}\\([^ ].+\\)$" (regexp-quote prefix)))
        bindings key-desc-pairs)
    ;; Get bindings
    (with-temp-buffer
      (describe-buffer-bindings buf keys)
      (goto-char (point-min))
      (while (re-search-forward regexp nil t)
        (let* ((key (match-string-no-properties 1))
               (command (match-string-no-properties 2))
               (info (gethash command bind-remind-command-hash command)))
          ;; Markup prefix commands, finding description if one is supplied
          (when (and (stringp info) (string= info "Prefix Command"))
            (let ((prefix-info (assoc (format "%s %s" prefix key) bind-remind-key-alist)))
              (setq info (format "[%s]" (if prefix-info (cdr prefix-info) info)))))
          (push (cons key info) bindings))))
    ;; Sort
    (setq bindings (sort bindings 'bind-remind-sort-bindings))
    ;; Strip out sorting info and differentiate where user-supplied strings end
    (let (key desc (user-strings (consp (cdar bindings))))
      (dolist (binding bindings)
        (setq key (car binding))
        (when (and user-strings (stringp (cdr binding)))
          (push (cons nil nil) key-desc-pairs)
          (setq user-strings nil))
        (setq desc (if user-strings (cadr binding) (cdr binding)))
        (push (cons key desc) key-desc-pairs)))
    ;; Return list of (key . desc)
    (nreverse key-desc-pairs)))

(defun bind-remind-sort-bindings (x y)
  "Sort bindings."
  (if (stringp (cdr x))
      (if (stringp (cdr y))
          (string< (car x) (car y))
        nil)
    (if (stringp (cdr y))
        t
      (< (cddr x) (cddr y)))))

(defun bind-remind-close ()
  "Close bind-remind buffer."
  (when bind-remind-buf
    (delete-windows-on bind-remind-buf)
    (kill-buffer bind-remind-buf)
    (setq bind-remind-buf nil)))

;; TODO Global minor mode that adds/removes timer and hook
(run-with-idle-timer 1.0 t 'bind-remind-show-bindings)
(add-hook 'pre-command-hook 'bind-remind-close)

;; TODO Tests
;; (bind-remind-show-bindings (kbd "C-x v"))

(provide 'bind-remind)
