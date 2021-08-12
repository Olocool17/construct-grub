# construct-grub
A GRUB theme intented to be used in conjunction with construct-plymouth.
# Installation
I'm not good enough at Shell to make an install script, so unlike most other fancy themes installation must be done manually.
- Clone the repo into /boot/grub/themes
- Add `GRUB_THEME = /boot/grub/themes/construct-grub/theme.txt` to `/etc/default/grub`
- Use your distro's flavour of `grub-mkconfig` / `update-grub` , outputting to `/boot/grub/grub.cfg`
- Manually edit `/boot/grub/grub.cfg` so that the GRUB command `background_image /grub/themes/construct-grub/background.png` takes place after theme loading (and gfxterm)
- Add `--class EXAMPLE` to the various menuentries where EXAMPLE is a placeholder for the filename of the corresponding icon.
