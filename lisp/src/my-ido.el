;;; my-ido.el

(require 'ido)
(require 'my-bs)
(require 'bookmark)
(require 'recentf)
(require 'imenu)
(require 'etags)

(ido-mode 1)

(setq ido-enable-flex-matching t
      ido-ignore-extensions t
      ido-max-dir-file-cache 0
      ido-max-directory-size 300000
      ido-max-prospects 10
      ido-enable-tramp-completion nil
      ido-decorations '("{" "}" ", " ", ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]")
      ido-enter-matching-directory 'first
      ido-auto-merge-work-directories-length -1
      ido-ignore-buffers '(my-bs-ignore-buffer))

;; ido + bookmarks

(defvar my-ido-doing-bookmark-dir nil)
(defvar my-ido-exiting-with-slash nil)

(defun my-ido-bookmark-jump ()
  "Jump to bookmark using ido"
  (interactive)
  (let ((dir (my-ido-get-bookmark-dir)))
    (when dir
      (setq my-dired-prev-dir (dired-current-directory))
      (find-alternate-file (if my-ido-exiting-with-slash
                               (ido-read-directory-name "Jump to dir: " dir nil t)
                             dir)))))

(defun my-ido-get-bookmark-dir ()
  "Get the directory of a bookmark."
  (let* ((my-ido-doing-bookmark-dir t)
         (name (ido-completing-read "Use dir of bookmark: " (bookmark-all-names) nil t))
         (bmk (bookmark-get-bookmark name)))
    (when bmk
      (setq bookmark-alist (delete bmk bookmark-alist))
      (push bmk bookmark-alist)
      (let ((filename (bookmark-get-filename bmk)))
        (if (file-directory-p filename)
            filename
          (file-name-directory filename))))))

(defun my-ido-dired-mode-hook ()
  (define-key dired-mode-map "$" 'my-ido-bookmark-jump))

(add-hook 'dired-mode-hook 'my-ido-dired-mode-hook)

(defun my-ido-use-bookmark-dir ()
  "Get directory of bookmark"
  (interactive)
  (let* ((enable-recursive-minibuffers t)
         (dir (my-ido-get-bookmark-dir)))
    (when dir
      (ido-set-current-directory dir)
      (setq ido-exit 'refresh)
      (exit-minibuffer))))

(defadvice ido-init-completion-maps (after my-ido-init-map activate)
  (define-key ido-common-completion-map (kbd "$") 'my-ido-use-bookmark-dir))
(ido-init-completion-maps) ;; For pre-23.3 Emacs

(defadvice ido-setup-completion-map (after my-ido-bookmark-dir-map activate)
  (when my-ido-doing-bookmark-dir
    (let ((map (make-sparse-keymap)))
      (setq my-ido-exiting-with-slash nil)
      (define-key map "/" 'my-ido-exit-minibuffer-with-slash)
      (set-keymap-parent map ido-common-completion-map)
      (setq ido-completion-map map))))

(defun my-ido-exit-minibuffer-with-slash ()
  "Exited finding a bookmark dir with slash."
  (interactive)
  (setq my-ido-exiting-with-slash t)
  (ido-exit-minibuffer))

;; (defun ido-final-slash (dir &optional fix-it)
;;   (if fix-it
;;       (concat dir "/")
;;     (if (not my-ido-exiting-with-slash)
;;         t
;;       (setq dir (ido-name dir))
;;       (cond
;;        ((string-match "/\\'" dir) dir)
;;        ((ido-is-tramp-root dir) dir)
;;        (t nil)))))

;; ido + recentf

(defvar my-ido-doing-recentf nil)

(defun my-ido-recentf-file ()
  "Find a file in the recently opened file list using ido"
  (interactive)
  (let* ((my-ido-doing-recentf t)
         (ido-current-directory nil)
         (ido-directory-nonreadable nil)
         (ido-directory-too-big nil)
         (ido-context-switch-command 'my-ido-recentf-file-fallback-command)
         (file-alist (mapcar (lambda (x) (cons (file-name-nondirectory x) x)) recentf-list))
         (ido-choice-list (delete-dups (mapcar 'car file-alist)))
         (filename (ido-read-internal 'list "Find recent file: " nil nil t nil))
         (result-list (delq nil (mapcar (lambda (x) (when (string= (car x) filename) (cdr x))) file-alist)))
         (result-length (length result-list)))
    (if (and filename (not (string= filename "")))
        (find-file
         (cond
          ((= result-length 0) filename)
          ((= result-length 1) (car result-list))
          (t (ido-completing-read "Multiple matches: " result-list nil t))))
      (ido-find-file))))

(defun my-ido-recentf-file-fallback-command ()
  "Exit ido cleanly."
  (interactive)
  (setq ido-exit 'fallback)
  (exit-minibuffer))

(defadvice ido-setup-completion-map (after my-ido-recentf-map activate)
  (when my-ido-doing-recentf
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "C-k") 'my-ido-recentf-remove-file-at-head)
      (set-keymap-parent map ido-common-completion-map)
      (setq ido-completion-map map))))

(defun my-ido-recentf-remove-file-at-head ()
  "Remove the file at the head of `ido-matches' from the recentf list."
  (interactive)
  (if (not (eobp))
      (delete-region (point) (line-end-position))
    (let ((enable-recursive-minibuffers t)
          (filename (ido-name (car ido-matches))))
      (when filename
        (setq recentf-list (delq t (mapcar (lambda (x) (or (string= x filename)
                                                           (string= (file-name-nondirectory x) filename)
                                                           x)) recentf-list)))
        (setq ido-cur-list (delq filename ido-cur-list))))))

;; ido + imenu

(defvar my-ido-imenu-prefix-symbols nil
  "*Prefix symbols with their menu drill-downs.")
(make-local-variable 'my-ido-imenu-prefix-symbols)

(defun my-ido-imenu-add-symbols (prefix symbols result)
  (when (listp symbols)
    (dolist (symbol symbols)
      (cond ((and (listp symbol) (imenu--subalist-p symbol))
             (setq result (my-ido-imenu-add-symbols (if my-ido-imenu-prefix-symbols
                                                        (concat prefix (car symbol) " > ")
                                                      "") symbol result)))
            ((listp symbol)
             (push (cons (concat (when my-ido-imenu-prefix-symbols prefix) (car symbol)) (cdr symbol)) result))
            ((stringp symbol)
             (let ((pos (get-text-property 1 'org-imenu-marker symbol)))
               (when pos
                 (push (cons (concat (when my-ido-imenu-prefix-symbols prefix) symbol) pos) result)))))))
  result)

(defun my-ido-imenu-goto-symbol ()
  "Goto to an imenu symbol using ido"
  (interactive)
  (imenu--make-index-alist)
  (let ((items nil)
        (guess (concat "\\(.+::\\)?"
                       (buffer-substring-no-properties
                        (save-excursion (skip-syntax-backward "w_") (point))
                        (save-excursion (skip-syntax-forward "w_") (point))))))
    (setq items (nreverse (my-ido-imenu-add-symbols nil imenu--index-alist items)))
    (catch 'done
      (dotimes (idx (length items))
        (if (string-match guess (caar items))
            (throw 'done t)
          (when (cdr items)
            (setq items (nconc (cdr items) (list (car items))))))))
    (let ((pos (cdr (assoc (ido-completing-read "Goto symbol: " (mapcar 'car items) nil t) items))))
      (when pos
        (goto-char pos)))))

;; ido + tags

(defun my-ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (dolist (tag tags-completion-table)
      (unless (integerp tag)
        (push (prin1-to-string tag t) tag-names)))
    (find-tag (ido-completing-read "Tag: " tag-names nil t))))

;; Better matching

(defun my-ido-fuzzy-match (str items)
  "Better ido fuzzy matching"
  (let ((str-len (length str)))
    (if (= str-len 0)
        (reverse items)
      (let ((char-lookup (make-hash-table :test 'equal)))
        ;; Make hash table of all characters with their corresponding indexes
        (let ((chars (split-string (if ido-case-fold (downcase str) str) "" t))
              (idx 0)
              elt)
          (dolist (char chars)
            (setq elt (gethash char char-lookup))
            (if elt
                (push idx elt) ;; It's important that the indexes are in descending order
              (setq elt (list idx)))
            (puthash char elt char-lookup)
            (setq idx (1+ idx))))
        ;; Go through all the items
        (let (corr matches)
          (dolist (item items)
            (setq corr (my-ido-match-get-correlation str-len char-lookup (ido-name item)))
            (when corr
              (push (cons item corr) matches)))
          ;; Sort matches and return
          (mapcar 'car (if ido-rotate
                           matches
                         (sort matches (lambda (x y) (> (cdr x) (cdr y)))))))))))

(defun my-ido-match-get-correlation (str-len char-lookup item)
  "Get the correlation for this item"
  (let ((partial-matches (make-vector str-len nil))
        (chars (split-string (if ido-case-fold (downcase item) item) "" t))
        (char-idx 0)
        elt-idxs corr prev-partial-match curr-partial-match)
    (dolist (char chars)
      (setq elt-idxs (gethash char char-lookup))
      (when elt-idxs
        (dolist (elt-idx elt-idxs)
          ;; Current and previous partial matches
          (setq curr-partial-match (aref partial-matches elt-idx))
          (setq prev-partial-match (and (> elt-idx 0)
                                        (aref partial-matches (1- elt-idx))))
          ;; Create a new partial match if necessary
          (when (and (not curr-partial-match)
                     (or prev-partial-match (= elt-idx 0)))
            (setq curr-partial-match
                  (aset partial-matches elt-idx
                        (cons char-idx (if (and (= elt-idx 0) (= char-idx 0)) 1 0)))))
          ;; Set (match-position . correlation)
          (when curr-partial-match
            (setcar curr-partial-match char-idx)
            (when prev-partial-match
              (setcdr curr-partial-match
                      (if (= char-idx (1+ (car prev-partial-match)))
                          (1+ (cdr prev-partial-match))
                        (cdr prev-partial-match))))
            ;; Update final correlation
            (when (= elt-idx (1- str-len))
              (if corr
                  (setq corr (max corr (cdr curr-partial-match)))
                (setq corr (cdr curr-partial-match)))))))
      (setq char-idx (1+ char-idx)))
    corr))

(defvar my-ido-use-fuzzy-match t
  "*Use my-ido-fuzzy-match for ido matching")

(defadvice ido-set-matches-1 (around my-ido-set-matches-1 activate)
  "Choose between the regular ido-set-matches-1 and my-ido-fuzzy-match"
  (if my-ido-use-fuzzy-match
      (setq ad-return-value (my-ido-fuzzy-match ido-text (ad-get-arg 0)))
    ad-do-it))

;; Better editing of input

(defun my-ido-edit-input ()
  "Edit filename, terminate with RET.
If cursor is not at the end of the user input, move to end of input."
  (interactive)
  (if (not (eobp))
      (end-of-line)
    (setq ido-current-directory (concat (abbreviate-file-name ido-current-directory) ido-text))
    (setq ido-text "")
    (setq ido-exit 'edit)
    (exit-minibuffer)))

;; Hook

(defun my-ido-setup-hook ()
  "Add my keybindings for ido."
  (define-key (cdr ido-minor-mode-map-entry) [remap kill-buffer] nil)
  (define-key ido-completion-map (kbd "C-e") 'my-ido-edit-input)
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
  (define-key ido-completion-map (kbd "C-t") 'ido-toggle-case))

(add-hook 'ido-setup-hook 'my-ido-setup-hook)

(provide 'my-ido)
