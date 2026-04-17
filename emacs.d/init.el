;; ============================================================
;; init.el — VoidKrypt's Emacs config
;; ============================================================

;; ── 1. PACKAGE MANAGER ──────────────────────────────────────
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ── 2. UI CLEANUP ────────────────────────────────────────────
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)

;; ── 3. THEME ─────────────────────────────────────────────────
(use-package doom-themes
  :config
  (load-theme 'doom-one t))

;; ── 4. FONT ──────────────────────────────────────────────────
(set-face-attribute 'default nil
                    :family "JetBrains Mono"
                    :height 120
                    :weight 'normal)

;; Mu4e config load

(load (expand-file-name "mu4e-config.el" user-emacs-directory))

;; ── 6. MAGIT ─────────────────────────────────────────────────
(use-package magit
  :bind ("C-x g" . magit-status)
)


;;custom configs

;; ── Line Numbers ──────────────────────────────────────────
(global-display-line-numbers-mode 1)        ; show line numbers everywhere
;;(setq display-line-numbers-type 'relative)  ; relative nums (great for evil/vim motions)
;; Use 'absolute instead of 'relative if you prefer normal numbers

;; ── Basic Comfort ─────────────────────────────────────────
(column-number-mode 1)          ; show column in modeline
(size-indication-mode 1)        ; show file size in modeline
(global-hl-line-mode 1)         ; highlight current line
(show-paren-mode 1)             ; highlight matching parens
(electric-pair-mode 1)          ; auto-close brackets/quotes
(delete-selection-mode 1)       ; typing replaces selected text

;; ── Scrolling ─────────────────────────────────────────────
(setq scroll-conservatively 101         ; don't jump when scrolling
      scroll-margin 5)                  ; keep 5 lines above/below cursor

;; ── Editor Feel ───────────────────────────────────────────
(setq-default indent-tabs-mode nil      ; spaces, not tabs
              tab-width 4)
(setq require-final-newline t)          ; always end file with newline
