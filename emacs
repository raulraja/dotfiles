;; if you're new to the MELPA package manager, just include
;; this entire snippet in your `~/.emacs` file and follow
;; the instructions in the comments.
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(when (not package-archive-contents)
  (package-refresh-contents))

;; Restart emacs and do `M-x package-install [RETURN] ensime [RETURN]`
;; To keep up-to-date, do `M-x list-packages [RETURN] U x [RETURN]`

;; If necessary, make sure "sbt" and "scala" are in the PATH environment
;; (setenv "PATH" (concat "/path/to/sbt/bin:" (getenv "PATH")))
;; (setenv "PATH" (concat "/path/to/scala/bin:" (getenv "PATH")))
;;
;; On Macs, it might be a safer bet to use exec-path instead of PATH, for instance:
;; (setq exec-path (append exec-path '("/usr/local/bin")))

;; Ensime config

(use-package ensime
  :ensure t
  :pin melpa-stable)
(add-to-list 'exec-path "/usr/local/bin")
(add-hook 'scala-mode-hook 'ensime-mode)
(setq ensime-use-helm t)

;; (use-package company
;;   :diminish company-mode
;;   :commands company-mode
;;   :init
;;   (setq
;;    company-dabbrev-ignore-case nil
;;    company-dabbrev-code-ignore-case nil
;;    company-dabbrev-downcase nil
;;    company-idle-delay 0
;;    company-minimum-prefix-length 4)
;;   :config
;;   ;; disables TAB in company-mode, freeing it for yasnippet
;;   (define-key company-active-map [tab] nil)
;;   (define-key company-active-map (kbd "TAB") nil))

;; (use-package yasnippet
;;   :diminish yas-minor-mode
;;   :commands yas-minor-mode
;;   :config (yas-reload-all))

(use-package smartparens
  :diminish smartparens-mode
  :commands
  smartparens-strict-mode
  smartparens-mode
  sp-restrict-to-pairs-interactive
  sp-local-pair
  :init
  (setq sp-interactive-dwim t)
  :config
  (require 'smartparens-config)
  (sp-use-smartparens-bindings)

  (sp-pair "(" ")" :wrap "C-(") ;; how do people live without this?
  (sp-pair "[" "]" :wrap "s-[") ;; C-[ sends ESC
  (sp-pair "{" "}" :wrap "C-{")

  ;; WORKAROUND https://github.com/Fuco1/smartparens/issues/543
  (bind-key "C-<left>" nil smartparens-mode-map)
  (bind-key "C-<right>" nil smartparens-mode-map)

  (bind-key "s-<delete>" 'sp-kill-sexp smartparens-mode-map)
  (bind-key "s-<backspace>" 'sp-backward-kill-sexp smartparens-mode-map))

(add-hook 'scala-mode-hook
          (lambda ()
            (show-paren-mode)
            (smartparens-mode)
            (yas-minor-mode)
            (company-mode)
            (ensime-mode)
            (scala-mode:goto-start-of-code)))

(setq yas-snippet-dirs '("~/.emacs.d/snippets"))

;; OPTIONAL
;; there are some great Scala yasnippets, browse through:
;; https://github.com/AndreaCrotti/yasnippet-snippets/tree/master/scala-mode
;; (add-hook 'scala-mode-hook #'yas-minor-mode)
;; but company-mode / yasnippet conflict. Disable TAB in company-mode with
;; (define-key company-active-map [tab] nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(minimap-active-region-background ((t (:background "dim gray"))))
 '(minimap-font-face ((t (:height 0.5 :family "Pragmata Pro")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aggressive-indent-modes-to-prefer-defun
   (quote
    (emacs-lisp-mode lisp-mode scheme-mode clojure-mode scala-mode)))
 '(cua-mode t nil (cua-base))
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "b97a01622103266c1a26a032567e02d920b2c697ff69d40b7d9956821ab666cc" "fc1137ae841a32f8be689e0cfa07c872df252d48426a47f70dba65f5b0f88ac4" "3b2966850ef1b1ec941e0753ab5b02054de06d176f86268c2730bc49ec81931c" "3eb93cd9a0da0f3e86b5d932ac0e3b5f0f50de7a0b805d4eb1f67782e9eb67a4" "003a9aa9e4acb50001a006cfde61a6c3012d373c4763b48ceb9d523ceba66829" "cf284fac2a56d242ace50b6d2c438fcc6b4090137f1631e32bedf19495124600" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "224742c7512296b01bcdc353a49b3de3709f6f3d4e63042be1c2c347569c8c99" default)))
 '(inhibit-startup-screen "~/Documents/workspace")
 '(minimap-recreate-window nil)
 '(minimap-update-delay 0.4)
 '(minimap-window-location (quote right))
 '(neo-theme (quote nerd))
 '(save-place t nil (saveplace)))

(require 'desktop)
  (desktop-save-mode 1)
  (defun my-desktop-save ()
    (interactive)
    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
    (if (eq (desktop-owner) (emacs-pid))
        (desktop-save desktop-dirname)))
  (add-hook 'auto-save-hook 'my-desktop-save)

(projectile-global-mode)

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defconst my/babel-languages '(emacs-lisp sh js haskell clojure scala))

(org-babel-do-load-languages
  'org-babel-load-languages
  (mapcar (lambda (lang) (cons lang t)) my/babel-languages))

(setq org-confirm-babel-evaluate)
(setq org-src-fontify-natively t)
(org-display-inline-images)

;; Editor tweaks
(setq-default show-trailing-whitespace t)
(sublimity-mode 1)

(add-to-list 'load-path "~/.emacs.d/personal/preload/")
(load "pretty-pragmata.el")
(require 'sublimity)
(require 'sublimity-attractive)
(setq sublimity-attractive-centering-width nil)

(global-prettify-symbols-mode 1)
(setq prettify-symbols-unprettify-at-point 'right-edge)

(add-hook 'after-init-hook #'global-emojify-mode)

;; Scratch buffer msg
(setq initial-scratch-message ";; Knock yourself out!\n\n")

;; Themes
(load-theme 'dracula t)
(require 'spaceline-config)
(spaceline-spacemacs-theme)
(spaceline-helm-mode)

;; Disable bars
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(add-to-list 'default-frame-alist '(font . "PragmataPro 14" ))
(set-face-attribute 'default t :font "PragmataPro 14" )

;; show line numbers
(global-linum-mode 1)

;; Font size related
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C-=") 'text-scale-decrease)

;; Project navigation
(global-set-key (kbd "C-c 1") 'helm-projectile)
(global-set-key (kbd "C-c 2") 'helm-projectile-ag)

;; Ensime
(global-set-key (kbd "C-c e") 'ensime)
(global-set-key (kbd "C-c s") 'ensime-sbt)
(global-set-key (kbd "C-c i") 'ensime-import-type-at-point)
(global-set-key (kbd "C-c l") 'ensime-format-source)
(global-set-key (kbd "C-c t") 'ensime-inspect-type-at-point)

;; neotree
(setq-default neo-show-hidden-files t)

;; C-c p b  helm-projectile
;; C-c p b         switch-to-buffer	List all open buffers in current project
;; C-c p s s	helm-projectile-ag	Search with AG
;; C-c p f         find-file
;; C-c p F         find-file-in-known-projects
