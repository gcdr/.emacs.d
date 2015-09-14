;; init.el

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 0))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode 0))
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

(add-to-list 'load-path (concat user-emacs-directory "lisp"))
(add-to-list 'load-path (concat user-emacs-directory "lisp/company-mode"))
(add-to-list 'load-path (concat user-emacs-directory "lisp/org"))

(setq-default tramp-mode nil)

(require 'package)
(package-initialize)

(require 'my-init)
