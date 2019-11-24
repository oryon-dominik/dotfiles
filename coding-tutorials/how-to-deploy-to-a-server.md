# deploy with git

## create a git user

add a git group to a id of your choice (if not existent already [`sudo tail /etc/group`])
`sudo groupadd -g 54321 git`

the user
`sudo adduser --gecos Git --disabled-login --disabled-password --shell /usr/bin/git-shell --home /home/git --ingroup www-data git`

secure the login
`sudo mkdir /home/git/git-shell-commands`
`sudo vim /home/git/git-shell-commands/no-interactive-login`

```vim
#!/bin/sh
printf '%s\n' "No shell access provided for $USER. Go away."
exit 128
```

make it executable
`sudo chmod +x /home/git/git-shell-commands/no-interactive-login`

add git to the sudoers directory

`sudo touch /etc/sudoers.d/git`
`sudo chmod 0440 /etc/sudoers.d/git`
`sudo vim /etc/sudoers.d/git`

and add:

```vim
Defaults!/usr/bin/git env_keep="GIT_DIR GIT_WORK_TREE"
git ALL=(www-data) NOPASSWD: /usr/bin/git
```

## create a deployment-folder on the server

```bash
sudo mkdir -p /var/www/SITENAME
sudo chown -R www-data:www-data /var/www/SITENAME
sudo chmod u+rw -R /var/www/SITENAME
```

then create the repository too:

```bash
sudo -Hu git mkdir -p /var/git/SITENAME.git
cd /var/git/SITENAME.git
sudo -Hu git git init --bare
sudo -Hu git git config core.sharedRepository group
```

`sudo vim /var/git/SITENAME.git/hooks/post-receive`

and configure the post-receive-hook:

```vim
#!/bin/bash
repoDirectory=/var/git/SITENAME.git
pubDirectory=/var/www/SITENAME
echo "publishing from $repoDirectory -> $pubDirectory"
rc=0
sudo -u www-data git --git-dir=$repoDirectory --work-tree=$pubDirectory checkout master -f
if [ "$?" -ne "0" ]; then
    echo "GIT FAILED deploying"
    rc=1
fi

if [ $rc -eq 0 ]; then
    echo "Successfully deployed"
fi
exit $rc
```

finally update the permissions:
`sudo chown -R git:git /var/git/SITENAME.git`
`sudo chmod -R ug+rwX /var/git/SITENAME.git`

add the developers ssh-keys to `/home/git/.ssh/authorized_keys`
we use different port and ssh-key settings and have already configured .ssh/config that, so its only "servername", not "url:port"

and on the developers site add a remote:
`git remote add deploy git@servername:/var/git/SITENAME.git`
