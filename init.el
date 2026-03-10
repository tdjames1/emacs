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
(add-to-list 'package-archives
             '("elpa" . "https://elpa.gnu.org/packages/"))

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
    pyenv-mode
    virtualenvwrapper
    auto-virtualenv
    ;;projectile
    deft))

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

;; sphinx-doc mode
;;(add-hook 'python-mode-hook (lambda ()
;;                             (require 'sphinx-doc)
;;                             (sphinx-doc-mode t)))

;; Define key binding for stepping through code
(eval-after-load "elpy"
  #'(define-key elpy-mode-map (kbd "C-c RET") 'elpy-shell-send-group-and-step))

;; Use flycheck instead of flymake
;;(when (load "flycheck" t t)
;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;  (add-hook 'elpy-mode-hook 'flycheck-mode))

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

;; Enable virtualenvwrapper
(require 'virtualenvwrapper)

;; Enable auto-virtualenv
(require 'auto-virtualenv)
(setq auto-virtualenv-global-dirs
      '("~/.virtualenvs/" "~/.envs/" "~/.conda/" "~/anaconda3/envs/"))
(setq auto-virtualenv-python-project-files
      '("requirements.txt" "Pipfile" "pyproject.toml" "setup.py" "manage.py" "tox.ini" ".flake8"))

;; Optional: which-key will show you options for partially completed keybindings
;; It's extremely useful for packages with many keybindings like Projectile.
(use-package which-key
  :ensure t
  :config
  (which-key-mode +1))

(use-package projectile
  :ensure t
  :init
  ;;(setq projectile-project-search-path '(("~/work/projects/" . 1) ("~/work/external/" . 1)))
  :config
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;; deft
(setq deft-recursive t)
(setq deft-current-sort-method 'title)

;; init.el ends here
