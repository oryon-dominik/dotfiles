(require 'package)

;; check ssl capabilities
(let* (
  (no-ssl ( and (memq system-type '(windows-nt ms-dos)) 
                (not (gnutls-available-p))
          )
  )
  (proto (if no-ssl "http" "https"))
  )
  (when no-ssl (warn "\Your version of Emacs does not support SSL connections,
    which is unsafe because it allows man-in-the-middle attacks. There are two
    things you can do about this warning: 1. Install an Emacs version that does
    support SSL and be safe. 2. Remove this warning from your init file so you
    won't see it again."
  )
)

;; MELPA
(add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
)

; list the packages you want to be installed automatically
(setq package-list '(dracula-theme))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; PACKAGE-INITILIZE
(package-initialize)

;; refresh the packages-list
; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (dracula)))
 '(custom-safe-themes
   (quote
    ("55c2069e99ea18e4751bd5331b245a2752a808e91e09ccec16eb25dadbe06354" default)))
 '(package-selected-packages
   (quote
    (dracula-theme org darkroom buffer-expose python ## gnu-elpa-keyring-update)))
 '(scroll-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)

;; window size
(add-to-list 'default-frame-alist '(height . 42))
(add-to-list 'default-frame-alist '(width . 160))

;; org-mode settings
(setq auto-mode-alist
  '(
    ("\\.org$" . org-mode)
))
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
(setq org-duration-format (quote h:mm))
