<h1 align="center">
construct-grub
</h1>
<p align="center">
A GRUB theme intented to be used in conjunction with construct-plymouth.
</p>

![Image preview of the construct-grub theme](construct-grub-concept.png)

---
# Installation
~~I'm not good enough at Shell to make an install script~~ This theme now has an accompanying install script!
- Clone the repo `git clone https://github.com/Olocool17/construct-grub`
- Configure the file `/etc/default/grub` to your liking. Items that may be of relevance are `GRUB_TIMEOUT`, `GRUB_DISABLE_SUBMENU` and kernel parameters in `GRUB_CMDLINE_LINUX_DEFAULT` . Make sure `os-prober` is installed,
configured and enabled if you want to include other operating systems in the boot menu.
- Go into the repo directory `cd construct-grub`
- Run the installation script `sudo ./install.sh` , or `sudo ./install.sh legacy` if you want to install [construct-legacy-grub](construct-legacy-grub-concept.png)
- Manually edit `/boot/grub/grub.cfg` if you want to customise your boot menu entries further. Be careful editing this file: you may break your bootmenu.
- Your local repository can now be deleted safely `rm -r construct-grub`
# Credits
General inspiration for the theme came from the existing GRUB theme [Big Sur](https://github.com/Teraskull/bigsur-grub2-theme), and its icons were shamelessly transferred over. Its install script was also adapted for this theme.
