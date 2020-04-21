;: archivo de configuracion inicial
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; PAQUETES
(setq package-list '(auto-complete web-mode emmet-mode ac-html ac-php multiple-cursors smartparens flx-ido git-gutter yasnippet neotree undo-tree which-key js2-mode ag helm-ag helm-projectile xclip use-package elpy flycheck rainbow-mode markdown-mode json-mode php-mode yasnippet-snippets))

;; VERIFICACION DE PAQUETES 
(unless package-archive-contents
  (package-refresh-contents))

;;install los paquetes perdidos
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))



;; ***************************** CONFIGURACION EMACS 26 ********************************


;;-----------------------------------theme-------------------------------------
;;(load-theme 'tango t)


;; INICIANDO CONFIGURACION INICIAL

(ac-config-default)


;;------------------------------------web-mode------------------------
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))


;; Customizations
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-disable-autocompletion t)
(local-set-key (kbd "RET") 'newline-and-indent)

;;------------------------------------emmet------------------------
(add-hook 'web-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook 'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'vue-mode-hook 'emmet-mode) ;; enable Emmet's css abbreviation.


;;------------------------------------ac-html------------------------
(add-hook 'web-mode-hook 'ac-html-enable)

;;------------------------------------ac-php------------------------
(add-hook 'php-mode-hook 'ac-php-mode)


;;------------------------------------multiple-cursors------------------------
(global-set-key (kbd "C-&") 'mc/mark-next-like-this)

;;----------------------------------- emmet expand line-----------------------
(global-set-key (kbd "C-j") 'emmet-expand-line)

;;-----------------------------------smartparens------------------------
(smartparens-global-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (neotree vue-mode all-the-icons smartparens multiple-cursors ac-php ac-html emmet-mode web-mode auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;------------------------------------duplicate-thing-line-or ------------------------
;;(global-set-key (kbd "M-c") 'duplicate-thing)
(defun duplicate-current-line-or-region (arg)
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

(global-set-key (kbd "M-c") 'duplicate-current-line-or-region)


;;------------------------------------flx-ido ------------------------
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)


;;------------------------------------git-gutter-------------------------
(global-git-gutter-mode t)

(global-set-key (kbd "C-x C-g") 'git-gutter)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)

;; Jump to next/previous hunk
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)

;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

;; Mark current hunk
(global-set-key (kbd "C-x v SPC") #'git-gutter:mark-hunk)

;;------------------------------------yasnipets------------------------
(add-to-list 'load-path
             "~/.emacs.d/elpa/yasnippet-snippets-0.5/snippets")
(yas-global-mode 1)

;;------------------------------------neotree------------------------
(global-set-key [f8] 'neotree-toggle)
;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))

;;------------------------------------undo-tree------------------------
(global-undo-tree-mode)

;;-------------------------------------which-key-----------------------
(which-key-mode)

;;------------------------------------config javascript --------------------------
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
(setq js-indent-level 2)


;;------------------------------------helm-projectile-ag------------------------
(global-set-key (kbd "C-x a") 'helm-projectile-ag)


;;------------------------------------elpy------------------------
(elpy-enable)

;;------------------------------------flycheck------------------------
(global-flycheck-mode)

;;------------------------------------xclip------------------------
;; copiar y pegar desde console
(xclip-mode 1)

;;------------------------------------proyectile------------------------
(helm-projectile-on)
(global-set-key (kbd "C-x f") 'helm-projectile-find-file)


;;------------------------------------ac-php------------------------
(add-hook 'php-mode-hook
            '(lambda ()
               (auto-complete-mode t)
               (require 'ac-php)
               (setq ac-sources  '(ac-source-php ) )
               (yas-global-mode 1)

               (ac-php-core-eldoc-setup ) ;; enable eldoc
               (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
               (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back)    ;go back
               ))

;;----------------------------------------configuracion para vue -----------
(add-hook 'web-mode-hook #'(lambda () (yas-activate-extra-mode 'js-mode)))
(add-hook 'web-mode-hook #'(lambda () (yas-activate-extra-mode 'js2-mode)))


;;------------------------------------configuracion editor------------------------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(setq make-backup-files nil)
(defun revert-buffer-no-confirm ()
  (interactive)
  (revert-buffer :ignore-auto :noconfirm))
;;javascript 2 espacios
;;(setq js-indet-level 2)
(add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))

;;parentesis
(show-paren-mode 1)
;;(require 'paren)
;;(set-face-background 'show-paren-match  "#8a8aff")
(set-face-foreground 'show-paren-match "#def")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold :foreground "#ff5")
;;revert automatico
(global-auto-revert-mode 1)
(xterm-mouse-mode t)

(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'next-buffer)

;;ignorando archivos silversearch
(add-to-list 'projectile-globally-ignored-directories "node_modules")
(add-to-list 'projectile-globally-ignored-directories "venv")


;; -------------mover una linea hacia abajo y hacia arriba---------------------
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;;----------------ocultando menus--------------
;;(tool-bar-mode -1)
;;(menu-bar-mode -1)

;;Created by Roy

;; helm

(add-to-list 'load-path "~/emacs.d/helm")
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
