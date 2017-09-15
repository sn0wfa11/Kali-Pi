# Install Full Kali Linux on a Raspberry Pi
For installing Kali Linux on a Raspberry Pi, I would strongly recomend a Raspberry Pi 3 with a very fast SD card. I am currently using the Samsung Pro 64 GB micro SD card that can be found at the following:

https://www.amazon.com/gp/product/B012DTJ8NU/ref=oh_aui_search_detailpage?ie=UTF8&psc=1

## Download the Image
Look for the RaspberryPi 2 /3 Image

https://www.offensive-security.com/kali-linux-arm-images/

## Setup onto SD Card Using Win32DiskImager
Use Win32DiskImager to transfer the image over to your SD Card. This is a fairly easy app to use. However, make sure you are selecting the correct drive!!! This can wipe out thumb drives if you have one plugged in and do not pick the correct drive.

## Exapand the root FS
After the SD Card is imaged it will not be using the entire space. Kali will not size it for you like Raspbian will, so you will need to do it manually. Below is far and above the easiest way I have found to do the resize. No scripts, no errors, no fuss.

**Pre Req. You need to have Kali x86 or x64, or a Linux machine with gparted available.**

- Boot up the Kali-pi the first time to get things setup.
- Shut it down, and pull out the memory card.
- Mount the SD card in Kali Linux x86 or x64. (A VM or physical machine, does not matter.)
- Open gparted
- Expand partition to use the full SD card.
- Apply all operations.
- Unmount the SD card.
- Put the SD card back into the pi and boot up.
- Enjoy.

## Install Kali Full
To install the full Kali package list use the below commands. You may get some dpkg dependency errors during the upgrade commands. These will be resolved when you do the kali-linux-full install. Don't waste time trying to fix them.

```
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
reboot
apt-get install kali-linux-full
```

## Generate New SSH Keys
**Make sure you do this! The standard image will have known keys!**

```
rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server
service ssh restart
```

## Fix xfce Clock
Remove it from the top bar and add it back in... Easy fix...

## Fix TimeZone Issue
`dpkg-reconfigure tzdata`

Then select the correct timezone. You may have to reboot.

https://www.cyberciti.biz/faq/howto-linux-unix-change-setup-timezone-tz-variable/

## Fix Language Problem
Try this first:

`dpkg-reconfigure locales`

If that doesn't work do this:

```
echo "export LANGUAGE=en_US.utf8
export LANG=en_US.utf8
export LC_ALL=en_US.utf8" > $HOME/.i18n
```

https://unix.stackexchange.com/questions/167794/how-to-change-language-interface-in-xfce
