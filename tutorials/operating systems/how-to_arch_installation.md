# Arch Linux Installation

> How-to install arch linux

THIS TUTORIAL IS IN NO WAY COMPLETE NOR TESTET. NO WARRANTIES

## Content

- [Preparations](#preparations)
- [Installation](#installation)

---

## Preparations

Set environment variables to your needs.

$your_hostname
$your_username
$your_password

// TODO: create installation script
// TODO: make tutorial howto use it with arch-shell & the dotfile repo (e.g: wget install-script and settings.json)
// TODO: make script versatile with its options:

- partition sizes etc..
- partition names
- language used
- keyboard locales
- bootmanager
- be flexible to use either kde/gnome/xfce UIs
- list of packages to install in packages.json

## Installation

```shell

loadkeys de-latin1  # keyboard locale
setfont lat9w-16
wifi-menu
timedatectl status
lsblk
```

configure partitions `mklabel msdos` or `mklabel gpt` then: `mkpart`

```shell
parted /dev/sda print

(parted) mkpart primary ext4 1MiB 100MiB
(parted) set 1 boot on
(parted) mkpart primary ext4 100MiB 20GiB
(parted) mkpart primary linux-swap 20GiB 30GiB
(parted) mkpart primary ext4 30GiB 100%
(parted) print
(parted) quit

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda4

mkswap /dev/sda3
swapon /dev/sda3

mount /dev/sda2 /mnt

mkdir -p /mnt/boot
mkdir -p /mnt/home

mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home

pacstrap /mnt base
pacstrap /mnt base-devel
pacstrap /mnt wpa_supplicant

```

The filesystem is *installed*

```shell

genfstab -p /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

arch chroot /mnt/

echo $your_hostname > /etc/hostname                     # hostname locale
echo LANG=de_DE.UTF-8 > /etc/locale.conf                # language locale
echo LANGUAGE=de_DE >> /etc/locale.conf                 # language locale
echo KEYMAP=de-latin1 > /etc/vconsole.conf              # keymap locale
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime  # timezone locale

```

Uncomment the used encoding

```shell
nano /etc/locale.gen
    #de_DE.UTF-8 UTF-8
    #de_DE ISO-8859-1
    #de_DE@euro ISO-8859-15
    #en_US.UTF-8
```

Config the bootloader

```shell
mkinitcpio -p linux

passwd <$your_password>

pacman -S dialog iw
pacman -S grub  
grub-mkconfig -o /boot/grub/grub.cfg
grub-install /dev/sda

exit
umount /dev/sda1

reboot
```

create Wifi config from `/etc/netctl/examples` (copy to) `/etc/netctl` and edit.
`ip link` for ar list of devices, ssid & key should be known by you :)

```shell
netctl list  # should show Wifi in list now
netctl enable WLAN
netctl start WLAN
```

set up your user

```shell
useradd -m -g users -s /bin/bash $your_username
passwd $your_username
pacman -S sudo
nano /etc/sudoers   # uncomment `#%wheel ALL=(ALL) ALL` #or better just: `visudo`
gpasswd -a $your_username wheel
gpasswd -a $your_username audio
gpasswd -a $your_username video
gpasswd -a $your_username power
# and other groups you want to belong to..

pacman -S acpid ntp dbus avahi cups cronie
systemctl enable acpid
systemctl enable ntpd
systemctl enable avahi-daemon
systemctl enable org.cups.cupsd.service
systemctl enable cronie

pacman -S ntp
nano /etc/ntp.conf # set-up the network-time-protocol-server: e.g: [server de.pool.ntp.org]
date
hwclock -w

pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils

lspci |grep VGA
```

If it's an intel driver:

```shell
nano /etc/mkinitcpio.conf  # (MODULES="i915")
mkinitcpio -p linux

pacman -S xf86-input-synaptics
```

Fonts

```shell
pacman -S ttf-dejavu
pacman -S ttf-bitstream-vera
pacman -S ttf-inconsolata
pacman -S ttf-liberation
pacman -S ttf-linux-libertine
pacman -S terminus-font

pacman -S plasma kde-l10n-de
pacman -S kde-applications
pacman -S sddm
pacman -S sddm-kcm

localectl set-x11-keymap de pc105 de_nodeadkeys  # BUG maybe: nodeadkeys ??

pacman -S alsa-utils
gpasswd -a $your_username audio
alsamixer  # activate master (M!)

pacman -S guake
pacman -S  # install other packages too (office, thunderbird, chromium, vlc, kaffeine, amarok, k3b etc..)
pacman -S kdeplasma-applets-plasma-nm
```

insert to `nano /etc/sudoers`

```shell
/ Defaults insults  # BUG maybe: what do I mean here?
```

insert this to `nano /usr/share/config/kdesurc`

```shell
    [super-user-command]
    super-user-command=sudo
```

```shell
sddm --example-config > /etc/sddm.conf


logout
$your_username
$your_password

yaourt -S sddm-theme-archpaint2-breeze
yaourt -S sddm-theme-futuristic
yaourt -S plymouth

```

install remaining packages

```shell
yaourt -S foxitreader
pacman -S putty audacity p7zip
```

Now `nano /etc/mkinitcpio.conf`

```shell
HOOKS="base udev plymouth [...] "  # MODULES="i915"

mkinitcpio -p linux

plymouth-set-default-theme -R <theme>

systemctl enable sddm  # if it's all working :P

```

voilá
