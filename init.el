(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)

;;; Package Bootstrapping

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;; Base Emacs Settings

;(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'load-path (concat user-emacs-directory "packages/"))

(add-to-list 'exec-path "/usr/local/bin")

(set-default 'truncate-lines t)

;; Hide the startup splash screen
(setq inhibit-startup-message t)

;; Removes scratch message
(setq initial-scratch-message nil)
(setq initial-major-mode 'text-mode)

;; Turn off annoying system bell
(setq ring-bell-function 'ignore)

;; Write backups to the backup directory in emacs.d
(setq backup-directory-alist
      `(("." . ,(expand-file-name
		 (concat user-emacs-directory "backups")))))

;; Fix empty pasteboard error
(setq save-interprogram-paste-before-kill nil)


;; Full path in frame title
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

;; Auto-refresh buffers when edits occur outside emacs
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Show keystrokes in progress
(setq echo-keystrokes 0.1)

;; Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Transparently open compress files
(auto-compression-mode t)

;; Replace 'yes-or-no' with 'y-or-n'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Use UTF-8 by default
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)


(show-paren-mode 1)

;; Remove text in selection when inserting text
(delete-selection-mode 1)

;; Always display line and column numbers
(setq line-number-mode t)
(setq column-number-mode t)
(setq linum-format " %3d ")

(setq transient-mark-mode t)

;; Lines should be 80 characters wide, not 72 ???
(setq fill-column 80)

;; Smooth scroll (one line at a time)
(setq mouse-wheel-scroll-amount '(1 ((shift) .1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 15)

;; Nicer scrolling with mouse wheel/trackpad.
;; From Graphene
(unless (and (boundp 'mac-mouse-wheel-smooth-scroll) mac-mouse-wheel-smooth-scroll)
  (global-set-key [wheel-down] (lambda () (interactive) (scroll-up-command 1)))
  (global-set-key [wheel-up] (lambda () (interactive) (scroll-down-command 1)))
  (global-set-key [double-wheel-down] (lambda () (interactive) (scroll-up-command 2)))
  (global-set-key [double-wheel-up] (lambda () (interactive) (scroll-down-command 2)))
  (global-set-key [triple-wheel-down] (lambda () (interactive) (scroll-up-command 4)))
  (global-set-key [triple-wheel-up] (lambda () (interactive) (scroll-down-command 4))))

;; Scroll one line when hitting bottom of window
(setq scroll-conservatively 10000)

;; Change cursor
(setq-default cursor-type 'box)
(blink-cursor-mode -1)

;; Do not insert tabs
(set-default 'indent-tabs-mode nil)

;; Navigate camelcase words
(global-subword-mode 1)

;; Turn off word wrap
(setq-default truncate-lines t)

;; Remove double space at end of sentence
(set-default 'sentence-end-double-space nil)

(global-auto-revert-mode t)
(global-linum-mode t)
(global-visual-line-mode t)

;; Window Mangagement

(global-set-key (kbd "s-]") 'enlarge-window-horizontally)
(global-set-key (kbd "s-[") 'shrink-window-horizontally)
(global-set-key (kbd "s-}") 'enlarge-window)
(global-set-key (kbd "s-{") 'shrink-window)

;;; Small Packages

(use-package saveplace
  :ensure t
  :config
  (setq-default save-place t)
  (setq save-place-file (expand-file-name "places" user-emacs-directory)))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :bind
  (("s-u" . undo-tree-visualize)
   ("s-z" . undo)
   ("s-Z" . undo-tree-redo))
  :config
  (global-undo-tree-mode t)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t))

(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0.125)
  (setq company-minimum-prefix-length 1))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode t))

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode t)
  (show-smartparens-global-mode t)
  (setq show-paren-style 'expression))

(use-package diminish
  :ensure t)

(use-package multiple-cursors
  :ensure t
  :bind
   (("C-c m t" . mc/mark-all-like-this)
    ("C-c m m" . mc/mark-all-like-this-dwim)
    ("C-c m l" . mc/edit-lines)
    ("C-c m e" . mc/edit-ends-of-lines)
    ("C-c m a" . mc/edit-beginnings-of-lines)
    ("C-c m n" . mc/mark-next-like-this)
    ("C-c m p" . mc/mark-previous-like-this)
    ("C-c m s" . mc/mark-sgml-tag-pair)
    ("C-c m d" . mc/mark-all-like-this-in-defun)))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode) 
  ;; Ignore dirs 
  (setq projectile-globally-ignored-directories
        (append projectile-globally-ignored-directories '(".git" "out" "node_modules" "bower_components"))))

(use-package helm-projectile
  :ensure t)

(use-package helm-swoop
  :ensure t
  :bind
  (("C-S-s" . helm-swoop)
   ("M-i" . helm-swoop)
   ("M-I" . helm-swoop-back-to-last-point)))

(use-package windmove
  :bind
  (("C-<right>" . windmove-right)
   ("C-<left>" . windmove-left)
   ("C-<up>" . windmove-up)
   ("C-<down>" . windmove-down)))


;;; Org mode

(use-package org
  :ensure t
  :config
  (setq org-log-done t)
  (setq org-support-shift-select t)
  (setq org-default-notes-file "~/notes.org")
  (define-key global-map (kbd "C-c C-c") 'org-capture)
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %?\nEntered on %U\n  %i\n  %a")))
  )

;;; Helm

(use-package helm
  :ensure t
  :diminish helm-mode
  :config
  (require 'helm-config)
  (helm-mode t)

  ;; __Fuzzers__

  (setq helm-M-x-fuzzy-match        t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match    t
        helm-semantic-fuzzy-match   t
        helm-imenu-fuzzy-match      t)

  ;; From https://gist.github.com/antifuchs/9238468
  (setq helm-idle-delay 0.0             ; update fast sources immediately (doesn't).
        helm-input-idle-delay 0.01      ; this actually updates things
                                        ; reeeelatively quickly.
        helm-quick-update t
        helm-M-x-requires-pattern nil
        helm-ff-skip-boring-files t)

  ;; __Keybindings__

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "<enter>") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z

  (setq helm-split-window-in-side-p t)

  (global-unset-key (kbd "C-x c")) ; Remove the default helm key

  (global-set-key (kbd "s-h") 'helm-command-prefix)

  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "s-;") 'helm-M-x)

  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "s-y") 'helm-show-kill-ring)

  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "s-b")   'helm-mini)

  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "s-f")     'helm-find-files)

  (global-set-key (kbd "C-s") 'helm-occur)

  (global-set-key (kbd "s-p") 'helm-projectile))

;;; Package modes

(use-package cider
  :ensure t
  :config
  (cider-mode t)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (setq cider-repl-use-pretty-printing t)
  (setq cider-repl-use-clojure-font-lock t)
  (setq cider-show-error-buffer nil)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode))

(use-package clojure-mode
  :ensure t
  :config
  (define-clojure-indent
    (defroutes 'defun)
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (HEAD 2)
    (ANY 2)
    (context 2)
    (fact 1)))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.avsc\\'" . web-mode))
  (setq web-mode-content-types-alist
        '(("json"    . "\\.json\\'")
          ("json"    . "\\.avsc\\'"))))

(use-package markdown-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

;;; Aliases
(defalias 'ff        'helm-findfiles)
(defalias 'files     'helm-findes)
(defalias 'imenu     'helm-semantic-or-imenu)
(defalias 'paste     'helm-show-kill-ring)
(defalias 'resume    'helm-resume)
(defalias 'search    'helm-occur)
(defalias 'clipboard 'helm-show-kill-ring)
(defalias 'comment   'comment-or-uncomment-region)
(defalias 'start     'beginning-of-line)
(defalias 'begin     'back-to-indentation)
(defalias 'errors    'flycheck-list-errors)
(defalias 'repl      'cider-jack-in)
(defalias 'repl      'cider)
(defalias 'kill      'kill-buffer)

;;; Shortcuts

(windmove-default-keybindings 'meta)
(global-set-key (kbd "S-<tab>")   'delete-indentation)
(global-set-key (kbd "s-/")       'comment-or-uncomment-region)
(global-set-key (kbd "s-w")       'kill-buffer)
(global-set-key (kbd "s-q")       'save-buffers-kill-terminal)

;;; Navigation

(global-set-key (kbd "s-<up>")      'backward-paragraph)
(global-set-key (kbd "s-<down>")    'forward-paragraph)
(global-set-key (kbd "s-<right>")   'end-of-line)
(global-set-key (kbd "s-<left>")   'beginning-of-line)
(global-set-key (kbd "M-<up>") 'backward-sexp)
(global-set-key (kbd "M-<down>")  'forward-sexp)
(global-set-key (kbd "M-<right>")    'right-word)
(global-set-key (kbd "M-<left>")  'left-word)

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)

;;;; Fonts
(add-to-list 'default-frame-alist '(font . "Source Code Pro-15"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (imenu+ imenu-anywhere multiple-cursors helm-swoop helm-projectile projectile elisp--witness--lisp markdown-mode web-mode cider helm smartparens rainbow-delimiters flycheck company undo-tree use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
