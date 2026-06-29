;; Init the package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(setq use-package-always-ensure t)
(require 'use-package)

;; Basics
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)
(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(winner-mode 1)

;; Theme
(load-theme 'modus-vivendi t)

;; Packages
(use-package magit)

(use-package which-key
  :config
  (which-key-mode))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

(use-package evil
  :init
  (setq evil-want-integration t
	evil-want-keybinding nil
	evil-search-module 'evil-search
	evil-vsplit-window-right t
	evil-split-window-below t
	evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))


;; Bindings
(define-prefix-command 'atred/leader-map)
(define-key evil-normal-state-map (kbd "SPC") 'atred/leader-map)
(define-key evil-visual-state-map (kbd "SPC") 'atred/leader-map)
(define-key evil-motion-state-map (kbd "SPC") 'atred/leader-map)
(global-set-key (kbd "M-SPC") 'atred/leader-map)
 
;; SPC SPC = M-x, Doom-style
(define-key atred/leader-map (kbd "SPC") 'execute-extended-command)

(which-key-add-key-based-replacements
  "SPC f" "file"   "SPC b" "buffer" "SPC w" "window"
  "SPC p" "project" "SPC s" "search" "SPC g" "git"
  "SPC c" "code"   "SPC t" "toggle" "SPC h" "help"
  "SPC q" "quit/session" "SPC n" "notes")


(define-prefix-command 'atred/file-map)
(define-key atred/leader-map (kbd "f") 'atred/file-map)
 
(define-key atred/file-map (kbd "f") 'find-file)
(define-key atred/file-map (kbd "r") 'recentf-open-files)   ; needs recentf-mode on
(define-key atred/file-map (kbd "s") 'save-buffer)
(define-key atred/file-map (kbd "S") 'write-file)           ; save-as
(define-key atred/file-map (kbd "D")
  (lambda () (interactive)
    (when (yes-or-no-p (format "Delete %s? " (buffer-file-name)))
      (delete-file (buffer-file-name))
      (kill-buffer))))
(define-key atred/file-map (kbd "R")
  (lambda (new-name) (interactive "sNew name: ")
    (let ((f (buffer-file-name)))
      (rename-file f new-name 1)
      (set-visited-file-name new-name t t))))
(define-key atred/file-map (kbd "y")
  (lambda () (interactive) (kill-new (buffer-file-name))
    (message "Copied: %s" (buffer-file-name))))
(define-key atred/file-map (kbd "e d") (lambda () (interactive) (find-file user-init-file)))
(define-key atred/file-map (kbd "p") (lambda () (interactive) (find-file "~/.emacs.d/")))

(define-prefix-command 'atred/buffer-map)
(define-key atred/leader-map (kbd "b") 'atred/buffer-map)
 
(define-key atred/buffer-map (kbd "b") 'switch-to-buffer)
(define-key atred/buffer-map (kbd "B") 'ibuffer)
(define-key atred/buffer-map (kbd "d") 'kill-current-buffer)
(define-key atred/buffer-map (kbd "D") 'kill-buffer)
(define-key atred/buffer-map (kbd "n") 'next-buffer)
(define-key atred/buffer-map (kbd "p") 'previous-buffer)
(define-key atred/buffer-map (kbd "r") 'revert-buffer)
(define-key atred/buffer-map (kbd "k") 'kill-current-buffer)

(define-prefix-command 'atred/window-map)
(define-key atred/leader-map (kbd "w") 'atred/window-map)
 
(define-key atred/window-map (kbd "d") 'evil-window-delete)
(define-key atred/window-map (kbd "D") 'evil-window-delete)
(define-key atred/window-map (kbd "s") 'evil-window-split)
(define-key atred/window-map (kbd "v") 'evil-window-vsplit)
(define-key atred/window-map (kbd "w") 'evil-window-next)
(define-key atred/window-map (kbd "W") 'evil-window-prev)
(define-key atred/window-map (kbd "h") 'evil-window-left)
(define-key atred/window-map (kbd "j") 'evil-window-down)
(define-key atred/window-map (kbd "k") 'evil-window-up)
(define-key atred/window-map (kbd "l") 'evil-window-right)
(define-key atred/window-map (kbd "=") 'balance-windows)
(define-key atred/window-map (kbd "m") 'delete-other-windows)
(define-key atred/window-map (kbd "o") 'delete-other-windows)
(define-key atred/window-map (kbd "u") 'winner-undo)
(define-key atred/window-map (kbd "U") 'winner-redo)
(define-key atred/window-map (kbd "r") 'evil-window-rotate-downwards)


(define-prefix-command 'atred/project-map)
(define-key atred/leader-map (kbd "p") 'atred/project-map)
 
(define-key atred/project-map (kbd "p") 'project-switch-project)
(define-key atred/project-map (kbd "f") 'project-find-file)
(define-key atred/project-map (kbd "b") 'project-switch-to-buffer)
(define-key atred/project-map (kbd "d") 'project-find-dir)
(define-key atred/project-map (kbd "g") 'project-find-regexp)
(define-key atred/project-map (kbd "k") 'project-kill-buffers)
(define-key atred/project-map (kbd "c") 'project-compile)
(define-key atred/project-map (kbd "e") 'project-eshell)


(define-prefix-command 'atred/search-map)
(define-key atred/leader-map (kbd "s") 'atred/search-map)
 
(define-key atred/search-map (kbd "s") 'isearch-forward)
(define-key atred/search-map (kbd "S") 'isearch-backward)
(define-key atred/search-map (kbd "g") 'rgrep)
(define-key atred/search-map (kbd "i") 'imenu)
(define-key atred/search-map (kbd "m") 'evil-show-marks)


(define-prefix-command 'atred/git-map)
(define-key atred/leader-map (kbd "g") 'atred/git-map)
 
(define-key atred/git-map (kbd "g") 'magit-status)
(define-key atred/git-map (kbd "s") 'magit-status)
(define-key atred/git-map (kbd "b") 'magit-branch-checkout)
(define-key atred/git-map (kbd "B") 'magit-blame)
(define-key atred/git-map (kbd "c") 'magit-commit)
(define-key atred/git-map (kbd "C") 'magit-clone)
(define-key atred/git-map (kbd "d") 'magit-diff-buffer-file)
(define-key atred/git-map (kbd "D") 'magit-diff)
(define-key atred/git-map (kbd "f") 'magit-fetch)
(define-key atred/git-map (kbd "F") 'magit-pull)
(define-key atred/git-map (kbd "l") 'magit-log-current)
(define-key atred/git-map (kbd "L") 'magit-log-buffer-file)
(define-key atred/git-map (kbd "P") 'magit-push)
(define-key atred/git-map (kbd "r") 'magit-rebase)
(define-key atred/git-map (kbd "S") 'magit-stage-file)
(define-key atred/git-map (kbd "U") 'magit-unstage-file)


(define-prefix-command 'atred/code-map)
(define-key atred/leader-map (kbd "c") 'atred/code-map)
 
(define-key atred/code-map (kbd "c") 'compile)
(define-key atred/code-map (kbd "C") 'recompile)
(define-key atred/code-map (kbd "d") 'xref-find-definitions)  ; built-in, no LSP needed
(define-key atred/code-map (kbd "D") 'xref-find-references)
(define-key atred/code-map (kbd "r") 'eval-region)
(define-key atred/code-map (kbd "e") 'eval-last-sexp)
(define-key atred/code-map (kbd "=") 'indent-region)


(define-prefix-command 'atred/toggle-map)
(define-key atred/leader-map (kbd "t") 'atred/toggle-map)
 
(define-key atred/toggle-map (kbd "l") 'display-line-numbers-mode)
(define-key atred/toggle-map (kbd "w") 'visual-line-mode)
(define-key atred/toggle-map (kbd "f") 'auto-fill-mode)
(define-key atred/toggle-map (kbd "t") 'toggle-truncate-lines)
(define-key atred/toggle-map (kbd "s") 'flyspell-mode)
(define-key atred/toggle-map (kbd "F") 'toggle-frame-fullscreen)

(define-prefix-command 'atred/help-map)
(define-key atred/leader-map (kbd "h") 'atred/help-map)
 
(define-key atred/help-map (kbd "f") 'describe-function)
(define-key atred/help-map (kbd "v") 'describe-variable)
(define-key atred/help-map (kbd "k") 'describe-key)
(define-key atred/help-map (kbd "m") 'describe-mode)
(define-key atred/help-map (kbd "b") 'describe-bindings)
(define-key atred/help-map (kbd "p") 'describe-package)
(define-key atred/help-map (kbd "i") 'info)


(define-prefix-command 'atred/quit-map)
(define-key atred/leader-map (kbd "q") 'atred/quit-map)
 
(define-key atred/quit-map (kbd "q") 'save-buffers-kill-terminal)
(define-key atred/quit-map (kbd "Q") 'kill-emacs)
(define-key atred/quit-map (kbd "f") 'delete-frame)


(define-prefix-command 'atred/notes-map)
(define-key atred/leader-map (kbd "n") 'atred/notes-map)
 
(define-key atred/notes-map (kbd "a") 'org-agenda)
(define-key atred/notes-map (kbd "c") 'org-capture)
(define-key atred/notes-map (kbd "l") 'org-store-link)
(define-key atred/notes-map (kbd "t") 'org-todo-list)


;; -------------------------------------------------------------------

;; Managed by emacs, do not edit
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
