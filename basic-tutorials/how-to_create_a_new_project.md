# New-project

> How-to create a new project

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#preparations)
- [Usage](#usage)

---

## Preparations

If you don't want to use the script deployed in `scripts/python/new_project.py`

Maybe use [cookiecutter](https://cookiecutter.readthedocs.io/).

If you want to continue manually:

Set all the envs with the repos name: `$NAME`, `$GIT_TOKEN` yourself.

Create a projects directory in your projets-directory `mkdir <DIR>` cd into it and setup your virtual environment with `mkvirtualenvironment $NAME`

## Usage

To remotely create the new git-repo

```shell
curl -Uri https://api.github.com/user/repos -Method POST -Body (@{private="true";name=$NAME} | ConvertTo-Json) -Headers @{Authorization="token $GIT_TOKEN"}
```

To continue with git see my small [git tutorial](how-to_init_a_git_repo.md)

---

TODO: expand new_project.py:

From `project_settings.json` in `scripts/python` or your `.local/project_settings.json`\
    choose the ssh-keyring to use (add the right ssh_key to an env) eg: `sshCommand = ssh -i ~/.ssh/id_rsa_GITHUB`\
    choose username, email, repo-system (azure/github)\
    choose a license\
    choose a preset-layout
