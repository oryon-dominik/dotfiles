# GIT workflow Tutorial

> How-to work with git

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#preparations)
- [Usage](#usage)

---

## Preparations

> I'm using [hub](https://github.com/github/hub) a syntax-wrapper for git with a nice autocompletion

create an ssh-key and [register](https://help.github.com/en/enterprise/2.15/user/articles/adding-a-new-ssh-key-to-your-github-account) the public-Key (.pub) in the backend of your azure, bitbucket or github account

```powershell
# register a new key using a UNIQUE_IDENTIFIER, e.g: GITHUB)
ssh-keygen -t rsa -C your@email.address -f $env:USERPROFILE/.ssh/id_rsa_GITHUB
# copy the public key to the clipboard
clip < $env:USERPROFILE/.ssh/id_rsa_GITHUB.pub
```

choose your editor `git config --global core.editor "vim"`, `git config --global core.editor "emacs"` or `git config --global core.editor "notepad"`

Configure (`git config -e --global`) your global git settings to work with your unique identifier (you can also use different keys on a project-to-project basis - `git config -e --local`)

```.gitconfig
[user]
    name = yourname
    email = email@adress
[core]
    sshCommand = ssh -i ~/.ssh/id_rsa_GITHUB
    autocrlf = true
```

To remotely create repositories completey from your command line interface, supplementary to the credentials yo need a [GIT-Token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line)

## Usage

### If you want to work on an already existing project

1. **Fork the project** on the github-website

2. **Clone it** locally with SSH

    ```powershell
    git clone git@github.com:username/forkname.git <destination-folder>

    # switch to your destination-folder (cd <destination-folder>)
    git remote add upstream <base-url>
    git fetch upstream
    ```

    To update your files to the new versions from your upstream

    ```powershell
    git pull upstream master
    git pull upstream develop
    ```

3. **Set up** your local environment (make a virtualenv, eventually `make` the tests) and install the requirements, e.g:

    ```powershell
    python setup.py develop
    pip install requirements.txt
    make test
    ```

4. Now you can **start a feature** with

    ```powershell
    # If the project uses git-flow:
    git flow feature start <feature name>
    # Or if you want to start your work on your own branch outside the gitflow
    git checkout -b <name-of-your-bugfix-or-feature>
    ```

5. **Config** your git (skip the `git init` and continue with nr. 2. below)

6. If you want to **update your fork** from the upstream repository

    ```powershell
    git fetch upstream
    git checkout master
    git merge upstream/master
    git push  # to refresh your fork
    ```

### If you want to work on your own repository

1. **Initialize git** version control in your project directory

    ```powershell
    git init
    ```

2. **Configure the repository** with your email, username and UNIQUE_IDENTIFIER

    ```powershell
    git config --local user.email "your@email.address"
    git config --local user.name "username"
    git config --local core.sshCommand "ssh -i ~/.ssh/UNIQUE_IDENTIFIER"
    ```

3. Add some files and **commit** your directory structure

    ```powershell
    echo "something" >> README.md
    git add .
    git commit -m "First commit"
    ```

4. **Set the origin** (`git remote -v` shows already available connections)

    On github via SSH:

    ```powershell
    git remote add origin git@github.com:<username>/<repo>.git
    git push origin master  # takes your local commit and pushes it to master
    ```

    On azure

    ```powershell
    git remote add origin git@ssh.dev.azure.com:v3/<accountname>/<projectname>/<projectname> # see azure official-website
    git push -u origin --all  # sets upstream tracking reference and pushes all local branches
    ```

    If you accidently started with https and want to switch over to ssh just type

    ```powershell
    git remote set-url origin git@github.com:<username>/<repo>.git
    ```

5. Start a **git flow** (you can skip any questions asked and confirm with `<enter>` for now)

    ```powershell
    git flow init
    ```

    Begin with a release

    ```powershell
    git flow release start <release number>
    # to end it (the release get's merged into master & develop)
    git flow release finish <release number>
    ```

    Start (or finish) a new-feature or bugfix

    ```powershell
    git flow feature start <feature name>
    git flow feature finish <feature name>
    ```

    As a last resort if anything goes wrong in production you can deploy hotfixes directly to the master (& develop) branch with

    ```powershell
    git flow hotfix start <release number>
    git flow hotfix finish <release number>
    ```

## Some practicable tipps

## show unpushed commits

git log --branches --not --remotes

## show the last git details

git log -1

## change the last git mesage

git commit --amend -m "New message"

## merge a pull-request

git fetch upstream/<id>/head:<pull-requst-branch-name-without-user>
