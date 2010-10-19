;;; my-ffap.el

(require 'ffap)

(setq-default ffap-url-regexp nil)
(setcdr (assq 'file ffap-string-at-point-mode-alist) (list "-a-zA-Z0-9_.@/$(){}" "" ""))

(defun my-ffap (&optional arg)
  "ffap, or ffap-other-window when preceded with C-u."
  (interactive "P")
  (call-interactively (if arg 'ffap-other-window 'ffap)))

(defadvice ffap-string-at-point (around my-ffap-string-at-point activate)
  "Capture and expand $(FOO) or ${FOO} or $FOO from env vars."
  ad-do-it
  (when ad-return-value
    (with-temp-buffer
      (insert ad-return-value)
      (goto-char (point-min))
      (while (re-search-forward "\\([$]\\)" nil t)
        (let (env-var)
          (delete-char -1)
          (when (looking-at "[({]")
            (delete-char 1))
          (when (looking-at "[a-zA-Z0-9_]+")
            (setq env-var (match-string-no-properties 0))
            (replace-match ""))
          (when (looking-at "[})]")
            (delete-char 1))
          (when (and (stringp env-var) (getenv env-var))
            (insert (getenv env-var)))))
      (setq ad-return-value (buffer-substring (point-min) (point-max)))
      (setq ffap-string-at-point ad-return-value))))

(provide 'my-ffap)