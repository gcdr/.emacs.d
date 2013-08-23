;;; my-occur.el

(defun my-occur (&optional arg)
  "Like `occur', but with prefix arg take the string from the region."
  (interactive "P")
  (if arg
      (occur (regexp-quote (buffer-substring (region-beginning) (region-end))))
    (let* ((default (buffer-substring-no-properties
                     (point)
                     (save-excursion (skip-syntax-forward "w_") (point))))
           (regexp (read-from-minibuffer
                    (format "List lines matching regexp (default %s): " default) nil nil nil
                    'regexp-history default)))
      (setq regexp (if (string= regexp "") default regexp))
      (occur regexp)))
  (my-occur-fit-buffer))

(defun my-occur-fit-buffer ()
  "Fit occur buffer better."
  (when (buffer-live-p (get-buffer "*Occur*"))
    (pop-to-buffer "*Occur*")
    (setq truncate-lines 'one-line-each)
    (fit-window-to-buffer nil (/ (frame-height) 2))))

(defun my-occur-mode-remove-line-numbers ()
  "Removes line numbers from occur buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (toggle-read-only 0)
    (while (re-search-forward "^[ \t]*[0-9]+:" nil t)
      (replace-match "")
      (forward-line 1))
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)))

(defadvice isearch-occur (after my-isearch-occur activate)
  "Tweak occur buffer."
  (my-occur-fit-buffer))

(defun my-occur-mode-hook ()
  (define-key occur-mode-map "q" (lambda ()
                                   (interactive)
                                   (kill-buffer nil)
                                   (when (> (count-windows) 1)
                                     (delete-window))))
  (define-key occur-mode-map "n" 'next-line)
  (define-key occur-mode-map "p" 'previous-line)
  (occur-rename-buffer t))

(add-hook 'occur-mode-hook 'my-occur-mode-hook)

(provide 'my-occur)
