# sketched-dots

##### Simple symlinks. That's it!
Dots are used via symlinks to files from this repository.

## Installation

Clone this repository and run the make command.

```bash
$ make
```

#### Use specific dots
Usually you can do this by runnig `$ make <app name>-dots`.

```bash
# use only kitty dots
$ make kitty-dots
```
Please check `Makefile` for more commands

## Good to know

### Vim

Vim plugins are installed first time you use vim. 
Note that `YouCompleteMe` extension may fail. 
In order to fix it run:
```bash
$ python3 .vim/plugged/YouCompleteMe/install.py
```

## Uninstall

Right now there is no uninstall command.
You can delete the repository and remove symlinks manually.
