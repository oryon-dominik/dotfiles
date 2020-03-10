# NixOS Installation

> How-to install nixos linux

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#preparations)
- [Installation](#installation)

---

## Preparations

Load the (minimal) installer via live-cd or usb

## Installation

as the nixos user, provided by the minimal startup

If you're using a hyper-V VM, create a more performant virtual disk with

```powershell
New-VHD -Path D:\systems\hyperV\nixos.vhdx -SizeBytes 100GB -Dynamic -BlockSizeBytes 1MB
```

and read the [best-practices for linux on
hyper-v](https://docs.microsoft.com/de-de/windows-server/virtualization/hyper-v/best-practices-for-running-linux-on-hyper-v)
as well as the [nix-os hyper-v
tutorial](https://github.com/NixOS/nixos-hardware/tree/master/microsoft/hyper-v)

```shell
# german keyboard layout
sudo loadkeys de
# show the devices available for the installation
lsblk
# we assume you've choosen /sda

# setup the ssh-deamon to manipulate the config files via ssh later on
sudo systemctl start sshd
passwd nixos  # let's take "test" here..

# we don't want to type sudo before every command, so we sudo us as root
sudo su
```

Carefully follow the [installation steps](https://nixos.org/nixos/manual/index.html#sec-installation)

and install the [partitioning with UEFI](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning-UEFI)

now [format the
disks](https://nixos.org/nixos/manual/index.html#sec-installation-partitioning-formatting)
(for the hyper-v variant add the option `-G 4096` : `mkfs.ext4 -L nixos /dev/sda1
-G 4096`)

Follow the [installation tutorial]https://nixos.org/nixos/manual/index.html#sec-installation-installing) till step 5 to complete installation and disk setup

example:

```bash
# partitions
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 1024MiB -16GiB
parted /dev/sda -- mkpart primary linux-swap -16GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 1024MiB
parted /dev/sda -- set 3 boot on
# formatting
mkfs.ext4 -L nixos /dev/sda1  # or on hyperV: `mkfs.ext4 -L nixos /dev/sda1 -G 4096`
mkswap -L swap /dev/sda2
swapon /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
# installation
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
```

now edit the `/etc/nixos/configuration.nix` (nano or vi) and paste

```/etc/nixos/configuration.nix
## HYPER-V
# REQUIRED - see: https://github.com/nixos/nixpkgs/issues/9899
boot.initrd.kernelModules = ["hv_vmbus" "hv_storvsc"];
# RECOMMENDED
# - use 800x600 resolution for text console, to make it easy to fit on screen
boot.kernelParams = ["video=hyperv_fb:800x600"];  # https://askubuntu.com/a/399960
# - avoid a problem with `nix-env -i` running out of memory
boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421


# german keyboard
console.keyMap = "de";

# add git to be able to clone the repo
environment.systemPackages = with pkgs; [
    wget vim gitMinimal
];

```

`nixos-install`

Set the root password

`reboot`...

```bash
loadkeys de
```

```bash
# check your channel
nix-channel --list
# collect and delete garbage
nix-collect-garbage -d
# interactive exploration of the config
nix repl '<nixpkgs/nixos>'  # quit with ctrl+d or ':q'
# list some packages
nix-env -qaP '*' --description



## delete the config and git clone your repo
git clone <url> /etc/nixos
sudo nixos-rebuild switch
```

BUG: x-server geht nicht mit hyper-V
