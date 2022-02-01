# dotfiles

> Configure and install your operating system and application settings from anywhere.

*These dotfiles rely on `git` for versioncontrol. Learn git through playing [oh my git](https://ohmygit.org/).*  
*For an introduction using version control with `vscode` there is a nice post in the [docs](https://code.visualstudio.com/docs/editor/versioncontrol)*  

## Content

- [How to create a dotfiles repository on windows](#how-to-create-a-dotfiles-repository-on-windows)
- [How to create a dotfiles repository on ubuntu](#how-to-create-a-dotfiles-repository-on-ubuntu)

---

## How to create a dotfiles repository on windows

After a fresh windows installation start with the [post-installation preparation](tutorials/windows/1-post-installation-windows10.md),
 or directly proceed to [setup your own windows dotfiles](tutorials/windows/2-how-to-windows-dotfiles.md).

## How to create a dotfiles repository on ubuntu

Tutorial how to setup [ubuntu dotfiles](tutorials/ubuntu/1-how-to-ubuntu-dotfiles.md).

---

Work still in progress, just have a look around the script files.  

If you are interested in something special, you need a feature or an advice, write me a message or create an issue.  
This repos' main purpose is serving as a private dump - so no warranties at all for anything  

> Especially all install- and shell- scripts are under heavy construction. Use with caution - *know* what you're doing.
  
newest_version: 25.12.2021


### Hooks

To enable the git commit hooks on the machine (Requires installation of [python](tutorials/python/pyenv-on-windows.md) + [poetry](tutorials/python/poetry-on-windows.md))

    poetry install
    poetry shell
    pre-commit install


### Diagram

![Visualization of the codebase](dotfiles-visualized-diagram.svg)
