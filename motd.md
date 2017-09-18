# Dynamic MOTD.
Debian, which Kali is based on, has the functionality for dynamic message of the day "MOTD" operation but it is not enabled by default. 

Fortunately, it is pretty easy to setup and has some really cool things that you can do with it especially for something like or Kali-Pi's.

## Enable Dynamic MOTD
If you already have a cool MOTD, it would be best to copy it to your `/root` directory, and you can easily recreate it here in a bit.

`cp /etc/motd /root/`

- First we need to create the new MOTD update directory.

`mkdir /etc/update-motd.d/`

- Remove the old MOTD file

`rm /etc/motd`

- And create a symbolic link to the new setup

`ln -s /var/run/motd /etc/motd`

That's it for back end work. Now we can start building our dynamic MOTD scripts!

## Background information
The new MOTD system uses bash scripts placed into `/etc/update-motd.d/`. The filenames need to start with numbers (even numbers seem to work best) and then have a lowercase description. The files are executed in order based on the number prefixes. An example would be:

```
10-header
20-uptime
```

Files need to be executable to be run by the MOTD system. If you do not want specific files executed, remove executable rights and they will be skipped.

`chmod 0755 10-header`

This new MOTD system is enabled by default in Ubuntu. You can use examples they have as a reference too.

## Install figlet and fonts
I like to have cool MOTD headers and one of the best ways to do that is to use a tool called figlet. You can install it using:

`apt install -y figlet`

To get additional fonts, just run the following:

```
mkdir -p $HOME/git
cd $HOME/git
git clone https://github.com/xero/figlet-fonts
cd figlet-fonts
mv * /use/share/figlet/
cd $HOME/git
rm -rf /figlet-fonts/
```

Now you can do really cool stuff like:

`figlet -w 120 -f "ANSI Shadow" kalipi`

Which produces: (It looks better in your console, github spaces things poorly...)

```
██╗  ██╗ █████╗ ██╗     ██╗██████╗ ██╗
██║ ██╔╝██╔══██╗██║     ██║██╔══██╗██║
█████╔╝ ███████║██║     ██║██████╔╝██║
██╔═██╗ ██╔══██║██║     ██║██╔═══╝ ██║
██║  ██╗██║  ██║███████╗██║██║     ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝
```

Usage: 

`figlet -w <width in chars> -f "<FontName>" <Message>`

The fonts can be found in `/usr/share/figlet/`

You can test out what you want it to say at http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20 The fonts are the same on this site.

Man page: http://www.figlet.org/figlet-man.html

## Build header script
The first script to build is your header which I like to have the host name in a cool font and maybe a message.

```
cd /etc/update-motd.d/
nano 10-header
```

Here is an example from one of my Kali-Pi's

```
#!/bin/bash

printf "\n"
figlet -w 120 -f "ANSI Shadow" kalipi
figlet -w 130 -f "Star Wars" "Don't Panic"
printf "\n"
printf "Or do... Makes no difference to me!\n\n"
```

Save and exit.

Now make the file executable.

`chmod 0755 10-header`

You can logout and ssh back in to see what it looks like.

## Additional Scripts
Here are some additional scripts you can use to provide you with usefull info when you log in.

Anything you can do in a bash script can be done here, the sky's the limit... Enjoy.

### Uptime
`nano 20-uptime`

```
#!/bin/bash
upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
printf "[*] Uptime: %d days %02d hours %02d minutes %02d seconds\n\n" "$days" "$hours" "$mins" "$secs"
```

`chmod 0755 20-uptime`

### IP Information
`nano 22-ipinfo`

```
#!/bin/bash
printf "[*] IP Information\n"
ip -f inet -o addr | grep -v '127.0.0.1' | awk -F " " '{print $2" "$4}' | cut -d "/" -f 1
printf "External: "
dig +short myip.opendns.com @resolver1.opendns.com
printf "\n"
```

`chmod 0755 22-ipinfo`

### Secure partition mounted
This is nice if you are using an encrypted partition as described [here](https://github.com/sn0wfa11/Kali-Pi/blob/master/secure_storage.md) becasue it will tell you if the encrypted partiton is unlocked and mounted or not.

`nano 24-secstorage`

```
#!/bin/bash
check=$(mount | grep -c /root/secstorage)
if [ $check -ge 1 ]; then
  printf "[*] Secure Storage is Mounted at /root/secstorage\n"
else
  printf "[*] Secure Storage is not Mounted.\n"
fi

printf "\n"
```

`chmod 0755 24-secstorage`
