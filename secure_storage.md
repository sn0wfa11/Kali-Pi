# Add Encrypted Storage for your Kali-Pi!
These instructions will walk you through creating an encrypted partition on your Kali-Pi's SD card.

You can use this parition to store data such as private keys or Open VPN connection files that you don't want others to access if they find this device.

**WARNING #1** The normal filesystem on the SD Cards for Raspberry Pi's are not encrypted! Anyone can plug the card into a Linux machine and read your files.

## Intial Preperation
- Start by backing up any data or setting you have on your device. Since we are going to be messing with the partition tables this is always a good idea.

- Power off your Kali-Pi if it is running.

- Remove the SD card from the Pi device.

- Mount the SD card in Kali on a PC or VM (Ubuntu or Debian will work too as long as it has gparted and cryptsetup)

## Creating a partition to be encrypted
- Open gparted and select the SD card device.

- **Important!** Make note of the device label as you will need it later. For this example my SD card label is `/dev/sdb`

- Right click on `/dev/sdb2` and select `unmount` so that you can make changes to the card.

- If you used the instructions from the intial setup instructions you should have no free space and almost all of your SD card used by partition `/dev/sdb2`.

- Right click on `/dev/sdb2` and select `Resize`. Change the size of this partition so that you have free space at the end of the disk. I use 64 GB cards, so I usually leave about 16 GB of free space at the end of the disk. It's probably overkill, but hey, space is space!

- Right click on the new empty space and select `New`.

- In the `Create New Partition` window, change the File System Type to `unformatted` and click `Add` at the bottom. (We will format it here in a bit.)

- On the main gparted window, click `Edit` and select `Apply All Operations` then `Apply` in the dialog box.

- Once completed you should see a new partition at the end of the disk. In my case it was `/dev/sdb3`. Make a note of this partition name.

- Close gparted

## Setup and Format Encrypted Partition
The rest of the instructions are from the command line.

- Open a new terminal window

- Initialize the Encrypted Volume

**WARNING 2: Make sure you have the correct drive and partion label!!! This will delete your data if you do not!!!**

`cryptsetup --verbose --verify-passphrase luksFormat /dev/sdb3`

Select a good password or passphrase. **Don't use the same password as root or any user on the Pi!!!** Since `/etc/shadow` could be readable by anyone with physical access to the Pi they could crack those passwords!!!

Also, if you plan to use a script or other type of automated password entry, avoid special characters such as `\` and `$` as bash will filter them out when using the echo command used in thoes scripts. 

You can test your password by doing: `echo <password>` and see if what comes out matches your password.

- Open the newly created volume (Use the same password you entered above.)

`cryptsetup luksOpen /dev/sdb3 my_usb`

- Format and Label the partition inside the encrypted volume

```
mkfs.ext3 -L secstorage /dev/mapper/my_usb
e2label /dev/mapper/my_usb secstorage
```

- Close the volume so you can put it back into your Pi

`cryptsetup luksClose /dev/mapper/my_usb`

- Safely remove the SD card from your computer and insert it back into your Pi device.

## Mounting the new encrypted partition
- From either SSH or through the `shell` command from a Metaspliot Meterpreter session you will need to run the following commands to mount the encrypted partition.

- Start by identifying the label of the SD card as it is probably not `/dev/sda`.

`cat /etc/fstab`

Look for the device mounted to `/`. The line you are looking for should look something like this:

`/dev/mmcblk0p2  / ext4 errors=remount-ro 0 1`

Since partition 2 is the mounted as root and partition 1 is usually `/boot` our new partion should be `/dev/mmcblk0p3`.

- Open the encrypted volume (Similar to above but note the different partition label and mount point.)

`cryptsetup luksOpen /dev/mmcblk0p3 sec_store`

Use the same password you selected during setup.

- Make a new mount point in root's folder (Or select your own.)

`mkdir -p /root/secstorage`

- Mount the partion to this mount point

`mount /dev/mapper/sec_store /root/secstorage`

And it is good to use. Some notes on usage are below.

I have provided a bash script to make mounting the encrypted partition easier. It is located here:

https://github.com/sn0wfa11/Kali-Pi/blob/master/mount_encrypted.sh

I will be adding a Metasploit Module to do the same thing soon.

- If you need to unmount the partion use the following commands:

```
umount /dev/mapper/sec_store
cryptsetup luksClose /dev/mapper/sec_store
```

- If you need to change the password use the following commands:

```
umount /dev/mapper/sec_store
cryptsetup luksClose /dev/mapper/sec_store
cryptsetup --verbose --verify-passphrase luksChangeKey /dev/mmcblk0p3
```

## Using the encrypted partiton
- Storage of openvpn connection files is as easy as saving them to `/root/secstorage` or any subfolder in the directory.

- If you want to store an SSH private key, you need to take a few extra steps.

- If you do not have an SSH private/public key pair for this Kali-Pi you can generate one using the following:

`ssh-keygen -t rsa -b 4096 -C "<username>@<host>"`

Leave the password blank.

Add the new private key to your local identity:

`ssh-add ~/.ssh/id_rsa`

Now to move the private key to the secure storage and make a symbolic link to reference it from `.ssh`

```
cd secstorage/
mkdir -p ssh
chmod 0700 ssh
mv /root/.ssh/id_rsa /root/secstorage/ssh/
ln -s /root/secstorage/ssh/id_rsa /root/.ssh/id_rsa
```

Now you can use public key authentication to ssh back into your own machine from the Kali-pi without having to worry about anyone getting unauthorized access to the private key. Pulling the power or removing the card will unmount and lock the encrypted partition.

All you need to do is copy the public key from the Kali-pi into `/root/.ssh/authorized_keys` on your machine. You may need to activate public key authentication in `/etc/ssh/sshd_config`.
