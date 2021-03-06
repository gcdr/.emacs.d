;;; grep-ed.el --- Edit grep results and write back to the files

;; Copyright (C) 2009-2010  Scott Frazer

;; Author: Scott Frazer <frazer.scott@gmail.com>
;; Maintainer: Scott Frazer <frazer.scott@gmail.com>
;; Created: 09 Jan 2009
;; Version: 1.0
;; Keywords: grep

;; This file is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3, or (at your option) any later
;; version.

;; This file is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;; more details.

;; You should have received a copy of the GNU General Public License along
;; with GNU Emacs; see the file COPYING.  If not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
;; USA.

;;; Commentary:
;;
;; This package lets you edit the results of a 'grep' by pressing "\C-x\C-q",
;; then write the results back to the files by pressing "\C-x\C-s" (or
;; aborting by pressing "\C-x\C-q" again).
;;
;; The variable `grep-ed-save-after-changes' determines if the changes will be
;; written back automatically or if you have to do it manually.  The variable
;; `grep-ed-unload-new-buffers-after-changes' determines if any new buffers
;; created to make changes will be automatically unloaded.

;;; Code:

(require 'custom)
(require 'grep)
(require 'hilit-chg)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Variables

;; Public

;;;###autoload
(defgroup grep-ed nil
  "*Edit grep results"
  :group 'grep)

;;;###autoload
(defcustom grep-ed-save-after-changes t
  "*If non-nil, save buffers after changing them"
  :group 'grep-ed
  :type 'boolean)

;;;###autoload
(defcustom grep-ed-unload-new-buffers-after-changes t
  "*If non-nil, unload any new buffers that were created to make changes.
This variable will be ignored if `grep-ed-save-after-changes' is nil."
  :group 'grep-ed
  :type 'boolean)

;;;###autoload
(defcustom grep-ed-vc-checkout-function nil
  "*Function to checkout out version controlled files"
  :group 'grep-ed
  :type 'function)

;;;###autoload
(defcustom grep-ed-start-hook nil
  "*Hooks to run when grep-ed starts"
  :group 'grep-ed
  :type 'hook)

;;;###autoload
(defcustom grep-ed-exit-hook nil
  "*Hooks to run when grep-ed exits"
  :group 'grep-ed
  :type 'hook)

;; Private

(defvar grep-ed-orig-mode-line-status nil
  "Original mode line status")

(defvar grep-ed-buffers-loaded nil
  "Buffers grep-ed loaded to make changes")

(defvar grep-ed-buffers-modified nil
  "Buffers grep-ed has modified")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Functions

;;;###autoload
(defun grep-ed-start ()
  "Start grep-ed mode"
  (interactive)
  (toggle-read-only -1)
  ;; Narrow to just interesting part
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^[^ \t]+?:[0-9]+:\\([0-9]+:\\)?" nil t)
      (beginning-of-line)
      (narrow-to-region (point) (progn (forward-paragraph) (point)))))
  ;; Make all filename:line-num: non-editable
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[^ \t]+?:[0-9]+:\\([0-9]+:\\)?" nil t)
      (add-text-properties (match-beginning 0) (match-end 0)
                           (list 'intangible 'grep-ed
                                 'read-only t
                                 'front-sticky t
                                 'rear-nonsticky t))))
  ;; Get ready to edit
  (buffer-enable-undo)
  (highlight-changes-mode 1)
  (use-local-map grep-ed-mode-map)
  (setq grep-ed-orig-mode-line-status mode-line-process)
  (setq mode-line-process ":EDITING")
  (force-mode-line-update)
  (run-hooks 'grep-ed-start-hook))

(defun grep-ed-exit (&optional changes-saved)
  "Exit grep-ed mode"
  (interactive)
  (when (or changes-saved (grep-ed-ok-to-exit))
    (highlight-changes-mode -1)
    ;; Remove narrowing
    (widen)
    ;; Remove properties added by grep-ed-start
    (save-excursion
      (goto-char (point-min))
      (let ((inhibit-read-only t))
        (while (re-search-forward "^[^ \t]+?:[0-9]+:\\([0-9]+:\\)?" nil t)
          (remove-text-properties (match-beginning 0) (match-end 0)
                                  (list 'intangible 'grep-ed
                                        'read-only t
                                        'front-sticky t
                                        'rear-nonsticky t)))))
    ;; Reset buffer controls to what they were before grep-ed was started
    (toggle-read-only 1)
    (use-local-map grep-mode-map)
    (setq mode-line-process grep-ed-orig-mode-line-status)
    (force-mode-line-update)
    (run-hooks 'grep-ed-exit-hook)))

(defun grep-ed-ok-to-exit ()
  "Check if it's okay to exit"
  (let (unsaved-changes)
    (save-excursion
      (goto-char (point-min))
      (setq unsaved-changes (not (stringp (highlight-changes-next-change)))))
    (or (not unsaved-changes) (y-or-n-p "Unsaved changes, exit anyway "))))

(defun grep-ed-save-changes-and-exit ()
  "Save changes and exit"
  (interactive)
  (setq grep-ed-buffers-loaded nil)
  (setq grep-ed-buffers-modified nil)
  (save-excursion
    (goto-char (point-min))
    (let (prev-filename prev-line-num)
      ;; Go through all the changes
      (while (not (stringp (highlight-changes-next-change)))
        (save-excursion
          ;; Get file/line/text info
          (beginning-of-line)
          (when (looking-at "\\([^ \t]+?\\):\\([0-9]+\\):\\([0-9]+:\\)?\\(.*\\)$")
            (let ((filename (expand-file-name (match-string-no-properties 1)))
                  (line-num (string-to-number (match-string 2)))
                  (line-text (match-string-no-properties 4)))
              ;; If a line has multiple changes, only change it once
              (when (or (not (string= filename prev-filename))
                        (not (= line-num prev-line-num)))
                (setq prev-filename filename
                      prev-line-num line-num)
                (grep-ed-change-line filename line-num line-text))))))))
  ;; Done
  (grep-ed-cleanup-after-changes)
  (grep-ed-exit t)
  (message "Changes saved"))

(defun grep-ed-change-line (filename line-num line-text)
  "Change a line in a file"
  (save-excursion
    ;; Keep track of buffers grep-ed loads and/or modifies
    (let ((buf (find-buffer-visiting filename)))
      (unless buf
        (setq buf (find-file-noselect filename))
        (add-to-list 'grep-ed-buffers-loaded buf))
      (when grep-ed-vc-checkout-function
        (funcall grep-ed-vc-checkout-function filename))
      (add-to-list 'grep-ed-buffers-modified buf)
      (set-buffer buf))
    ;; Make the change
    (toggle-read-only -1)
    (goto-char (point-min))
    (forward-line (1- line-num))
    (let ((kill-whole-line nil))
      (kill-line))
    (insert line-text)))

(defun grep-ed-cleanup-after-changes ()
  "Cleanup after making changes"
  (when (and grep-ed-buffers-modified grep-ed-save-after-changes)
    (save-excursion
      (dolist (buf grep-ed-buffers-modified)
        (set-buffer buf)
        (save-buffer))
      (when (and grep-ed-buffers-loaded grep-ed-unload-new-buffers-after-changes)
        (mapc 'kill-buffer grep-ed-buffers-loaded))))
  (setq grep-ed-buffers-loaded nil)
  (setq grep-ed-buffers-modified nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Mode

(define-key grep-mode-map "\C-x\C-q" 'grep-ed-start)

(defvar grep-ed-mode-map (make-keymap) "'grep-ed-mode' keymap.")
(define-key grep-ed-mode-map "\C-x\C-q" 'grep-ed-exit)
(define-key grep-ed-mode-map "\C-x\C-s" 'grep-ed-save-changes-and-exit)

(provide 'grep-ed)
;;; grep-ed.el ends here
