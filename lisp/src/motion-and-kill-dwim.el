;;; motion-and-kill-dwim.el --- Motion and kill DWIM commands

;; Copyright (C) 2007  Scott Frazer

;; Author: Scott Frazer <frazer.scott@gmail.com>
;; Maintainer: Scott Frazer <frazer.scott@gmail.com>
;; Created: 01 Aug 2007
;; Version: 1.3
;; Keywords: motion kill dwim

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; A set of motion and kill do-what-I-mean commands.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control variables

(defvar makd-highlight-delay 0.5
  "*How long to highlight.")

(defvar makd-camelcase-sections t
  "*Sections can also be camelCase")

(make-local-variable 'makd-camelcase-sections)

(defvar makd-block-indented-modes (list 'emacs-lisp-mode
                                        'lisp-mode
                                        'scheme-mode
                                        'xml-mode
                                        'python-mode)
  "*Major modes that forward block should work by indentation")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Motion

(defun makd-forward-word ()
  "Like forward-word, but stops at beginning of words."
  (interactive)
  (when (looking-at "\\(\\sw\\|\\s_\\)")
    (skip-syntax-forward "w_"))
  (skip-syntax-forward "^w_"))

(defun makd-forward-word-section ()
  "Like forward-word, but only goes over alphanumerics."
  (interactive)
  (makd-forward-section)
  (skip-chars-forward "^a-zA-Z0-9"))

(defun makd-forward-word-end ()
  "Forward to end of word."
  (interactive)
  (unless (looking-at "\\(\\sw\\|\\s_\\)")
    (skip-syntax-forward "^w_"))
  (skip-syntax-forward "w_"))

(defun makd-forward-paragraph ()
  "Like forward-paragraph, but goes to next non-blank line."
  (interactive)
  (beginning-of-line)
  (when (re-search-forward "^\\s-*$" nil 'go)
    (re-search-forward "[^ \t\f\n]" nil 'go)
    (beginning-of-line)))

(defun makd-forward-block ()
  "Goes forward to end of next curly-bracket or indented block
depending on the major mode (see `makd-block-indented-modes')."
  (interactive)
  (if (memq major-mode makd-block-indented-modes)
      (makd-forward-indented-block)
    (makd-forward-curly-block)))

(defun makd-forward-curly-block ()
  "Goes forward to end of next curly-bracket block."
  (interactive)
  (let (done)
    (while (not (or done (eobp)))
      (when (and (re-search-forward "[{}]" nil 'go)
                 (not (memq (get-text-property (1- (point)) 'face)
                            '(font-lock-comment-face font-lock-string-face))))
        (when (equal (char-before) ?{)
          (backward-char)
          (forward-sexp))
        (forward-line)
        (beginning-of-line)
        (while (and (not (eobp)) (looking-at "^\\s-*$"))
          (forward-line))
        (setq done t)))))

(defun makd-forward-indented-block ()
  "Goes forward to next line at the same or less indentation."
  (interactive)
  (beginning-of-line)
  (when (looking-at "\\s-*$")
    (re-search-forward "[^ \t\f\n]" nil 'go))
  (back-to-indentation)
  (let ((col (current-column)) done)
    (while (not (or done (eobp)))
      (forward-line 1)
      (back-to-indentation)
      (when (and (<= (current-column) col) (not (looking-at "$")))
        (beginning-of-line)
        (while (and (not (eobp)) (looking-at "^\\s-*$"))
          (forward-line))
        (setq done t)))))

(defun makd-backward-word ()
  "Like backward-word, but stops at beginning of words."
  (interactive)
  (unless (looking-back "\\(\\sw\\|\\s_\\)")
    (skip-syntax-backward "^w_"))
  (skip-syntax-backward "w_"))

(defun makd-backward-word-section ()
  "Like backward-word, but only goes over alphanumerics."
  (interactive)
  (skip-chars-backward "^a-zA-Z0-9")
  (makd-backward-section))

(defun makd-backward-word-end ()
  "Backward to end of word."
  (interactive)
  (when (looking-back "\\(\\sw\\|\\s_\\)")
    (skip-syntax-backward "w_"))
  (skip-syntax-backward "^w_"))

(defun makd-backward-paragraph ()
  "Go to first line after previous blank line."
  (interactive)
  (beginning-of-line)
  (re-search-backward "[^ \t\f\n]" nil 'go)
  (when (re-search-backward "^\\s-*$" nil 'go)
    (forward-line 1))
  (beginning-of-line))

(defun makd-backward-block ()
  "Goes backward to beginning of next curly-bracket or indented block
depending on the major mode (see `makd-block-indented-modes')."
  (interactive)
  (if (memq major-mode makd-block-indented-modes)
      (makd-backward-indented-block)
    (makd-backward-curly-block)))

(defun makd-backward-curly-block ()
  "Goes backward to beginning of next curly-bracket block."
  (interactive)
  (let (done)
    (while (not (or done (bobp)))
      (when (and (re-search-backward "[{}]" nil 'go)
                 (not (memq (get-text-property (point) 'face)
                            '(font-lock-comment-face font-lock-string-face))))
        (when (equal (char-after) ?})
          (forward-char)
          (backward-sexp))
        (beginning-of-line)
        (setq done t)))))

(defun makd-backward-indented-block ()
  "Goes backward to beginning of line at the same or less indentation."
  (interactive)
  (beginning-of-line)
  (when (looking-at "\\s-*$")
    (re-search-backward "[^ \t\f\n]" nil 'go))
  (back-to-indentation)
  (let ((col (current-column)) done)
    (while (not (or done (bobp)))
      (forward-line -1)
      (back-to-indentation)
      (when (and (<= (current-column) col) (not (looking-at "$")))
        (setq done t)
        (beginning-of-line)))))

;;; Utility motion functions

(defun makd-forward-section ()
  "Move forward a word section.
This is a utility function, you probably want `makd-forward-word-section'"
  (let ((case-fold-search nil))
    (if makd-camelcase-sections
        (if (looking-at "[a-z0-9]")
            (skip-chars-forward "a-z0-9")
          (when (looking-at "[A-Z]")
            (forward-char)
            (if (looking-at "[a-z]")
                (skip-chars-forward "a-z0-9")
              (skip-chars-forward "A-Z0-9"))))
      (skip-chars-forward "a-zA-Z0-9"))))

(defun makd-backward-section ()
  "Move backward a word section.
This is a utility function, you probably want `makd-backward-word-section'."
  (let ((case-fold-search nil))
    (if makd-camelcase-sections
        (progn
          (skip-chars-backward "0-9")
          (if (looking-back "[A-Z]")
              (skip-chars-backward "A-Z0-9")
            (when (looking-back "[a-z]")
                (skip-chars-backward "a-z0-9")
                (when (looking-back "[A-Z]")
                  (backward-char)))))
      (skip-chars-backward "a-zA-Z0-9"))))

;; Utility region functions

(defun makd-region-inside-pair (char dir)
  "Find the region inside paired chars ()[]{}"
  (let* ((beg (point))
         (end beg)
         regex open close)
    (cond ((or (eq char ?() (eq char ?)))
           (setq regex "[()]"
                 open  ?\(
                 close ?\)))
          ((or (eq char ?\[) (eq char ?\]))
           (setq regex "[][]"
                 open  ?\[
                 close ?\]))
          ((or (eq char ?\{) (eq char ?\}))
           (setq regex "[{}]"
                 open  ?\{
                 close ?\})))
    (save-excursion
      (cond ((equal dir 'backward)
             (setq beg (makd-backward-paired regex open close)))
            ((equal dir 'forward)
             (setq end (makd-forward-paired regex open close)))
            ((equal dir 'inside)
             (save-excursion (setq beg (makd-backward-paired regex open close)))
             (setq end (makd-forward-paired regex open close)))))
    (cons beg end)))

(defun makd-backward-paired (regex open close)
  (let (done (nesting 0))
    (while (not (or done (bobp)))
      (when (and (re-search-backward regex nil 'go)
                 (not (memq (get-text-property (point) 'face)
                            '(font-lock-comment-face font-lock-string-face))))
        (cond ((eq (char-after) close)
               (setq nesting (1+ nesting)))
              ((eq (char-after) open)
               (if (= nesting 0)
                   (setq done t)
                 (setq nesting (1- nesting))))))))
  (unless (bobp)
    (forward-char))
  (point))

(defun makd-forward-paired (regex open close)
  (let (done (nesting 0))
    (while (not (or done (eobp)))
      (when (and (re-search-forward regex nil 'go)
                 (not (memq (get-text-property (point) 'face)
                            '(font-lock-comment-face font-lock-string-face))))
        (cond ((eq (char-before) open)
               (setq nesting (1+ nesting)))
              ((eq (char-before) close)
               (if (= nesting 0)
                   (setq done t)
                 (setq nesting (1- nesting))))))))
  (unless (eobp)
    (backward-char))
  (point))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Kill/copy

(defun makd-forward-kill ()
  "Smart kill forward.
1. If region is active, kill it
2. Else if at the beginning of a word, kill the word and trailing whitespace
3. Else if in the middle of a word, kill the rest of the word
4. Else if looking at whitespace, kill whitespace forward
5. Else if looking at punctuation, kill punctuation forward
6. Else if looking at an open bracket/brace/paren, kill sexp forward
7. Else if looking at a quotation mark, kill quoted text
8. Else kill next char"
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (point)
                 (progn
                   (cond ((looking-at "\\<\\(\\sw\\|\\s_\\)")
                          (skip-syntax-forward "w_")
                          (skip-syntax-forward " "))
                         ((looking-at "\\(\\sw\\|\\s_\\)")
                          (skip-syntax-forward "w_"))
                         ((looking-at "\\s ")
                          (skip-syntax-forward " "))
                         ((looking-at "\\s.")
                          (skip-syntax-forward "."))
                         ((looking-at "\\s(")
                          (forward-sexp))
                         ((looking-at "\\s\"")
                          (forward-char)
                          (skip-syntax-forward "^\"")
                          (forward-char))
                         (t
                          (forward-char)))
                   (point)))))

(defun makd-forward-kill-section ()
  "Forward kill pieces of words."
  (interactive)
  (kill-region (point)
               (progn
                 (makd-forward-section)
                 (while (looking-at "\\s_")
                   (forward-char))
                 (point))))

(defun makd-backward-kill ()
  "Smart kill backward.
1. If region is active, kill it
2. Else if looking back at whitespace, kill backward whitespace and word
3. Else if in the middle of a word, kill backward word
4. Else if looking at punctuation, kill backward punctuation
5. Else if looking at an close bracket/brace/paren, kill backward sexp
6. Else if looking at a quotation mark, kill backward quoted text
7. Else kill previous char"
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (point)
                 (progn
                   (cond ((looking-back "\\s ")
                          (skip-syntax-backward " ")
                          (when (looking-back "\\(\\sw\\|\\s_\\)")
                            (skip-syntax-backward "w_")))
;;                          ((looking-back "\\(\\sw\\|\\s_\\)\\>")
;;                          (skip-syntax-backward "w_")
;;                          (unless (looking-back "^\\s +")
;;                          (skip-syntax-backward " ")))
                         ((looking-back "\\(\\sw\\|\\s_\\)")
                          (skip-syntax-backward "w_"))
                         ((looking-back "\\s.")
                          (skip-syntax-backward "."))
                         ((looking-back "\\s)")
                          (backward-sexp))
                         ((looking-back "\\s\"")
                          (backward-char)
                          (skip-syntax-backward "^\"")
                          (backward-char))
                         (t
                          (backward-char)))
                   (point)))))

(defun makd-backward-kill-section ()
  "Backward kill pieces of words."
  (interactive)
  (kill-region (point)
               (progn
                 (while (looking-back "\\s_")
                   (backward-char))
                 (makd-backward-section)
                 (point))))

(defun makd-kill-unit ()
  "Kill over a unit of text."
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (message "Kill:")
    (let ((c (read-char)) dir)
      (cond
       ((eq c ?/) (call-interactively 'makd-kill-to-isearch))
       ((eq c ??) (call-interactively 'makd-backward-kill-to-isearch))

       ((eq c ?p) (kill-region (point) (progn (makd-forward-paragraph) (point))))
       ((eq c ?P) (kill-region (point) (progn (makd-backward-paragraph) (point))))

       ((eq c ?l) (kill-region (point) (progn (makd-forward-block) (point))))
       ((eq c ?L) (kill-region (point) (progn (makd-backward-block) (point))))

       ((eq c ?m) (kill-sexp 1))
       ((eq c ?M) (kill-sexp -1))

       ((not (memq c '(?i ?\( ?\) ?\[ ?\] ?\{ ?\})))
        (kill-region (point-at-bol) (point-at-bol 2))))

      (when (eq c ?i)
        (message "Kill: i")
        (setq c (read-char))
        (setq dir 'inside))

      (cond ((memq c '(?\( ?\[ ?\{))
             (unless dir
               (setq dir 'backward)))
            ((memq c '(?\) ?\] ?\}))
             (unless dir
               (setq dir 'forward))))
      (when (memq c '(?\( ?\) ?\[ ?\] ?\{ ?\}))
        (let ((region (makd-region-inside-pair c dir)))
          (kill-region (car region) (cdr region)))))))

(defun makd-copy-unit ()
  "Copy over a unit of text."
  (interactive)
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (message "Copy:")
    (let ((c (read-char)))
      (cond ((eq c ?/) (call-interactively 'makd-copy-to-isearch))
            ((eq c ??) (call-interactively 'makd-backward-copy-to-isearch))
            (t
             (let ((beg (point)) end dir)
               (save-excursion
                 (cond
                  ((eq c ?p) (makd-forward-paragraph))
                  ((eq c ?P) (makd-backward-paragraph))

                  ((eq c ?l) (makd-forward-block))
                  ((eq c ?L) (makd-backward-block))

                  ((eq c ?m) (forward-sexp 1))
                  ((eq c ?M) (forward-sexp -1))

                  ((not (memq c '(?i ?\( ?\) ?\[ ?\] ?\{ ?\})))
                   (setq beg (point-at-bol)) (forward-line) (beginning-of-line)))

                 (setq end (point)))

               (when (eq c ?i)
                 (message "Copy: i")
                 (setq c (read-char))
                 (setq dir 'inside))

               (cond ((memq c '(?\( ?\[ ?\{))
                      (unless dir
                        (setq dir 'backward)))
                     ((memq c '(?\) ?\] ?\}))
                      (unless dir
                        (setq dir 'forward))))
               (when (memq c '(?\( ?\) ?\[ ?\] ?\{ ?\}))
                 (let ((region (makd-region-inside-pair c dir)))
                   (setq beg (car region)
                         end (cdr region))))

               (unless (= beg end)
                 (makd-highlight beg end 'makd-copy-region-face)
                 (kill-ring-save beg end))))))))

(defun makd-kill-line (&optional arg)
  "Like kill-line, but use `makd-join-line-with-next' when at
end-of-line (and it's not a empty line."
  (interactive "P")
  (if (or arg (not (eolp)) (bolp))
      (if (= arg 0)
          (kill-region (point) (progn (back-to-indentation) (point)))
      (kill-line arg))
    (makd-join-line-with-next)))

(defun makd-join-line-with-next ()
  "Join current line with next."
  (interactive)
  (delete-indentation t)
  (just-one-space 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Kill/copy with isearch

(defvar makd-isearch-start nil)
(defvar makd-isearch-end nil)
(defvar makd-isearch-overlay nil)
(defvar makd-isearch-face nil)
(defvar makd-isearch-forward nil)

(defface makd-kill-region-face
  '((t (:inherit region)))
  "Face to highlight region that will be killed"
  :group 'faces)

(defface makd-copy-region-face
  '((t (:inherit region)))
  "Face to highlight region that will be copied"
  :group 'faces)

(defun makd-kill-to-isearch ()
  "Kill from point to somewhere else using isearch."
  (interactive)
  (makd-kill-or-copy-isearch t t))

(defun makd-backward-kill-to-isearch ()
  "Kill backward from point to somewhere else using isearch."
  (interactive)
  (makd-kill-or-copy-isearch t nil))

(defun makd-copy-to-isearch ()
  "Copy from point to somewhere else using isearch."
  (interactive)
  (makd-kill-or-copy-isearch nil t))

(defun makd-backward-copy-to-isearch ()
  "Copy backward from point to somewhere else using isearch."
  (interactive)
  (makd-kill-or-copy-isearch nil nil))

(defun makd-kill-or-copy-isearch (kill forward)
  "Kill or copy from point to somewhere else using isearch."
  (unwind-protect
      (save-excursion
        (setq makd-isearch-start (point))
        (setq makd-isearch-face (if kill
                                    'makd-kill-region-face
                                  'makd-copy-region-face))
        (setq makd-isearch-forward forward)
        (when (if forward (isearch-forward) (isearch-backward))
          (if kill
              (kill-region makd-isearch-start makd-isearch-end)
            (copy-region-as-kill makd-isearch-start makd-isearch-end))))
    (setq makd-isearch-start nil)
    (when makd-isearch-overlay
      (delete-overlay makd-isearch-overlay))))

(defadvice isearch-highlight (after makd-iseach-add-overlay activate)
  (when makd-isearch-start
    (if makd-isearch-forward
        (setq makd-isearch-end (ad-get-arg 0))
      (setq makd-isearch-end (ad-get-arg 1)))
    (if makd-isearch-overlay
        (move-overlay makd-isearch-overlay makd-isearch-start makd-isearch-end (current-buffer))
      (setq makd-isearch-overlay (make-overlay makd-isearch-start makd-isearch-end)))
    (overlay-put makd-isearch-overlay 'face makd-isearch-face)))

(defadvice isearch-dehighlight (after makd-isearch-remove-overlay activate)
  (when makd-isearch-overlay
    (delete-overlay makd-isearch-overlay)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yank

(defun makd-yank (&optional arg)
  "Yank and indent."
  (interactive "P")
  (when (region-active-p)
    (kill-region (region-beginning) (region-end))
    (rotate-yank-pointer 1))
  (yank)
  (when (and (not arg) (not (member indent-line-function '(indent-relative sh-basic-indent-line))))
    (exchange-point-and-mark)
    (indent-region (point) (mark 't))
    (exchange-point-and-mark)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Indent

(defun makd-indent ()
  "Indent the region if it is active, otherwise normal indent."
  (interactive)
  (if (region-active-p)
      (indent-region (region-beginning) (region-end))
    (indent-according-to-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open

(defun makd-open-line-above ()
  "Open a line above the current one."
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1))

(defun makd-open-line-below ()
  "Open a line below the current one."
  (interactive)
  (end-of-line)
  (newline))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Select

(defun makd-select-word-at-point ()
  "Select the word at point."
  (interactive)
  (skip-syntax-forward "w_")
  (push-mark (point))
  (skip-syntax-backward "w_")
  (exchange-point-and-mark))

(defun makd-select-section-at-point ()
  "Select the section at point."
  (interactive)
  (skip-syntax-forward "w")
  (push-mark (point))
  (skip-syntax-backward "w")
  (exchange-point-and-mark))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search/Replace

(defun makd-query-replace ()
  "query-replace ... take from-string from region if it is active"
  (interactive "*")
  (if (region-active-p)
      (let* ((from (buffer-substring (region-beginning) (region-end)))
             (to (read-from-minibuffer (format "Query replace %s with: " from) nil nil nil 'query-replace-history)))
        (goto-char (region-beginning))
        (setq mark-active nil)
        (query-replace from to))
    (call-interactively 'query-replace)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Scrolling/Paging

(defun makd-scroll-down (n)
  "Scroll down without moving point (if possible)."
  (interactive "p")
  (let ((col (current-column)))
    (unless (pos-visible-in-window-p (point-max))
      (scroll-up n))
    (forward-line n)
    (unless (memq last-command (list 'next-line 'previous-line))
      (setq temporary-goal-column col))
    (move-to-column (truncate temporary-goal-column))
    (setq this-command 'next-line)))

(defun makd-scroll-up (n)
  "Scroll up without moving point (if possible)."
  (interactive "p")
  (let ((col (current-column)))
    (unless (pos-visible-in-window-p (point-min))
      (scroll-down n))
    (forward-line (- 0 n))
    (unless (memq last-command (list 'next-line 'previous-line))
      (setq temporary-goal-column col))
    (move-to-column (truncate temporary-goal-column))
    (setq this-command 'previous-line)))

(defun makd-page-down ()
  "Page down and keep column."
  (interactive)
  (let ((col (current-column))
        (lines (- (window-height) 2)))
    (if (pos-visible-in-window-p (point-max))
        (goto-char (point-max))
      (save-excursion
        (goto-char (window-start))
        (forward-line lines)
        (set-window-start (selected-window) (point)))
      (forward-line lines)
      (when (eobp)
        (recenter -1)))
    (unless (memq last-command (list 'next-line 'previous-line))
      (setq temporary-goal-column col))
    (move-to-column (truncate temporary-goal-column))
    (setq this-command 'next-line)))

(defun makd-page-up ()
  "Page up and keep column."
  (interactive)
  (let ((col (current-column))
        (lines (- 2 (window-height))))
    (if (pos-visible-in-window-p (point-min))
        (goto-char (point-min))
      (save-excursion
        (goto-char (window-start))
        (forward-line lines)
        (set-window-start (selected-window) (point)))
      (forward-line lines))
    (unless (memq last-command (list 'next-line 'previous-line))
      (setq temporary-goal-column col))
    (move-to-column (truncate temporary-goal-column))
    (setq this-command 'previous-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlight

(defun makd-highlight (beg end &optional face)
  "Highlight a region temporarily."
  (unless face
    (setq face 'isearch))
  (let ((ov (make-overlay beg end)))
    (overlay-put ov 'face face)
    (sit-for makd-highlight-delay)
    (delete-overlay ov)))

;;; Done

(provide 'motion-and-kill-dwim)
;;; motion-and-kill-dwim.el ends here
