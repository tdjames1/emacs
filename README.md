# Emacs

## Python IDE

Based on the following gist for setting up Emacs as a Python IDE:
https://gist.github.com/widdowquinn/987164746810f4e8b88402628b387d39

### Modifications

- Replace `global-linum-mode` with `display-line-numbers-mode` for programming modes only.
- Activate `better-defaults`: `(require 'better-defaults)`.
- Make `ido` show dot for current directory `(setq ido-show-dot-for-dired t)`.
- Check if `ipython` is available before setting `python-shell-interpreter`.
- Add `(setq custom-file (make-temp-file "emacs-custom-"))` to store all interactive customisations
  in a temp file (transfer any customisations to be retained to the init file).


### Setup / troubleshooting

Link from version controlled init file to default location:
`ln -s ~/dot/emacs/init.el ~/.emacs.d/init.el`

If, on startup, packages can't be found, try `M-x package-refresh-contents`.

Resolve elpy error in process sentinel: peculiar error: "exited abnormally with code 1" with `M-x
elpy-rpc-reinstall-virtualenv` (seems to be needed on every session).

Update: above error seems to be a [problem with finding a Python
executable](https://emacs.stackexchange.com/a/66732) (Python not
installed at system level on dcs34998). Added the following to
`init.el`:

```{lisp}
;; Set path to Python interpreter for RPC backend
(setq elpy-rpc-python-command "~/anaconda3/bin/python")
```


### TODO

- Explore virtual environments
- Include `ipython` in development environment
- Enable `pyenv-mode` ("pyenv-mode: pyenv executable not found.": need to install on system?)
- Tweak elpy key-bindings
