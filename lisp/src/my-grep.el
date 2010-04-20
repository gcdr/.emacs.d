;;; my-grep.el

(require 'grep)

(setq-default grep-highlight-matches t
              grep-find-ignored-directories (list ".git" ".hg" ".bzr" ".svn")
              grep-files-aliases nil)

(grep-apply-setting 'grep-template "/bin/grep -nH -d skip -I -E -e <R> <C> <F>")
(grep-apply-setting 'grep-find-template "find <D> <X> -type f <F> -print0 | xargs -0 -e /bin/grep -nH -I -E -e <R> <C>")

(defun my-grep-setup-hook ()
  (setenv "TERM" "xterm-color"))

(add-hook 'grep-setup-hook 'my-grep-setup-hook)

(provide 'my-grep)