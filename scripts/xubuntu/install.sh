# for boot-problems, evtl: sudo update-grub

# 1. set-up a new ssh-key
ssh-keygen -t rsa -b 4096 -C "Some comment"
# <enter> for default-path, choose a password
    # to login without password from your pc write into ~/.ssh/config
    # Host testtop
    #     HostName 192.168.1.17
    #     Port 22
    #     User oryon
    #     IdentityFile ~/.ssh/id_rsa_TESTTOP
    #     ForwardAgent yes
    #     ForwardX11 yes


# 2. open a ssh-server-connection
sudo apt update
sudo apt install openssh-server
sudo systemctl status ssh  # should return active(running)
# you may now ssh into the computer via your best configured machine via "ssh username@hostname"

# 3. There you go, installing all the stuff..
# TODO: copy the key from ~/.ssh/.. -> add that key to github
sudo apt install git
git clone <ssh:reponame ... > # TODO: hardcode clone of settings repo



# 4. run the install-script for your distribution (TODO: create working install-scripts)
############### INSTALL SCRIPT FOR XUBUNTU #########
# virtualenvwrapper
sudo apt-get install python-pip
sudo pip install virtualenv
mkdir ~/.Envs
sudo pip install virtualenvwrapper
export WORKON_HOME=~/.Envs
echo ". /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc

# development C-build-tools
sudo apt-get install python-dev python3-dev python3.7-dev
# TODO: create a local basic venv move to your config dir and pip install -r requirements.txt

# vscode
sudo apt update
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code
# TODO: vscode settings from settings-gist

# guake-terminal
sudo apt-get install guake

# TODO: guake config

# TODO: fish install
sudo apt-get install fish
chsh -s /usr/bin/fish
# TODO: fish setup
# TODO: fish config

# TODO: aliases and dotfiles.. and folder & project-structure

# x-server
# in /etc/hosts: 192.168.1.26 pythia # correct ip!
export DISPLAY=pythia:0.0
