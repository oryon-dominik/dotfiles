# Bash / fish

> How-to bash / fish on Fedora

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

This shell (bash & fish) -Tutorial mostly follows my learnings with fedora-linux 27 and is used as my personal reference.
Some (or most) of the commands should work on other linux-distributions too.
As I'm a linux-beginner (at least I was, when I started writing this tutorial) these commands do neither claim completeness nor correctness at all.

If you have special questions on a command, you should tryout [explainshell](https://explainshell.com/).

Some of the links point to german references, sorry.

TODO: add / update index, better chapter-marks & titles

- [Preparations](#markdown-header-preparations)
- [Usage](#markdown-header-usage)

---

## Preparations

install fedora

- TODO: create a good, readable tutorial on using bash from these notes
- TODO: create a readable readme with good sections and examples
- TODO: clean from personal variables (use .env-imports for this)

### Basic UI-Controls

- Basics:\
    ctrl+shift+alt + arrowkeys  -> move application between desktops\
    ctrl+alt+ arrowkeys         -> switch between desktops\

- Fedora-Terminal:\
    ctrl+shift+t                -> new tab in terminal\
    ctrl+shift+n                -> new terminal\
    alt+1 / alt+2               -> switch tab\
    ctrl+shift+w                -> close terminal\

    ctrl+c                      -> terminate running process\
    ctrl+z                      -> hold on process\
    ctrl+s                      -> stop scrolling\
    ctrl+q                      -> resume scrolling\

    ctrl+shift+u+hex+SPACE      -> special chars [entity-table](http://unicode.e-workers.de/entities.php)\
                                    „Ω“ = (U+2126) # -> ctrl+shift+u+2126+SPACE\

fedora autostart:\
in `~/.config/autostart` are the `*.desktop` files of programs, that run on systemstart.\
More Inormation on [modifying dekstop entries](https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#recognized-keys)

## Bash

### the very basics

`whoami` shows your username\
`who` show who is logged on

`date` ...

show version: `cat /etc/fedora-release`\
load all os-variables: `source /etc/os-release`\
show system `uname -a` or kernel `uname -r` info

show the manual-page for any command `man <command>`

show the path of a command (python here) `whereis python`

show the path to the currently used version `which python`

list files in the cwd or `<path>` with `ls`

`pushd <path>` push current working directory (cwd) on a stack and switches to `<path>`\
`dirs` shows all directories on directory-stack\
`popd` pops dir from the stack (and switches to it)

`mkdir` create directory

### variables

Show, set or unset values of shell options and positional parameters with `set`\
Set environment variable to value `export name=value`

### advanced basics

Repeat the last command `!!`

`history` list the last commands\
`history > file` saves history in "file" / you can find the history in `~/.bash_history` too!\
`history -c` clears history from current shell\
`history -w` saves / overwrites the shell history with the current one\
`history -d <nummer>` delete history entries with `<number>`

`tty` Terminal-name

chain commands with a `|`\
write command-output (pipe it) to a file `> filename` or append it with `>> filename`\
a `&` at the end, runs the command in the background\
`man ascii` shows the ascii-table\
to continue the command even though you closed the terminal with `nohup <command>`

other use-cases of `ls`:\
you can combine it with `cut`: `ls | cut -f1`

```bash
ls -a               # show hidden files
ls -A               # show hidden files without . and ..
ls -r               # show files in reverse order
ls -X               # list files ordered via extension
ls -t               # list files sorted after modification time, newest first
ls -R               # list subdirectories recursively
ls -l               # list files with (permissions, hardlinks, owner, group, filesize, last_mod_date, name)
ls -l --author      # shows author too
ls -b               # escape special-chars
ls --hide=*.txt     # show everything but *.txt
ls -d               # only show direcotry-entry itself, no dereference of symbolic-links
ls -Z               # prints SELinux security context of file
ls -dZ              # prints SELinux information on directory
ls | wc -l          # counts files in cwd
```

sleep: `shutdown -h <timein_hh:mm>`\
hinbernate: `systemctl hibernate`\
restart: `shutdown -r` or `reboot`\
`shutdown -k` "Wall"-Message, no shutdown\
`shutdown now` or `shutdown 0` does `shutdown -p 0` and powers off\
`systemctl suspend`

ATTENTION: delete all the data on your disk recursively `rm -rf /` without asking `rm -rf / --no-preserve-root`

`eog <image-name>` shows an image\
`file -bi <filename>` shows encoding\
`iconv -f <from-encoding> -t <to endocding> input.file -o output.file` convert encoding

`df` show empty disk space `df -h` in GB

Mount a dir to another path `mount --bind /<sourcepath> <targetpath>`

`find <path> -name *.log -print` find and list log files in `<path>`\
`find . -name '*.log' -exec rm{};` find log files in current directory and delete them\
`find <path> -newer <filename>` looks for files newer than `<filename>` in `<path>`

`ln <source> <target>` hard-link ("physical" link) for content, looks like the original\
`ln -s <source> <target>` soft-link ("virtual) for content, that's what you want to use!\
`unlink <target>` remove soft- or hardlink\
`find -L DIRECTORY -xtype l` find links recursively in DIR\
`ls -l LINKDIR/LINKNAME` see the target of the link\
`find -L . -type l` looks for flawed links in cwd and sub-dirs

`lspci` shows installed hardware

`file <filename>` shows filetype and details

`echo "text"` writes "text" to console\
`echo "text" > file` writes "text" to file\
`echo "text" >> file` appends "text" to file

`head <file*>` show beginning of some files\
`tail <file*>` shows end of some files

`cmp <file1> <file2>` compare two files, shot analysis\
`diff <file1> <file2>` detailed differences

`split -n <file>` splits `<file>` in n-lines long parts

`cat <file*>` creates file or shows files content\
`cat <file*> > <file>` writes content to new-file\
`cat file1 file2 > file3` concatenate two files to third

`wc <file>` counts lines, words and chars

`sleep s` sleep process for "s" seconds

`wget <url>` download file to cwd

`localectl set-locale en_US.utf8` sets language to english

`tee -a <file>` splits progam-output: reads standard-input, writes to standard-output and a file `-a` appends instead of overwritng the file\
`<command> | tee <file>` writes console-outpu directly into a file too, e.g `ls | tee list.txt`

`printenv` shows environment-variables, print single values with `echo $<varname>`

`hexdump -n 512 -C <filename>` shows files hexdump (n=lenght in bytes of input, C=hex+Ascii)

### user

show user id `id <username>`\
show user id from name `id -u <username>` or name from id `id -nu <userid>`

last login and active user with `w`\
show users groupd `groups username`\
create user `$ useradd -m -G wheel -s /bin/bash username`\
and set her password `passwd username`

when changing some values in configfiles use use `$HOME` instead of `/home/username`, so they are generally valid

rename a user `sudo usermod -l oldname newname` and move its home `sudo usermod -d /home/newname -m newname`\
give her a new id too `sudo usermod -u 2000 newname`\
and don't forget to change her usergroup `groupmod -n newname oldname`\
test it with `id newname`

move `malcolm` to a new home-directory `usermod -d /newpathto/malcolm -m malcolm`

block chris `usermod -L chris` and free him again `usermod -U chris`\
move shell for daisy to `/bin/fish` with `usermod -s /bin/fish daisy` and back `usermod -s /bin/bash daisy`

if you want to skip login in gnome edit `/var/lib/AccountsService/users/` and set `SystemAccount=true`

### groups

show groups `cat /etc/group`

in `/etc/sudoers` groups (wheel, root) with sudo-access are listed

to add a user to a group use this instead of `groupadd` to not overwrite its values `gpasswd --add username group`\
and to delete him `gpasswd -d username group`

Create a group with id(1337) and its group(hackers) `groupadd -g 1337 hackers`

to have the user change its password at next login: `chage -d 0 username`

delete a user (including its home-.directory) with `userdel -r username`

add hillary to the sudo group `usermod -aG sudo hillary`

#### chmod

First = owner\
Second = group\
third  = others\
7 = full\
6 = read AND write\
5 = read and execute\
4 = read only\
3 = write and execute\
2 = write only\
1 = execute only\
0 = no

Examples:\
To set all rights recursivley on all rights and folders in dir /foo/bar to 700 `chmod -R 700 /foo/bar`\
change the rights on file.txt to "full" for owners, groups and others `chmod 777 file.txt`

#### chown

`chown <user> <file>` change owner of a file to user\
Examples:\
to set the current user as owner of media including all subdirs and show changes `sudo chown -cR $USER /media/`\
you can also change the group and user of a file `chown root:groupname file.txt`\
change owner of dir and content from `/var/dict` to user & group "yourgroup" `chown -R user:yourgroup /var/dict`

### package & kernel managing with dnf

More on DNF System upgrade on the [official pages](https://fedoraproject.org/wiki/DNF_system_upgrade)

`dnf upgrade`                   upgrades all packages\
`dnf check-update`              what upgrades are available\
`dnf check-update <packetname>`

`dnf search <packetname>`

`dnf install <packetname>`\
`dnf remove <packetname>`\
`dnf download --source <packetname>`

`dnf clean metadata`            cleans metadaten bevor update, you could use `dnf upgrade --refresh`

To show your repository-groups:\
`dnf grouplist hidden`\
`dnf group info <groupname>`\
`dnf install '@<groupname>'`

Show kernel-version: `uname -r` and installed kernel with `rpm -q kernel` or `dnf list installed | grep kernel`\
Show old kernels with `package-cleanup --oldkernels` and remove em with `dnf remove kernel-<version>`

In `/etc/dnf/dnf-conf` is a list with `installonly_limit =` you can set here how many kernels should be stocked

`dracut -fv` builds initramfs for the running kernel

on a stable sytem these can be savely removed from /boot `rm /boot/vmlinuz-0-rescue-*` and `rm /boot/initramfs-0-rescue-*`\
After removing, run: `grub2-mkconfig -o /boot/grub2/grub.cfg` to rebuild the boot-list

### basic .bashrc

Extend `~/.bashrc` to your needs.\
After any changes you should `source ~/.bashrc` to activate them.

ATTENTION if you are using fish a `source ~/.bashrc` won't work\
just switch to `/bin/bash`, `source` there and return back to `fish`

```.bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# use bash_aliases
if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
fi

# For getting X-Apps (GUI-apps) run in sudo-mode
export XAUTHORITY=~/.Xauthority
```

to add colors in `~/.bashrc`

```.bashrc
export GREP_OPTIONS='--color=auto'                          # colors in grep
dircolors                                                   # colors for dirs
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'    # colors in ls
```

some links for more color:\
[ls-colors](http://linux-sxs.org/housekeeping/lscolors.html)\
more on [bash-colors](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

### basic aliases

After setting up the use of `~/.bash_aliases` in `~/.bashrc` you can customize them.\
Reload them with `source ~/.bash_aliases`

You can also set them inside your terminal `alias name1 name2` temporary: `alias name1="name2"` or remove them `unalias name1`

```.bash_aliases
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias cd..="cd .."
alias ..='cd ..'
alias cls=clear
alias md=mkdir

alias shu="shutdown now"
alias reb="reboot"
alias logout="gnome-session-quit --logout --force"

alias webserver="python3 -m http.server 8080"
alias sshserver="sudo systemctl start sshd.service"
alias sshserverstop="sudo systemctl stop sshd.service"
```

### fish

I added a function for fish to repeat the last command as sudo in `~/.config/fish/functions/!!!.fish`

```!!!.fish
function !!!
  eval sudo $history[1]
end
```

### logging

Logs live in: `/var/log` e.g: `/var/log/boot.log` or `/var/log/messages`

in fedora there is `journalctl`

```bash
journalctl /usr/bin/dbus-daemon     # shows all logs generated by /usr/bin/dbus-deamon
journalctl /dev/sda                 # shows all logs of kernel device /dev/sda
journalctl -k -b -1                 # shows all kernel logs from previous boot
journalctl -e                       # end of logfile
journalctl --since JJJJ-MM-TT HH:MM:SS
journalctl --until JJJJ-MM-TT HH:MM:SS
journalctl -u UNITNAME              # show only from UNITNAME
journalctl -t IDENTIFIER            # just show events from identifier eg. "journalctl -t pulseaudio"
journalctl _SYSTEMD_UNIT=avahi-daemon.service _SYSTEMD_UNIT=dbus.service
journalctl _SYSTEMD_UNIT=avahi-daemon.service _PID=28097
journalctl -S today
journalctl _COMM=python3            # all logs from python
journalctl -n 5                     # last 5 entries
journalctl -f                       # live-log
journalctl --since "2018-08-04 20:00:00" --until "2018-08-04 20:15:00"
journalctl _UID=1000 -n 5           # show entires for user with id 1000
journalctl --k                      # kernel messages
journalctl -o verbose               # verbose mode

journalctl -b -t setroubleshoot -o verbose

sudo journalctl --since yesterday -u cron.service
```

read more in the [ubuntu wiki entry on journalctl](https://wiki.ubuntuusers.de/systemd/journalctl/)

You can also show systemd-logs with journalctl

```bash
systemd-analyze                 # show boot-time
systemd-analyze blame           # show boot-time of services in order
systemd-analyze critical-chain  # show process-chain in boot-order
```

### boot

ATTENTION unless you now what your doing, you can leave the system unbootable\
`sudo vim /etc/grub2.cfg` to edit the bootmenu in `grub.cfg` and delete unwanted entries

`sudo systemctl set-default multi-user.target` boot with a shell\
`sudo systemctl set-default graphical.target`  boot with graphical log-in

#### bootsplash - plymouth

show the boot-splash for ten seconds (to test):

```bash
plymouthd; plymouth --show-splash ; for ((I=0; I<10; I++)); do plymouth --update=test$I ; sleep 1; done; plymouth quit
```

```bash
plymouth-set-default-theme --list       # list installed themes
plymouth-set-default-theme name         # set theme
```

`sudo /usr/libexec/plymouth/plymouth-update-initrd` to set/updaten the themes before reboot

New themes go into `/usr/share/plymouth/themes`

For the installation of my cool self-made-theme, we need to `dnf install plymouth-plugin-script`

### Systemctl

```bash
systemctl list-units
systemctl | grep .service                               # lists installed services
systemctl start <servicename>                           # start service
systemctl stop <servicename>                            # stop service
systemctl restart <servicename>                         # restart service
systemctl is-enabled <servicename (without .service)>   # check if service is enabled
systemctl status <servicename>                          # status
systemctl enable <servicename>                          # start at systemstart -> creates a symlink somewhere in /etc/systemd/system to unit somewhere in /lib/systemd/system
systemctl disable <servicename>                         # do not start on system-startup
systemctl --failed                                      # look up failed services

systemctl reboot                                        # reboot
systemctl poweroff                                      # shutdown
systemctl suspend                                       # suspend machine to ram

systemctl mask                                          # service is masked, so it is impossible to start -> symlink created from /etc/systemd/system to /dev/null
systemctl unmask                                        # service is unmasked
```

### hard-drives

show your drives with `ls /dev/ | grep sd` or `cat /proc/partitions`

show your mountpoints with disk free `df` and mount them with `sudo mount /dev/sda1 /yourfolder`, `mount -l` to show all already mounted mountpoints.\
To write an etx4 filesystem on `sdb` use the syntax `sudo mkfs -t ext4 -v -L Diskname /dev/sdb`

then add the mount to `/etc/fstab`:

```bash
/dev/sdb /mountpoint  ext4 defaults 0 0
```

if you want to unmount: `umount /dev/sdb`

if your disk has failures they could be repaired with `fsck /dev/sdb` (use 'a' switch) or `e2fsck`

`sudo lvdisplay` shows your logical partitions

For a graphical view on your partitions your can use `blivet-gui` (has to be installed with dnf and doesn't run well on fish)

#### Cloning your Hard-Drives

`dd if=SOURCE of=TARGET <options>`

`dd if=/dev/sda of=/dev/sdb` clones complete sda to sdb including partitions, MBR and partiton-table.\
ATTENTION: even UUID and labels are the same

New UUID: `sudo tune2fs -U random /dev/sdb1`\
New label: `sudo e2label /dev/sdb1 newlabel`\
If your targetsystem is a bigger volume you can stretch the fs to fit the new size with `sudo resize2fs /dev/sdb1`

To make an image of sda1 in home `dd if=/dev/sda1 of=~/image_sda1.img`\
And to rebuild the image to sda1 `dd if=~/image_sda1.img of=/dev/sda1`

You can also choose to build on a network target over ssh `dd if=/dev/sda | ssh 192.168.11.11 dd of=/dev/sda`\

Or backup on a server: `dd if=/dev/hda1 | ssh user@192.168.2.101 "cat > /home/User/myimage.img"`\
Or restore from the server `ssh User@192.168.2.101 "cat /home/User/myimage.img" | dd of=/dev/hda1`

### using virtual environments

I recommend using [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/), but you the syntax to use virtualenvs without it is

If you already have a project in `/pyxercise` create a venv with: `virtualenv-3 --system-site-packages ~/.venvs/pyxercise`\
Activate it in fish with `. ~/.venvs/pyxercise/bin/activate.fish` or `source ~/.venvs/pyxercise/bin/activate.fish` and deactivate with `deactivate`.

### if you run your distribution inside a virtualbox

To properly install vboxguestauditions

```bash
dnf update kernel*
mkdir /media/VirtualBoxGuestAdditions
mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
dnf install gcc kernel-devel kernel-headers dkms make bzip2 perl
KERN_DIR=/usr/src/kernels/`uname -r`
export KERN_DIR
cd /media/VirtualBoxGuestAdditions
./VBoxLinuxAdditions.run
reboot
```

relevant groups für `vbox`: `vboxsf`

### grep / regex search

grep is a great search-tool, that uses regular expressions

```bash
grep "hello" xyz.txt            # shows all lines from xyz-txt, that contain the word "hello"
grep -E 'hell?o' file.txt       # looks for "helo" and "hello" in file.txt.
grep -r                         # recursive, subdirs too
grep -v 'hello' file.txt        # just show lines, NOT containing "hello"
grep -i 'hello' file.txt        # case-insensitive search
grep -w 'hello' file.txt        # full words only
grep -c 'hal' file.txt          # count occurence
grep -n 'hello' file.txt        # linenumbers before match
grep -l 'hello' *.txt           # only filename
grep -L 'hello' *.txt           # files NOT containing search
```

you can create complex regex search-patterns and save them in files\
Example: filter lines with E-Mail-adresses from file\
`grep -E '([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})' file.txt`\
Write that regex to a file\
`$ echo '([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})' > ~/regexpressions/mail`\
Call it with `grep -Ef ~/regexpressions/mail file.txt`

Some more examples (in german) from [kushellig.de](http://kushellig.de/linux-unix-grep-befehl-beispiele/):

```bash
lspci | grep VGA                        # graphics card
grep '^foobar' file1.txt file2.txt      # find lines starting with "foobar" in file1.txt AND file2.txt
grep '^$' file.php                      # find empty lines
grep -w 'in' file.txt                   # find lines with "in", whole words only, not "binary" or "coding"
dmesg | grep -E '(s|h)d[a-z]'  **       # show all HDDs
ps aux | grep postgres                  # list all postgres processes
```

### GIT

You can read about git on [Pro git book](https://git-scm.com/book/en/v2), these commands are mostly c&ps\
I use [git flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) to create and manage features

```bash
git status

git config --global user.name "username"
git config --global user.email email
git config --global core.editor vim
git config --list                           # shows a list of all variables set
git config user.name                        # shows user.name

git clone <url>                             # clones repo to cwd
git clone <url> <dir>                       # clones into dir

git branch                                  # list of branches, * = masterbranch; To see the last commit on each branch, you can run git branch -v
                                            # To see which branches are already merged into the branch you’re on, you can run $ git branch --merged
                                            # To see all the branches that contain work you haven’t yet merged in, you can run $ git branch --no-merged

git branch testing                          # Creates the branch testing
git checkout testing                        # moves the head to testing
git checkout -b hotfix                      # creates AND moves to new branch hotfix
git merge hotfix                            # merges hotfix branch into master, deploy the hotfix (look into rebase for more production friendly merges)
git branch -d hotfix                        # deletes the hotfix-branch when you r ready (fails, if branch is not merged into - but you can still force deletion with -D)
```

more on [teamwork](https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches) and [contributing issues](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)

```bash
git init                                    # initialize a new repository inside cwd
git add <file>                              # begin tracking new file / or *stage* it, when add-ing it again

git diff                                    # shows changes
git diff --cached                           # to see what you’ve staged so far
git commit                                  # everything that is STAGED (add(ed) gets committed
git commit -m "Story 187: Fixed a bug"      # includes commit-comment
git commit -a -m 'added new benchmarks'     # just commits every changed file without the need of add-ing them
git remote show                             # gives you a lot of information on the remote
git remote -v                               # shows a list of urls after git clone, from where you and others push or fetch, when remotely working an another git

# then you can type
git fetch <name>                            # gets the commitments from the <name> person
git fetch origin                            # fetches any newe work since last clone
git push <remote> <branch>                  # pushes your into your branch
git remote rename pb paul                   # renames branch pb to paul
```

if you commit and then realize you forgot to stage the changes in a file you wanted to add to this commit, you can do something like this:

```bash
git commit -m 'initial commit'
git add forgotten_file
git commit --amend
```

You end up with a single commit, the second commit replaces the results of the first.\

if you want to see which commits modifying test files in the Git source code history were committed by "oryon" in the month of September 2018 and are not merge commits,\
you can run something like this: `git log --pretty="%h - %s" --author=oryon --since="2018-09-01" \`

#### .gitignore

create a `.gitignore` file in your repository to ignore them

ignore all .a files `*.a`\
but do track lib.a, even though you're ignoring .a files above `!lib.a`\
ignore all files in the build/ directory `build/`\
ignore doc/notes.txt, but not doc/server/arch.txt `doc/*.txt`\
ignore all .pdf files in the doc/ directory and any of its subdirectories `doc/**/*.pdf`

### network

`ip addr show` shows all the avaiable network interfaces (lo is the local interface for loopbacks)
`ifconfig`\
`nmcli`\
`nmcli con show` shows all connections by name and if active or not, with device-name at the end\

`ls /etc/sysconfig/network-scripts`\
to edit try `vim ifcfg-<device-name>`

`nmcli dev show` shows detailed information on the network-adapters\
`nmcli con reload` reloads configuration files\
`nmcli con show 'System <name>'` eg: System eth0, shows all info to connection\
`nmcli con mod ipv4.addresses '10.0.0.2/24'` changes the config..\
      `ipv4.addresses`  changes the subnet mask\
      `ipv4.gateway`    changes default gateway\
      `ipv4.dns`        changes nameserver opv4 address\
      `ip4v.method`     auto: use dhcp, manual: use static only\
`nmcli con up 'System eth0'`  interface gets turned on\
`nmcli dev disconnect 'System eth0'` (dev=device),.. turn interface off..

troubleshooting:\
`ping <address>` ping response\
`traceroute www.redhat.com` traces ip addresses between you and the server addressed\

#### curl

```bash
# test curl on http://jsonplaceholder.typicode.com/
curl <URL>              # get http-response
curl --head <URL>       # get the head of the response / --head == -I
curl -O <URL>           # downloads file
curl -o <file> <URL>    # writes response to file
curl <URL>{one,two} -o <file> -o <file2>  # writes response from two urls to two files
curl --data "title=example&body=example2" <URL>  # post request to URL / --data == -d
curl -X PUT --data "title=example&body=example2" <URL>  # PUT request to URL
curl -X GET <URL>       # get the requests responses back (also for POST, PUT, PATCH, DELETE)
curl -F <field_name>=<text> -F <field_name>=<text> <URL>  # fills a form - example: $ curl -F name=Domi -F budget=1000 https://example.com/
curl -F <name of the field>=@<filename> <URL>
curl -F "story=<hugefile.txt" https://example.com/  # Send as plain text field, but get the contents from local file
curl -F "web=@index.html;type=text/html" example.com  # example with Content-Type included
curl --user <user:password>  # specifies login, when also works for -u <user> and asks for pw
curl -L <URL>           # follows redirection
curl -u <user>@<domain>:<password> -T <filename> ftp://<URL>  # uploads a file to FTP with credentials
curl -u <user>@<domain>:<password> -O ftp://<URL>/<filename>  # downloads a file from FTP with credentials
```

### server ssh & html

`python -m http.server 8080` starts python web-server on http:localhost:8080/ with cws as source

ssh-daemon: `systemctl start sshd` or `sudo systemctl start sshd.service;`\
stop it with `sudo systemctl stop sshd.service;`

to enable it on boot `sudo systemctl enable sshd.service;`\
and to remove it from autostart `sudo systemctl disable sshd.service;`

`systemctl restart network.service`

in `/etc/sysconfig/network-scripts/ifcfg*` is the data for network adapters saved. with `BOOTPROTO=static` you can give them a static IP

to get a name-access (e.g `ssh username@network`)\
`vim /etc/hosts` and add a new entry: `ip hostename` e.g. `192.168.14.2 myNetwork`

#### Apache

webfiles default to the directory `/var/www/html/` you can change that in the conf\
`index.html` is the base for content then..\
it runs on port 80, if not specified otherwise

apache-service-optionen: (append to apache-command) e.g `service apache <option>`

```apache
start           # starts the server
stop            # stops the Server
restart         # restart server, connections break
reload          # reloads config without cutting the connections
force-reload    # reloads config, even if connections would be cut
```

#### scp

(is quite similar to cp):

`scp sourceUsername@localhost:file targetUser@targetServer:`\
you can write it shorter, when using your active user and cwd:\
`$ scp file targetUser@targetServer:`\
send files:\
`scp -r user1@server1:path1 file2 user2@server2:`

set hostname\
`hostnamectl set-hostname --static "YOUR-HOSTNAME-HERE"`

`telnet` brings up a login promt of remote host, not encrypted, needs a telnet-server running\
`telnet ?` help\
`close` close current connection\
`quit` exit telnet\
`logout` ...\
`open <host> <port>`

`telnet checkip.dyndns.org 80` check if there is a http-server running on `checkip.dyndns.org`\
`telnet$ GET / HTTP/1.1`\
`telnet$ HOST: checkip.dyndns.org`

#### ftp

```bash
ftp   # login-prompt for ftp-protocol, exit with "quit"
      # put, mput: (multi-put) to upload files/ get, mget: (multi-get) to download files / ls: lists files
      # examples: $ ftp domain.com / $ ftp <ip> / $ ftp user@ftpdomain.com
      # try name: "anonymous" and leave password blank may get you access
ftp ? # brings up the help inside ftp-prompt and shows avaiable commands
```

#### Netstat

`sudo netstat -paute` shows which PIDs belong to what sockets (also works with t, u, x, etc..)\
`$ netstat -p`\
list connections `netstat -a`\
tcp-/udp-/-unix-details: `netstat -at`, `netstat -au`, `netstat -ax`\
routetable: `netstat -r`\
look which ports are listening: (also works with t, u, x oder all): `$ netstat -l`\
statistik over failed or successful connections: `netstat -s`\
tail the network: `netstat -c [timeinseconds]`\
`netstat -e`

### processes

list processes with `ps`, you get a PID (process-ID), the terminalname and the ucmd - the name of the process\

`kill <PID>` kill the process\
`kill -9 <pid>` violently kill the process (remove it)\

`ps`                active user & active terminal\
`ps -e`             all processes\
`ps -ef`            all processes with PID & path\
`ps -U username`    show a user's process (eg root):, add `u` oder `f` for format `ps -U root u`\
`ps -p 42`          show process with id 42\
`ps --ppid ID`      parents process

### XARGS

Find files named `core` in or below the directory /tmp and delete them. (no spaces)\
`find /tmp -name core -type f -print | xargs /bin/rm -f`

in such a way that file or directory names containing spaces or newlines are correctly handled.\
`find /tmp -name core -type f -print0 | xargs -0 /bin/rm -f`

install a list (-a reads from file) with `$ xargs -a ~/software.list sudo dnf install`

### cron tab & jobs

`@reboot` every reboot..\
ATTENTION paths should be correct -> look for errors between absolute and relative paths\
is the service running? `systemctl status crond.service`\
`service crond status`

cron list: `crontab -l`\
cron edit `crontab -e`\
cron delete `crontab -r`

The entry: `01 * * * * /bin/echo Hello, world!` runs the command /bin/echo Hello, world! on the first minute of every hour of every day of every month (i.e. at 12:01, 1:01, 2:01, etc.).

Similarly: `*/5 * * jan mon-fri /bin/echo Hello, world!` runs the same job every five minutes on weekdays during the month of January (i.e. at 12:00, 12:05, 12:10, etc.).

The line (as noted in "man 5 crontab"): `*0,*5 9-16 * 1-5,9-12 1-5 /home/user/bin/i_love_cron.sh` will execute the script i_love_cron.sh at five minute intervals from 9 AM to 5 PM (excluding 5 PM itself) every weekday (Mon-Fri) of every month except during the summer (June, July, and August).

Periodical settings can also be entered as in this crontab template:

```bash
# Chronological table of program loadings
# Edit with "crontab" for proper functionality, "man 5 crontab" for formatting
# User: johndoe

# mm  hh  DD  MM  W /path/progam [--option]...  ( W = weekday: 0-6 [Sun=0] )
  21  01  *   *   * /usr/bin/systemctl hibernate
  @weekly           $HOME/.local/bin/trash-empty
```

Here are some self-explanatory crontab syntax examples:

```bash
30 4 echo "It is now 4:30 am."
0 22 echo "It is now 10 pm."
30 15 25 12 echo "It is 3:30pm on Christmas Day."
30 3 * * * echo "Remind me that it's 3:30am every day."
0 * * * * echo "It is the start of a new hour."
0 6 1,15 * * echo "At 6am on the 1st and 15th of every month."
0 6 * * 2,3,5 echo "At 6am on Tuesday, Wednesday and Thursdays."
59 23 * * 1-5 echo "Just before midnight on weekdays."
0 */2 * * * echo "Every two hours."
0 20 * * 4 echo "8pm on a Thursday."
0 20 * * Thu echo "8pm on a Thursday."
*/15 9-17 * * 2-5 echo "Every 15 minutes from 9am-5pm on weekdays."
@yearly echo "Happy New Year!"
```

A line in crontab file like below removes the tmp files from `/home/someuser/tmp` each day at 6:30 PM.

```bash
30     18     *     *     *         rm /home/someuser/tmp/*
```

Changing the parameter values as below will cause this command to run at different time schedule below :

```bash
30      0   1           1,6,12      *       — 00:30 Hrs  on 1st of Jan, June & Dec.
0       20  *           10        1-5       – 8.00 PM every weekday (Mon-Fri) only in Oct.
0       0   1,10,15     *           *       — midnight on 1st ,10th & 15th of month
5,10    0   10          *           1       — At 12.05,12.10 every Monday & on 10th of every month
```

like so:

```bash
*     *     *   *    *        command to be executed
-     -     -   -    -
|     |     |   |    |
|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
|     |     |   +------- month (1 - 12)
|     |     +--------- day of        month (1 - 31)
|     +----------- hour (0 - 23)
+------------- min (0 - 59)
```

### gdb

```bash
gdb                                 # for debugging of code
```

in gdb:

```gdb
gdb$ file <path/filename>           # loads executable into memory
gdb$ set disassembly-flavor intel   # pass args for assembler intel instead at&t
gdb$ run arg1 arg2                  # executes program (a simple "run" without args is enough)
gdb$ list                           # shows code (works with linenumber too)
gdb$ break <file><line>             # stopps at line in file of the program <file> is optional
                                    # also works in C with <function>
gdb$ list 4, 9                      # shows line 4-9
gdb$ continue                       # run until the next break
gdb$ next                           # evaluate single line, stay inside level
gdb$ step                           # next line, jump to function
gdb$ finish                         # end function, return to call
gdb$ backtrace                      # show stack of function calls
gdb$ print <x>                      # show variable x
gdb$ set var <x> = <value>          # assign value to variable
gdb$ disassemble <function>
gdb$ info registers                 # see whats in the registers
gdb$ print/x $eax                   # look into register
gdb$ info stack                     # what's on the stack?
gdb$ info float
gdb$ x/90xb main

gdb$ kill
gdb$ quit
```

With `layout asm` and `layout reg` enabled, gdb will highlight which registers changed since the last stop. Use `stepi` to single-step by instructions. Use  `x` to examine memory at a given address (useful when trying to figure out why your code crashed while trying to read or write at a given address). In a binary without symbols (or even sections), you can use `b *0` to get gdb to stop before the first instruction.

Another key tool for debugging is tracing system calls. e.g. on a Unix system, `strace ./a.out` will show you the args and return values of all the system calls your code makes.

### archives & backup

`tar tvf filename.tar` view the table of content of a tar archive\
`tar xvf filename.tar` extract content of a tar archive\
`tar cvf filename.tar file1 file2 file3` create a tar archive called filename.tar using file1, file2,file3

tar can’t copy special files or device files. So it os not suitable for taking a root backup. For that we use cpio:\
cpio can copy special files and is useful in taking root backups containing device files.\
cpio is mostly used in conjunction with other commands to generate a list of files to be copied

`ls | cpio -o > /dev/rmt/c0t0d0`            # copy the contents of a directory into a tape archive\
`find . -depth -print | cpio -pd newdir`    # copy entire directory to another place\
`find . -cpio /dev/rmt/c0t0d0`              # copy files in current directory to a tape

### install from source

`wget <url>` downloads the file

`tar -xvf <filename>` unpacks the archive

### htop & s-tui

`top` gives us a overview about what is happening\
with `pip install s-tui` you can get a nice overview about what's happening with your cpu, power and temperatures\
also very very nice is the paket `htop` (`dnf install h-top`), that gives you a complete summary of all running processes and the possibility to filter em accordingly

### logkeys - keylogger

```bash
touch test.log
logkeys -s -o <patch>/logfilename.log     # keylogging start in <path><file>
tail --follow <path><test.log>            # look whats happening to your lock in another terminal
logkeys -k                                # stop keylogging
```

### shark

network traffic

```bash
tshark -D                             # shows all devices
tshark -i <number>                    # captures on device-number
tshark -Y http                        # shows http-events
tshark - Y "dns.flags.response ==0!   # shows queries on dns
```

### gnome

some commands available on gnome-desktop

```bash
gnome-tweak-tool
gnome-session-quit --logout --force
gnome-font-tool

wmctrl -l                           # shows window-list
wmctrl -r "programname" -t 1        # moves window to workspace 1 (begins at 0)

gnome-system-monitor                # shows cpu usage

gconf-editor

gconftool-2 -R /desktop/gnome       # show some desktop options

tracker daemon                      # tracker indexes disk for faster search
tracker daemon -f                   # shows what tracker is doing
tracker status
```

```bash
tracker daemon -t
cd ~/.config/autostart
cp -v /etc/xdg/autostart/tracker-* ./
for FILE in tracker-*.desktop; do echo Hidden=true >> $FILE; done
rm -rf ~/.cache/tracker ~/.local/share/tracker
```

to switch off tracker see this [gist](https://gist.github.com/vancluever/d34b41eb77e6d077887c)

```bash
firewall-config
system-config-firewall
system-config-keyboard
```

ad that time is was using 3 gnome-workspaces

### scripts .sh

```bash
chmod +x <script-name>          # to make scripts executeable
ls -l script-name-here          # list rightsof the script
mkdir $HOME/.bin                # It is a good idea to create your own bin directory
export PATH=$PATH:$HOME/.bin    # Add $HOME/bin to the PATH variable using bash shell export command
echo $PATH
mv script.sh $HOME/.bin         # Move script.sh in $HOME/.bin, scripts can be executet from anywhere now
```

[Bash-scripting for beginners](https://wiki.ubuntuusers.de/Shell/Bash-Skripting-Guide_f%C3%BCr_Anf%C3%A4nger/) (german)

```bash
scriptname &>/dev/null          # silenced a scripts output
```

some small example scripts:

1. atom.sh:

    if I alias that script I can start atom with `atom`. When the window is opened it gets moved to desktop 2

    ```bash
    #!/bin/bash

    atom &
    xdotool search --name --sync --onlyvisible "Atom" | echo "Waiting for Atom to start up"
    wmctrl -r "Atom" -t 1
    ```

2. ftl.sh

    runs the game faster-then-light

    ```bash
    #!/bin/bash

    # enter the game directory
    cd ~/gamedir/FTL\ Faster\ Than\ Light/
    cd ./data

    # run FTL
    exec ./FTL "$@"
    ```

### SELinux - Security Enhanced Linux

SELinux -> `sestatus` see the status of security enhanced linux

`getsebool -a` shows which booleans are turned on or off\
`setsebool -P <booleanname> 0|1`  # 0 or 1 -P makes changes permanent

you can look up errors in `/var/log/messages` OR in `/var/log/audit/audit.log` (if audit is installed)\
if a boolean gets changed, he shows up in (no changes allowd, read only!): `/etc/selinux/targeted/modules/active`

several commmands have a -Z command for SELinux options, e.g: `ls -Z` shows SELinux-spezific fileattributes\
also available with `ps -Z`, `netstat -Z`, `id -Z`, `cp -Zv`, `mkdir -Z`

`chcon` changes `<file>` [SELinux security context](https://linux.die.net/man/1/chcon)\
`chcon --reference <sourcePath> <targetFile>`\
`restorecon -v R <path>` resets the `<path>` to SELinux defaults (R = recursive -v= show changes)

`semanage fcontext -a -t <type> "<path>(/.*)?"` (-a =adds [we want to add]) fcontext= filecontext) `<type>` is the type we want to allow in `<path>` and for everything inside `<path>`\
OR\
`semanage fcontext -a -e <sourcePath> <targetPath>` creates a rule, to change the context from source to target\
    e.g: `semanage fcontext -a -e /var/www/ /foo/`\
    "Hey SELinux, the FOO-Directory should be the same as /var/www .."\
    after that, we run `restorecon -VR /foo/` and it changes the default type to the wished (httpd here) type!

`setenfroce 0` disables SELinux temporily ATTENTION -> security relevance\
with `grep httpd /var/log/audit/audit.log | audit2allow -M <app_and_rule_name>` we create a policy-package (here: for httpd) /// maybe use `ausearch` here too\
and install the policy-modul after that with `$ semodule - i <app_and_rule_name>.pp`\
`setenfroce 1` finally reactivates SELinux

to enable SELinux on a system edit `/etc/selinux/config` and set `SELINUX=permissive` then `touch /.autorelabel` and reboot\
after everthing is done reboot clean again, then set `SELINUX=enforcing` in `/etc/selinux/config` and reboot a third time!

### atom editor

using atom causes an error with linter and other autocompletes, here is the fix:\
(in `/usr/share/applications/atom.desktop` change `Exec=/usr/share/atom/atom %F` to `Exec=/usr/bin/atom %F`)\
[issue](https://github.com/atom/atom/issues/13451)

you may add `WORKSPACE-NUMBER=2` in atom.desktop to open it on the second desktop (I prefer using the second desktop for atom, dunno why)

`xdotool search --name --onlyvisible --sync "Atom"` waits for a return-value until the window is open (I use it in my scripts, above)\
see [xprop](https://www.x.org/releases/X11R7.5/doc/man/man1/xprop.1.html) & [xwininfo](https://linux.die.net/man/1/xwininfo)

### VLC

```bash
get-rpm-fusion extended repository (ATTENTION: foreign repos may hold security risks)
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

dnf install vlc
dnf install python-vlc npapi-vlc  #(optionals)

cvlc -d <url>                   # webservice silent in background
cvlc /PATH/TO/TRACK             # single track
clvc --play-and-exit <path>
rvlc                            # vlc-cli
vlc -v <URL-DES-STREAMS> --sout=file/mp4:Videos/Datei.mp4     # record stream to file
killall vlc                     # end /  kill vlc
```

`alsamixer` reduce the volume here to avoid clipping

there may be soundproblems, I fixed some of them playing around with some parameters in `/etc/pulse/daemon.conf` ATTENTION: high CPU-usage!

```daemon.conf
default-fragments = 5
default-fragment-size-msec = 24
```

don't forget to remove the comments `;`

`pulseaudio -k` then restart pulseaudio from bash

what did not help:

```bash
shm-size-bytes
default-sample-rate = 48000
resample-method = speex-float-5
```

Links:\
[Pulse Audio Configuration](https://wiki.archlinux.org/index.php/PulseAudio/Configuration)\
[Pulse Audio how-to](https://proaudio.tuxfamily.org/wiki/index.php?title=PulseAudio#PulseAudio)\
[Pulse Auio Troubleshoot](https://wiki.parabola.nu/PulseAudio/Troubleshooting)\
[Pule Audio Man-Page](https://www.systutorials.com/docs/linux/man/5-pulse-client.conf/)

### Email with MUTT

~/.muttrc

```.muttrc
## General options
set header_cache = "~/.cache/mutt"
set imap_check_subscribed
set imap_keepalive = 300
set mbox_type=Maildir

## ACCOUNT1
source "~/.mutt/exchange"
# Here we use the $folder variable that has just been set in the sourced file.
# We must set it right now otherwise the 'folder' variable will change in the next rced file.
folder-hook $folder 'source ~/.mutt/exchange'


# Store message headers locally to speed things up.
# If hcache is a folder, Mutt will create sub cache folders for each account which  speeds things up even more.
set header_cache = ~/.cache/mutt

# Store messages locally to speed things up, like searching message bodies.
# Can be the same folder as header_cache.
# This will cost important disk usage according to your e-mail amount.
set message_cachedir = "~/.cache/mutt"

# Allow Mutt to open a new IMAP connection automatically.
unset imap_passive

# Keep the IMAP connection alive by polling intermittently (time in seconds).
set imap_keepalive = 300

# How often to check for new mail (time in seconds).
set mail_check = 120

# If you start mutt and several new messages are in your inbox and you close
# mutt before you have read them, then those messages will get flagged as old.
set mark_old = no
```

~/.mutt/exchange\
(replace values inside <> with your values)

```.mutt/exchange
## General options
set folder      = imaps://<imapwebadress:port>
set imap_user   = <username>
set imap_pass   = <password>
set spoolfile   = +INBOX
mailboxes       = +INBOX

set postponed = +Drafts
set record = +Sent

## Send options.
set smtp_url=smtps://<fullsmtpadress:port>/
set smtp_pass="$imap_pass"
set from=<emailadress>
set hostname="<hostname>"

# Connection optionsi
set ssl_starttls=yes
set ssl_force_tls = yes
#unset ssl_starttls

## Hook -- IMPORTANT!
account-hook $folder "set imap_user=<username> imap_pass=<password>"
```

### several bugfixes

on reboot1\
-> systemctl rnfg.service does fail to start:

```bash
cp /usr/lib/systemd/system/rngd.service /etc/systemd/system/rngd.service
# change line 5 to:
ExecStart=/sbin/rngd -f -r /dev/urandom -o /dev/random

systemctl daemon-reload
systemctl stop rngd
systemctl start rngd
systemctl status rngd
```

Error with initializing vbox after kernel-update:\
try recreating initial ramdisk images (initramfs) for preloading modules

```bash
dracut -v -f         # -f = forces overwrite, -v = verbose mode
```

the amount of kernels to be kept is in `/etc/dnf/dnf.conf`, set to two `installonly_limit=2`
