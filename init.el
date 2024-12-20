;; init.el --- Emacs configuration

;; Set OSX function key as Meta

(defun my-scroll-up-by-line ()
  "Scroll up one line."
  (interactive)
  (scroll-up-command 1))

(defun my-scroll-down-1-line ()
  "Scroll down one line."
  (interactive)
  (scroll-down-command 1))

;; Reversing up and down gives the expected behaviour
(global-set-key (kbd "C-x <up>") 'my-scroll-down-1-line)
(global-set-key (kbd "C-x <down>") 'my-scroll-up-by-line)

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; activate all packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; define list of packages to install
(defvar myPackages
  '(better-defaults
    material-theme
    exec-path-from-shell
    elpy
    pyenv-mode))

;; install all packages in list
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; Use shell's $PATH
(exec-path-from-shell-copy-env "PATH")

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t)   ;; hide the startup message
(load-theme 'material t)           ;; load material theme
;; display line numbers in programming modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; Allow hash to be entered
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

;;; NOTE conda is needed to set anaconda virtual environment python process.
;;; Elpy can set the anaconda virtual env, but not the process. conda uses
;;; environment.yml (I think to find the process).
(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home (expand-file-name "~/anaconda3"))
  :config
  ;; If you want interactive shell support, include:
  (conda-env-initialize-interactive-shells)
  ;; If you want eshell support, include:
  (conda-env-initialize-eshell)
  ;; If you want auto-activation, include:
  (conda-env-autoactivate-mode t)
  ;; Activate the project/virtual env you want to use.
  ;; Via M-x conda-env-activate RET my-env
  ;; or
  ;; (conda-env-activate "my-env")
  )

;; Set path to Python interpreter for RPC backend
(setq elpy-rpc-python-command "~/anaconda3/bin/python")

(elpy-enable)
;;(pyenv-mode)
(when (executable-find "ipython")
    (setq python-shell-interpreter "ipython"
          python-shell-interpreter-args "-i --simple-prompt"))

;; Google style docstrings
(defun set-python-keybindings ()
  (local-set-key (kbd "C-c i") 'python-insert-docstring-with-google-style-at-point)
  )
(add-hook 'python-mode-hook 'set-python-keybindings)

;; Define key binding for stepping through code
(eval-after-load "elpy"
  #'(define-key elpy-mode-map (kbd "C-c RET") 'elpy-shell-send-group-and-step))

(with-eval-after-load 'prog-mode
    (with-eval-after-load 'flymake
        (define-key prog-mode-map (kbd "M-n") 'flymake-goto-next-error)
        (define-key prog-mode-map (kbd "M-p") 'flymake-goto-prev-error))
    (with-eval-after-load 'flycheck
        (define-key prog-mode-map (kbd "M-n") 'flycheck-next-error)
        (define-key prog-mode-map (kbd "M-p") 'flycheck-previous-error)))

;; Enable better defaults
(require 'better-defaults)

;; Show dot for current directory
;;(setq ido-show-dot-for-dired t)

;; Store all interactive customizations in a temp file
(setq custom-file (make-temp-file "emacs-custom-"))

;; init.el ends here
