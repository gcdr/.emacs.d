;;; json-mode.el --- Major mode for editing JSON files

;; Copyright (C) 2011-2013 Josh Johnston

;; Author: Josh Johnston
;; URL: https://github.com/joshwnj/json-mode
;; Version: 1.2.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; extend the builtin js-mode's syntax highlighting

;;; Code:

(require 'js)
(require 'rx)
(require 'json-reformat)

(defconst json-mode-quoted-string-re
  (rx (group (char ?\")
             (zero-or-more (or (seq ?\\ ?\\)
                               (seq ?\\ ?\")
                               (seq ?\\ (not (any ?\" ?\\)))
                               (not (any ?\" ?\\))))
             (char ?\"))))
(defconst json-mode-quoted-key-re
  (rx (group (char ?\")
             (zero-or-more (or (seq ?\\ ?\\)
                               (seq ?\\ ?\")
                               (seq ?\\ (not (any ?\" ?\\)))
                               (not (any ?\" ?\\))))
             (char ?\"))
      (zero-or-more blank)
      ?\:))
(defconst json-mode-number-re (rx (group (one-or-more digit)
                                         (optional ?\. (one-or-more digit)))))
(defconst json-mode-keyword-re  (rx (group (or "true" "false" "null"))))

(defconst json-font-lock-keywords-1
  (list
   (list json-mode-quoted-key-re 1 font-lock-variable-name-face)
   (list json-mode-quoted-string-re 1 font-lock-string-face)
   (list json-mode-keyword-re 1 font-lock-constant-face)
   (list json-mode-number-re 1 font-lock-constant-face)
   )
  "Level one font lock.")

(defconst json-mode-beautify-command " -c \"import sys,json,collections; data=json.loads(sys.stdin.read(),object_pairs_hook=collections.OrderedDict); print json.dumps(data,sort_keys=%s,indent=4,separators=(',',': ')).decode('unicode_escape').encode('utf8','replace')\"")

;;;###autoload
(defun json-mode-beautify (&optional arg)
  "Beautify / pretty-print from BEG to END.
With prefix-arg sort the keys."
  (interactive "P")
  (require 'python)
  (shell-command-on-region (if (use-region-p) (region-beginning) (point-min))
                           (if (use-region-p) (region-end) (point-max))
                           (concat python-shell-interpreter (format json-mode-beautify-command (if arg "True" "False")))
                           (current-buffer) t))

;;;###autoload
(define-derived-mode json-mode javascript-mode "JSON"
  "Major mode for editing JSON files"
  (set (make-local-variable 'font-lock-defaults) '(json-font-lock-keywords-1 t)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))

;; (define-key json-mode-map (kbd "C-c C-r") 'json-mode-beautify)
(define-key json-mode-map (kbd "C-c C-r") 'json-reformat-region)

(provide 'json-mode)
;;; json-mode.el ends here
